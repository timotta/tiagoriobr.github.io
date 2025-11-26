---
layout: post.html
title: "An Approval Model That Finally Got Approved"
tags: [work, willbank, account]
path1: work
path2: willbank
path3: account
---

Until last year, Will Bank was mostly a digital bank with one obsession: credit cards. Every campaign, every banner, every catchy line revolved around them. But then came the big question: what if we also cared about people who don’t have credit? That’s when we started exploring how to grow our customer base among users without access to credit, focusing on digital account usage only. There was just one tiny problem: the experience for this group wasn’t great. We had to be careful not to approve users dreaming of credit and hand them... a digital account. Nobody likes that kind of plot twist.

When our team was created to tackle this, a few experiments were already floating around. One of them aimed to find, among credit-denied customers, those who still had potential to become great digital account users. A noble quest, but easier said than done.

The first challenge was defining what a "good customer" even meant. The data science team and business folks were in deep philosophical discussions over what "engagement" actually looked like. The metrics were solid, repeated transactions, specific frequencies, consistent usages, but not exactly actionable. One example definition was: "The customer performed a cash-out at least once per month for three months." That sounds reasonable, right? Except it came with two major problems:

* We needed three months of data before even training.
* Then another three months to check results.

To make things worse, we barely had any non-credit customers in the data. We planned to open the funnel randomly for two months to collect more samples. But with a three-month target, that meant at least five months before we could train a single model.
We wanted to do data science, not archaeology.

So our first big move was to redefine success. We needed something we could actually measure this century. After some digging, we found a beautiful correlation: customers who made any transaction in the first week were much more likely to stay engaged in the long term. Perfect. Fast feedback, clear signal, no time travel required.

With the new target set, and after a month of random sampling, I jumped into the team’s notebooks. They were running SageMaker, which came with ancient versions of pandas, scikit-learn, and XGBoost, and, tragically, no Optuna, my favorite hyperparameter-tuning companion. Given how tiny our dataset was, using SageMaker felt like renting a stadium to play table tennis. I moved everything locally, upgraded the stack, and life instantly got easier. We have accidentally created a Notebook template that we started using in many other following models for recommendation, churn detection and fraud prevention among others.

Before the data science discipline was internalized, communication had been another headache. The data science presentations were full of bins, score ranges, and KS values. Impressive stuff, unless you weren’t a data scientist. To business stakeholders, it looked like hieroglyphics. They thought the model was a failure when it really wasn’t; it was just badly translated from "data" to "business." So we changed the narrative. Instead of showing Kolmogorov-Smirnov, we started showing activation rates, complaint ratios, and the famous "what happens if we approve these people" chart. Suddenly, everyone was speaking the same language.

I added a threshold analysis to the jupyter template to find the optimal score cutoff for activation and built guardrail metrics to show the trade-offs. The model was simple, put together in just two days, but the results were great. I made a deck with easy visuals, and for the first time, the business team didn’t just nod politely; they were genuinely excited. The project had direction again. Sometimes, the real model improvement is just better storytelling.

![/assets/images/approval.png](/assets/images/approval.png)

The model still needed tuning, but since data science was already part of the team, [Gustavo Lee](https://www.linkedin.com/in/gustavo-alexis-sabill%C3%B3n-lee-3584b474/), who had been working on the model long before I joined, and [Jadson Marcelino](https://www.linkedin.com/in/jadson-marcelino-ele-he-86678329/), whom we had recently hired and brought many ideas for new features and target setups, continued improving it.

Meanwhile, I was trying to figure out how to actually get it live, since I was still the new kid at the company.

Lucky for us, in parallel we were redesigning the onboarding flow to ensure customers approved without credit wouldn’t get confused or disappointed. That also helped us understand which features were actually available to the model at runtime, which is always a fun game of “what can we really use without months of engineering work?” Because the team was multidisciplinary, we could quickly adjust which features to include in training as we discovered new constraints. As we like to say, “A nearly perfect model in production is better than a perfect one stuck in a Jupyter notebook.” (We all know a few of those.)

Deploying the model turned out to be refreshingly simple. Will Bank already had an internal platform to spin up new apps in the Kubernetes cluster. We just built a small FastAPI service with the model pickle, deployed it, and plugged into our observability and event tracking system. We could now watch the model’s scores and feature drift in real time, basically, data science with popcorn.

Then came the fun part: results. Once live, the model delivered a 27% increase in activation in an A/B test, and the improvement held steady for months after rollout. We also kept a random control group untouched by the model, so we always had a healthy benchmark and new data for retraining. The curve went up, the charts looked great, and for once, nobody asked, "but is it statistically significant?" (It was.)

That choice paid off in the long run. Over the following months, we went through five model iterations, refining targets, adding new features, and slowly reintroducing attributes we had initially left out for the development speed. [I have writen a post about one of those iteraction here](/work/willbank/account/patching-scikit-learn-improve-api-performance/). Each version got smarter, and the team got more and more knowledge about clients without credit.

Meanwhile, our team kept improving the non-credit customer experience to the point that we no longer needed to block users with low engagement potential. The model evolved too. It became less about who to approve and more about reducing friction in the onboarding flow, deciding whether to even ask customers if they still wanted to open an account after being denied credit. That small change had a big impact: more customers transacting, more staying active, and far fewer confused faces.

It was a great reminder that, in data science, the smartest thing you can do isn’t always building a new algorithm: It’s helping people make slightly better decisions at the right moment. After all, the Agile Manifesto wasn’t written for data scientists, but maybe it should’ve been: working insights over perfect models, collaboration over documentation, and delivering value over chasing accuracy.

Although I describe [myself](https://www.linkedin.com/in/timotta/) as the protagonist in this story, it has many other layers and perspectives, and none of it would have happened without the collective work of this amazing group of professionals: [Gustavo Lee](https://www.linkedin.com/in/gustavo-alexis-sabill%C3%B3n-lee-3584b474/), [Jadson Marcelino](https://www.linkedin.com/in/jadson-marcelino-ele-he-86678329/), [Osvaldo Berg](https://www.linkedin.com/in/osvaldo-berg-jr/), [Flávia Veloso](https://www.linkedin.com/in/flaviaveloso/), [Pamela Souza](https://www.linkedin.com/in/pamelaps/), [Rodrigo Nunes](https://www.linkedin.com/in/rodrigomendesnunes/), [Camila de Melo](https://www.linkedin.com/in/camilamsilva/), [Luri Shirosaki](https://www.linkedin.com/in/lurishirosaki/), [Helen Souza](https://www.linkedin.com/in/ahelensouza/), [Ana Lemos](https://www.linkedin.com/in/anacrislemos/) e [Rodrigo Orofino](https://www.linkedin.com/in/rodrigo-orofino/).

