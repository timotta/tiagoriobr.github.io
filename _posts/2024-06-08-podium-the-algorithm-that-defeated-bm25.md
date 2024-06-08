---
layout: post.html
title: "Podium: The algorithm that defeated BM25"
tags: [work, olxbrasil, search]
path1: work
path2: olxbrasil
path3: search
---

This article explains Podium, a search relevance algorithm created by the OLX Brazil Search team to replace the globally renowned BM25. It resulted in increased clicks, contact intentions, and reduced complaints about search quality, and was launched in April 2021.

In previous years, our search team at OLX has tried various approaches to optimize search and bring more accurate results. With each change, there was an observed improvement in short-term AB testing, but in the medium term, advertisers adapted to increase impressions of their ads by exploiting algorithm loopholes, consequently worsening the accuracy of the results.

To make this clearer, I will describe below two examples of changes that were made and caused harmful reactions from advertisers:

Example 1: At some point, we began to give more importance to the brand and model attributes configured by the advertiser. Therefore, an advertisement for a cellphone marked with the brand "Samsung" and the model "Galaxy" would have a better chance of being found in a search for "Samsung Galaxy" than one that was not configured this way.

In AB test, this experiment brought gains, but after the rollout, advertisers noticed, and began advertising cell phones with different brands in the most searched brands. So, his ad started to appear in two different searches. In addition, advertisers of services and jobs started placing their ads in other categories that contained the brand and model attributes to appear in searches for the service title as well as in random searches.

Example 2: In another period, through a precision analysis using Bayesian optimization, we defined automatic weights for each attribute of the ad. It so happened that the title obviously had a higher score. Some months after the AB test, advertisers realized that if they repeated the most important words in the title, it would have a higher chance of being elevated to the top of the search results, because of the BM25.

In this way ads like "freight freight freight" and "invicta watch invicta watch invicta watch" were always at the top of their respective searches, disturbing the lives of buyers and advertisers less focused on SEO at OLX. As a temporary solution, we penalized ads with duplicate terms and standardized the internal title used in the search. However, there was still a loophole for cases of derived words, which internally in Elastic Search were considered the same word due to Stemming.

These were just two examples of several of our attempts to optimize the search of OLX Brazil using BM25.

However, they demonstrate that we would never achieve a good result with BM25, as the mathematical intuition behind this algorithm does not make sense for the C2C marketplace, due to two things:

1. In the numerator of BM25 there is the quantity of matches of the searched words.
2. In the denominator, one of the components is the size of the document.

That is, BM25 always favors smaller documents with the highest number of matches. In this case, if a search for "bicycle" is done on a C2C marketplace, the ads with the highest match will be those whose title is simply "bicycle". And if the ad description is included in the calculation, the highest matches will be those with the fewest words in that description and with the most repetitions of the word. In other words, the least informative, least creative, and poorest ads in terms of information will have the best score.

During this period when we were studying a way to improve search, we were in love to an [Wallmart paper](https://pages.cs.wisc.edu/~anhai/papers/chimera-vldb14.pdf) about product classification, and based on it we created a system called Guanabara (in honor to a famous supermarket in Rio de Janeiro). One of the ideas from the paper is a hybrid system of regexes, machine learning models, and human in the loop to identify products.

While we were creating the regexes for this system, we noticed that there was a pattern in the title of the ads that we could observe for portuguese language. Ignoring some irrelevant words at the beginning of each title, such as "vendo", "novo", "lindo" among others, the order of the words indicated the real relevance of an ad for a certain term, in portuguese.

Ads like "Vendo Samsung Galaxy", "Samsung Galaxy s10" and "Samsung galaxy novo", should have the same relevance to each other, but a higher relevance than "Fone de Samsung galaxy" in a search for "Samsung galaxy".

And so the idea arose: What if we gave a higher score to matches based on the position of the term in the ad and the position of the term in the searched text?

Based on this idea, we created the Podium algorithm:

![/assets/images/podium-math.gif](/assets/images/podium-math.gif)

<!-- \sum_{k<3}^{k=0}\sum_{i<3}^{i=0} match(P_i,Q_k) * S/2^^{i+k} -->

Where **P** is the list of the first three relevant words from the ad, and **Q** is the list of the first three relevant words from the search made, **S** is an initial higher score (currently at 200k) and **match** is a function that returns 1 or 0 if the terms are equal.

This is a base calculation. The other texts from the ad and the query are also used, but with lower scores and not as important for the intuition behind the algorithm. In addition, the terms in the ad and the query are deduplicated through stemming in advance.

One of the most important things about this algorithm is that it purposely causes ties in ads where the accuracy between the search terms and the terms present are the same. So in the example given, a search for "Samsung Galaxy", the ads "Vendo Samsung Galaxy", "Samsung Galaxy s10" and "Samsung Galaxy novo" all have the same score, allowing us to reorder them by relevance, which is another very important factor in a C2C marketplace.

Before that, with BM25, to achieve good recency in the results, we would apply a score decay function relative to how old the ad was. This decay often caused a loss of precision, especially in cases of products with low inventory. A classic example we used to demonstrate the problem was searching for "torno mecânico" in a certain region there were only 2 "torno mecânico" ads, but they were not recent. When searching for it with BM25 plus the decay function, these ads would appear in the last results.

With Podium forcing ties in similar matches, we achieved a good balance between recency but only in ads with good accuracy, without needing a decay function.

With that, our qualitative [R-DCG, a ranking metric we have explained in a previously post,](https://medium.com/grupoolxtech/uma-nova-m%C3%A9trica-para-calcular-relev%C3%A2ncia-de-busca-65372f154f8f) increased by **3.8%**. And this result was accompanied by a **3.6%** increase in contact intentions and a **2.9%** increase in clicks on the top 5 positions of textual searches.

And most importantly, after years, advertisers have not been able to find a relevant loophole in Podum to increase their impressions and disturb OLX's search accuracy. It is still possible to do so through tags in ad descriptions, which increases impressions in case of low inventory in specific locations, but since there was already no inventory, it is not a major concern.

It is worth noting that after Podium went live, several search improvements were implemented, including the inclusion of synonyms, spellers and much more.

More recently we lauched a new version of Podium, the Podium-N. In this update, we solved the issue of ads that should have the same relevance but didn't with the original Podium. Example: "Vendo samsung galaxy" and "Vendo galaxy da samsung" for the search "Galaxy". But that's for another post.

In addition, we are finalizing the integration of semantic search together with Podiun-N, in a hybrid search, which is already showing great results. But that will also be discussed in a future post.

Podium was a collaborative solution made by [me](https://www.linkedin.com/in/timotta/), [Leonardo Wajnsztok](https://www.linkedin.com/in/leonardowajnsztok/), [Filipe Casal](https://www.linkedin.com/in/filipecasal/) and [Daniel Araújo](https://www.linkedin.com/in/daniel-correa-araujo/). The engineering manager at the time was [Rogério Rodrigues](https://www.linkedin.com/in/rogeriofrodrigues/) followed by [Gustavo Maestri](https://www.linkedin.com/in/gumaestri/) and the product manager and who gave the name for the child was [Pedro Tangari](https://www.linkedin.com/in/pedrotangari/). Please accept my apologies if I inadvertently leave anyone out. It happened three years ago...