---
layout: post.html
title: Collecting data to identify data collect
tags: [work, olxbrasil, trustandsafety]
path1: work
path2: olxbrasil
path3: trustandsafety
---

This is the story of how we managed to prevent "data collect" fraud through a data collection!

It happened in mid-2022. At the time, I had already been working for a year and a half in the Trust & Safety area at OLX Brasil, and we had achieved significant success in reducing fraud attempts. Especially in a type of fraud known as "False Payment". In fact, another type of fraud known as "Data Collect" has since become the highest number of reported cases.

The problem with this other type of fraud is that the behavior of the fraudsters was very similar to that of another type of malicious user: the spammer. A modeling to identify this type of fraudster, done a few months earlier, failed for this reason. We were unable to separate the spammer from a fraudster of this type of fraud in any way.

Then you may ask me, why not prevent both characters with the same model?

The approach we had towards spammers was quite different from the approach towards a fraudster. I cannot go into detail about how these approaches because confidentiality is part of security, and making it public can assist both groups in finding ways to circumvent. But trust me, it was very important to distinguish our actions in dealing with these two groups.

We were at an impasse, our last model was actually doing a good job at accurately distinguishing between legitimate users and these two groups, but we couldn't put it into production for making automatic decisions. We were missing the ability to identify which micro behaviors set one group apart from the other, and there was only one team in the company that could help us with that: the monitoring team.

This team was a multidisciplinary team of fraud identification experts in the company. They were responsible for manually reviewing samples from automated models and operational team decisions regarding reports that were not handled automatically.

We spoke with this team in an attempt to find any new criteria that could help us separate the cases. The conversation proved to be a not-so-effective tool, as the developers and monitors didn't seem to speak the same language. We couldn't objectively map out these determining factors through these unstructured conversation.

To address this, we created a spreadsheet with a large sample of cases that the not so good model had identified as fraud (and within those cases, there were many spams) and added two columns: one to indicate whether it was fraud or spam, and another for free text where the operator could explain the reasons behind their conclusion. This spreadsheet was sent to the monitoring team for completion.

The result could not be more satisfactory. In the first lines, the free text column started off more "poetic" and gradually, the repetitive pattern of the groups caused the monitors to write in a more concise and even repetitive manner, generating a clear pattern on new criteria that we could adopt for the machine learning model.

Our data collection had worked. Our data collection had been successful.

These pieces of information generated new feature calculations for a new machine learning model training. We sent new samples of the results from this new model for monitoring evaluation, which could assure us of high accuracy. For a few weeks, we kept the artifact in production without taking any action, only logging, just to monitor if the generated result would reflect the results obtained in the offline evaluation. Everything went smoothly.

In the weeks after enabling the new model to take actions against the fraudsters, we experienced an average decrease of 33% in "Data collect" frauds per week. Another type of fraud, known as "False Sale", also saw a 25% decrease, as it relies on a more complicated social engineering involving the execution of "Data collect" fraud at first place to be effective.

So we data collected to avoid data collect successfully.