---
layout: post.html
title: "Unexpected Side Effects of Let’s Add More jobs"
tags: [work, willbank, account]
path1: work
path2: willbank
path3: account
---


In another iteration to improve our [no-credit account approval model](../approval-model-finally-approved/), we built a new version with a new target. During local testing, it showed a response time significantly higher than the previous model, almost double. Honestly, this wasn’t surprising: the feature count had grown, the model was more complex, and we all know complexity never comes for free.

But once we deployed it to the development environment, the service API simply refused to start. Looking at our memory metrics, it was obvious that consumption was through the roof. Even after doubling the memory requested in Kubernetes, the service still wouldn’t come up, apparently having developed an expensive taste and asking for even more memory.

Digging into the issue locally, I noticed that when the service started and loaded the model pickle, **14 forked processes** magically appeared, as if I had accidentally summoned them.

<pre>
ps aux | grep myproject
.../python3.11 -m joblib.externals.loky.backend.popen_loky_posix --process-name LokyProcess-1:2 --pipe 29
...
</pre>

The number **14** instantly rang a bell: it was the exact value I had used for `n_jobs` when training the model.

![/assets/images/14jobs.png](/assets/images/14jobs.png)

I had never had issues using `n_jobs` when training XGBoost. XGBoost normally keeps that parallelism contained to the fit step. But in this new model, I had also set `n_jobs` on the `ColumnTransformer` inside the Pipeline. Looking back, a bold decision. Not necessarily a wise one.

To give you an idea, the pipeline looked something like this:

<pre>
preprocessor = ColumnTransformer([
    ('num', num_pipeline, NUM_FEATURES),
    ('cat', cat_pipeline, CAT_FEATURES),
], n_jobs=14)

pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('xgboost', XGBClassifier(..., n_jobs=14))
])
</pre>

And that’s where the mischief was hiding. `n_jobs`, wonderfully useful to speed up training, turned into a tiny chaos agent when loading the model for `predict`, spawning more processes than my dev environment cared to handle.

To fix the problem, I wrote a small script to "edit" the pickle (yes, it always feels slightly illegal) and took the opportunity to migrate to `cloudpickle`:

<pre>
with open(f"{base_path}/problematic.pkl", "rb") as f1:
    model = pickle.load(f1)

dict(model.steps)["preprocessor"].n_jobs = None

with open(f"{base_path}/fixed.pkl", "wb") as f2:
    f2.write(cloudpickle.dumps(model))
</pre>

That was enough to bring the response time back to the level of the previous model, even with the added complexity. And the deployment to the dev environment finally behaved like a civilized service.

Of course, editing a pickle always carries the risk of altering the model's behavior, but in this case it was safe. Running the model on a sample of 10,000 examples returned the exact same scores.

I can’t help but think how difficult it would have been to diagnose the memory issues if I hadn’t recalled that *I had explicitly set* `n_jobs=14`. It really felt like past me had constructed the perfect trap for future me, and future me walked right into it.

