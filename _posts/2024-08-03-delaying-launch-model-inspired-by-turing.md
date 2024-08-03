---
layout: post.html
title: "Delaying the launch of a model inspired by Turing"
tags: [work, olxbrasil, trustandsafety]
path1: work
path2: olxbrasil
path3: trustandsafety
---

This is the story of how we built a machine learning model factory, and inspired by the movie "The Imitation Game," we decided not to launch it until another change was made. This second change had such a positive outcome that the factory achieved a much lower result than we had originally programmed, but without it, we would not have completed the journey. This case occurred between the first and second quarter of 2023.

The issue we needed to resolve was the high number of ads for prohibited items being posted on the OLX Brazil platform. Prohibited items are products whose sale is banned, controlled, requires special permission, or are the result of piracy. Examples of prohibited items would be weapons, gas cylinders, wild animals, counterfeit brand clothing, streaming accounts, among others.

At that time, there was already a structure in place to prevent the entry of such ads through a huge set of regexes that were constantly being incremented. These regexes moved the ads to a manual review queue, and a team of operators analyzed each ad identified by those regexes. The work of these operators was increasing day by day, and we needed to do something to reduce this manual verification.

The idea was to create a machine learning model to identify a certain percentage of ads with a high degree of certainty to automatically approve or reject it. This idea came from a hackday held by the squad to evaluate if for some group of regexes it would be possible to make a simple model that identified a good percentage with high certainty (>99% precision).

A group of regex would be a list of regex that already existed in the old process and that identify a type of prohibited item. We had years of history in the datalake of regexes that matched and whether the ad in question had been approved or rejected by the operators. As the model made on hackday worked, we decided to implement a POC with the evaluated group of regexes.

In the middle of the implementation, we realized the opportunity, if we left the model code generic enough and with good guardrails for threshold verification to obtain high precision in cross-validation, we could make a "factory" of models.

We then created a command line that receive as parameter a group of regexes, the command downloads and prepares the dataset separating it into training and testing, optimizes the model's hyperparameters using cross-validation on the training dataset trying to reach a threshold with high precision >99% for refusal and for acceptance. Then it is validated on the test dataset if this same threshold would achieve the same precision. If yes, the model is used, if not, the model is discarded for this group of regexes.

With this process, we quickly generated 26 models, with an estimate of reducing 5% of the operators' work due to the automatic decision. We put the model into production but without really making the decision, just to observe if the good precision result in offline evaluations would hold up in production, and it was also a success.

Our drama then began when we realized that if we really let the models make decisions, users would quickly learn what to do to escape, and the labor savings of operators would not be consummated. This is because the operator's decision tends to be slower, and less deterministic, than that of the model. This prevents the user from testing ways to circumvent. Quick feedback of refusal or approval could cause even more work for the operators.

In the meetings where we talked about this with that pressure to put it into production soon, we cited the movie "The Imitation Game," where Turing mentioned a similar strategy. The "enemy" could not perceive what was happening. A simple idea would be to cause a delay in the model's response. But another idea was hotter and more promising in our minds, something we had been ventilating for a long time: The temporary blocking of the user from posting ads according to the number of "fouls" he committed, with possible progression.

The complexity of this change came from the fact that we should create communications explaining what was happening, both for the moment of the event and for the moment of trying to post an ad (or login). Besides the analysis to define the ideal time between one attempt and another, how much ideal blocking time, as well as the natural work of the task, for state storage and expiration of the time window of attempts and interventions in the necessary places to prevent the temporarily blocked user from acting.

At this moment when we were determined to bet on this solution, inspired by Turing, I was already leaving the squad to a mission in the search squad. I participated only in the debates so that this would be the solution adopted before enabling the prohibited items model, and also the initial architecture discussions. The squad only had top developers, so they quickly put the solution into production and we had an incredible result.

The solution brought a **48%** reduction in the index of prohibited items, which greatly reduced the work of the operators for this specific problem, and consequently made the model of prohibited items, later turned on, have a lower result than we initially expected: Still making decisions in **~5%** of the cases, but from many fewer cases. Interestingly, the precision of the model, 1 year later, continues at **~99%**, probably due to the strategy that does not let the user adapt.

The people envolved in the development of both solutions were: [me](https://www.linkedin.com/in/timotta/), [Leticia Garcez](https://www.linkedin.com/in/let%C3%ADciagarcez/), [Robson Rocha](https://www.linkedin.com/in/robson-rocha-512a5b16/), [Lucas Carvalho](https://www.linkedin.com/in/carvalho-lucas/), [Victor Lyra](https://www.linkedin.com/in/victorseidl/), [Leonardo Campos](https://www.linkedin.com/in/leonardopereiracampos/), [Andre de Geus](https://www.linkedin.com/in/geusandre/),  Natalia Maria Karmierczak, [Daniel Freitas](https://www.linkedin.com/in/daniel-freitas-7487b5136/), [Debora Jansem](https://www.linkedin.com/in/debora-algamis-jansen-273187106/) e [Débora Cordeiro](https://www.linkedin.com/in/deborah-cordeiro-568298121/). An amazing group of people.


![/assets/images/turing.png](/assets/images/turing.png)
