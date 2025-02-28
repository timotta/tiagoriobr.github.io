---
layout: post.html
title: "Patching scikit-learn to improve API performance"
tags: [work, willbank, account]
path1: work
path2: willbank
path3: account
---

This week at Will Bank, we deployed a new machine learning model to compete with the one we introduced into production late last year. Offline evaluations showed promising results, with a 35% improvement in the target metric and a cumulative gain of 60% compared to the solution that preceded last year’s model.

However, during the initial deployment of this new model—where we logged the results without impacting end users—we observed a significantly higher computational cost compared to the previous model. The API response time at the 99th percentile was 260% higher than that of the previous model.

Indeed, the new model used more features, and the selected hyperparameters of the [XGBoost](https://xgboost.readthedocs.io/en/stable/) classifier indicated the use of more estimators and greater depth in the trees. Furthermore, the size of the model was significantly larger than the previous model. We had moved from a model of approximately 150kb to one of about 4mb in pickle format.

This larger size made complete sense as we had added some categorical features with a greater diversity of values. Since we used [TargetEncoder](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.TargetEncoder.html) and [OneHotEncoder](https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html) to handle these features, and these preprocessing steps are part of the persisted [Pipeline](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html), all possible categories would be saved in the final pickle, resulting in a much larger file.

We did not expect this to be the cause of the slowdown, as a category lookup in the TargetEncoder or OneHotEncoder should be O(1), likely using a dictionary to store the valur for each category. As a result, we initially ruled out model size as a contributing factor to the issue.

We then proceeded to evaluate whether the cause of the slowness was the deeper hyperparameters of XGBoost.

I then retrained the model with softer parameters to speed up the results with a smaller amount of data. The result of this retraining was a much more performant model. I could conclude here that I had found the cause of the problem: the hyperparameters. But there was one more difference in the experiment setup: the amount of data.

With this in hands I decided to put it to the test and repeated the hyperparameters of the problematic model, training with a small amount of data, and the model performed just as well as the one with smoother hyperparameters. In other words, the hyperparameters were not the cause of the slowness.

I changed the approach to this analysis and decided to break down the problematic model by testing the execution time of each step in the Pipeline. Here, we benefit from the flexibility and standardization of the Pipelines and steps in [scikit-learn](https://scikit-learn.org/stable/). As a result, it was possible to observe that it was indeed the TargetEncoder of a single column that was causing 95% of the computational cost of the model. And it was precisely for the feature that had the highest variety of categories.

This didn't make sense to me; the number of different categories shouldn't be causing performance issues. In my mind, looking up the calculated value would be done in dictionary O(1) time. So, I decided to investigate the code of the TargetEncoder from scikit-learn.

As soon as I began reading the code, I realized that there was no category-value map as I had assumed. Instead, the implementation used two separate lists—one for categories and another for values. It appears that this [transformer](https://scikit-learn.org/stable/modules/generated/sklearn.base.TransformerMixin.html) is optimized for transforming large datasets, where the number of rows significantly exceeds the number of categories.

Within the library’s internals, a vector the size of the category set is generated as a mask to determine which category should be applied. This means that each time a transformation is performed, a large mask must be created, applied, and used to select the corresponding value. While this approach might seem inefficient at first, it is highly effective for large datasets. Instead of iterating through every row individually, a much smaller category-based mask is applied across the entire dataset, significantly improving efficiency in such scenarios.

However, this is not an ideal solution for a web endpoint, where each request processes a single row. In this scenario, the number of categories far exceeds the number of rows transformed per API request, resulting in unnecessary computational overhead.

To address this issue, I developed the following function to patch the TargetEncoder when used in the API. Notice that I created a category/value cache and used it to define the value of each cell, which would make this algorithm O(NxM). However, since the API processes only one row and one column per request in this TargetEncoder, there is no need to iterate through rows and columns, effectively reducing the algorithm's complexity to O(1).

<pre>
from sklearn.preprocessing import TargetEncoder
import numpy as np


def patch_target_encoder_improving_performance():
    TargetEncoder.transform_old = TargetEncoder.transform
    TargetEncoder.transform = new_target_encoder_transform


def new_target_encoder_transform(self, *args, **kwargs):
    if "_cache_cat" not in self.__dict__:
        self._cache_cat = {v: i for i, v in enumerate(self.categories_[0])}
    X = args[0]
    X_out = np.empty_like(X, dtype=np.float64)
    for row_i, row in enumerate(X):
        for col_i, category in enumerate(row):
            index = self._cache_cat.get(category)
            if index is None:
                X_out[row_i, col_i] = self.target_mean_
            else:
                X_out[row_i, col_i] = self.encodings_[0][index]
    return X_out
</pre>

After deploying this improvement, we were able to match the response time of the new model with the previous one as you can see in the graph below.

![/assets/images/mab.png](/assets/images/target-encoder-performance.png)

That said, a warning remains: this is not a fully secure solution. A future update to scikit-learn could modify its internal attributes, which this patch relies on, potentially altering its behavior or even causing silent errors. To mitigate this risk, we have implemented tests in the API to verify the expected behavior across various scenarios.




