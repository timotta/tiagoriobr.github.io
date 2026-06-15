---
layout: post.html
title: "100 Million Users and One Missing Segment"
tags: [work, globocom, profile]
path1: work
path2: globocom
path3: profile
---

Back in 2018, Globo.com had what many companies would consider a nice problem to have: we had about 100 million users. Unfortunately, advertisers weren't particularly interested in buying impressions for "100 million humans of unknown characteristics." They wanted targeting. And the most basic targeting segment of all, the gender, was exactly where we had a problem.

<h2>The Problem: 100 Million Users, 5 Million Labels</h2>

At the time, around 10 million users browsed Globo.com while logged in. Sounds great, right? Well, only about half of them had filled out their gender in their profile. To solve the problem, the Profile & Segmentation team trained a machine learning model using the browsing behavior of those 5 million labeled users and applied it to everyone else.

The model looked promising offline. Which, as every machine learning practitioner knows, is usually the beginning of the story, not the end. The model performed well in validation. Production disagreed.

Fortunately, this wasn't caused by overfitting, data leakage, or somebody accidentally training on the target variable while pretending not to. The issue was simpler: the training population and the inference population were fundamentally different.

The model was trained on users who logged in and voluntarily completed profile information. It was expected to predict anonymous users who did neither. Those populations don't exactly behave the same way.

An external auditor, who had access to ground-truth demographic data for a subset of users, confirmed what advertisers were already telling us: the model wasn't good enough.

That's when I joined the team.

<h2>First Attempt: More Features</h2>

Before joining Profile & Segmentation, I had been working on video growth initiatives. Naturally, the team's first hypothesis was:

* Let's throw video consumption data at the problem.

While exploring the existing model, I also noticed that hyperparameter optimization was being done through grid search. Grid search is great if you enjoy manually guessing where the optimum might be and then asking a computer to confirm your guesses.

We replaced it with Bayesian optimization and incorporated video consumption features. According to the external audit, precision increased by 10% and 9% for the male and female segments respectively.

Good improvement. Still below the benchmark.

<h2>The "Wait, We Have Their Names" Moment</h2>

In parallel with the ongoing work to improve the model, I started investigating a much simpler idea. Of the 10 million logged-in users, 5 million had gender information and 5 million did not. But almost all of them had names.

And we had access to Brazilian census data containing aggregated statistics about names and gender distributions. So we asked a very simple question: if a name is overwhelmingly associated with one gender, why not use that information?

By selecting only names whose gender distribution exceeded a very high confidence threshold, we were able to infer gender for almost all registered users with remarkable accuracy. Suddenly we had almost 5 million additional labeled examples.

The funny thing is that our expectation wasn't that the model needed more data. Five million training examples is already enough data to make most machine learning engineers smile and infrastructure engineers start checking cloud bills. The real hypothesis was different: users with incomplete profiles were probably more similar to anonymous users than users with fully completed profiles. And that hypothesis turned out to be correct.

After retraining the model using both the original labels and the census-inferred labels, we finally exceeded the external auditor's minimum market benchmark. Unfortunately, I no longer have the exact improvement percentage recorded anywhere.

<h2>Then We Realized We Were Training on People and Predicting Devices</h2>

With one problem solved, another became obvious. Logged-in users behave like people. Anonymous users behave like devices. A logged-in user might browse from a phone, a home desktop, and a work laptop. The system knows it's the same person. Anonymous traffic doesn't get that luxury. The same human becomes three different devices, three different users, and apparently three different personalities.

This difference wasn't just conceptual. When we measured similarity between the training and inference datasets, the device-level dataset was significantly closer to production reality. On average, it was 15% more similar according to the Kolmogorov-Smirnov metric and 23% more similar according to cosine similarity than the user-level dataset.

In other words, we had been training on people and predicting devices. Unsurprisingly, the devices refused to behave like people. So we switched training from a user-based approach to a device-based approach. The impact was immediate. Predictions changed for roughly 11% of anonymous users, and the external audit reported a 6% increase in accuracy.

Not bad for changing the definition of a row.

![/assets/images/advseg.jpg](/assets/images/advseg.jpg)

<h2>The Clever Idea That Failed Completely</h2>

Every project has one. This was ours. The hypothesis was simple: if making the training dataset more similar to the inference dataset helped in the case of users vs device, why not explicitly model the inference population and train against that structure?

We trained a clustering model on anonymous-user data and then applied that clustering model to the training dataset, effectively stratifying it according to the structure of the anonymous population.

On paper, it was beautiful.

The resulting training process looked sophisticated. The diagrams looked sophisticated. The presentations looked sophisticated. The results did not.

No measurable improvement whatsoever.

To this day, I don't know whether the failure was due to an implementation issue, a flawed modeling assumption, or simply because the universe decided we'd had enough success already.

Unfortunately, I never got the chance to investigate further since after this experiment I have joined in my new adventure to work in [OLX Brasil](/archives/olxbrasil/).

<h2>The Email I Still Keep</h2>

One of my favorite career souvenirs is an email forwarded by Paulo Azize from the commercial team.

It contained some feedback from the commercial team after the improvements we had made:

* Due to the results of this campaign, the client requested a new proposal and invested even more during the same month.

* The client said she didn't believe Globo would be able to deliver this level of performance, but the results are proving otherwise.

* We've noticed a significant improvement in the quality of Globo.com's traffic. We want to work even more closely together to generate additional insights.

To be fair, these comments weren't solely about gender segmentation. The team was simultaneously improving multiple audience segment. But gender was by far the most visible challenge. It was the segment advertisers cared about most, and the one that had spent the longest time below the auditor's benchmark.

<h2>Credits</h2>

This achievement was only possible because of the incredible team assembled by [Bruno Souza](https://www.linkedin.com/in/brunofms/) in the Profiling & Segmentation group. Alongside Bruno, [I](https://www.linkedin.com/in/timotta/) had the privilege of working with [Paulo Azize](https://www.linkedin.com/in/paulo-azize-ab478b30/), [Diogo Munaro](https://www.linkedin.com/in/dmvieira/), [Fernanda Rabelo](https://www.linkedin.com/in/fernanda-rabelo-445974114/), [Paola Benchimol](https://www.linkedin.com/in/paola-benchimol-01524135/), [Gabriel Faleiro](https://www.linkedin.com/in/gabrielcard/), [Arnour Sabino](https://www.linkedin.com/in/arnour/), and many others whose names I may unfortunately have forgotten over the years. This happened eight years ago, and my memory has never exactly been optimized for long-term retention. Some of the names above I only managed to recover thanks to old email backups.

What I haven't forgotten is how much fun it was working with a team that was willing to challenge assumptions, question models, and occasionally solve machine learning problems with census spreadsheets.
