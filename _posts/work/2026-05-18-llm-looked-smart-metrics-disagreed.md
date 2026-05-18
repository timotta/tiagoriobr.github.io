---
layout: post.html
title: "The LLM Looked Smart. The Metrics Disagreed"
tags: [work, willbank, account]
path1: work
path2: willbank
path3: account
---

This case from early 2025 is an interesting reminder that, even in this brave new world where models are increasingly commoditized through transformers and LLMs, the old concepts of data science still stubbornly refuse to die.

Back then, Will Bank had one clear mission: credit. That was about to change.

I was hired to help expand the product by offering free digital bank accounts, even to people who wouldn’t qualify for credit. I already touched on part of this story in ["An Approval Model That Finally Got Approved"](/work/willbank/account/approval-model-finally-approved/), but this chapter came with an entirely different headache.

Among many operational issues, there was one problem loud enough to echo through every metrics dashboard: public brand backlash.

People who were approved for a digital account without credit complained, loudly, across every imaginable channel. Social media, review platforms, app stores. The result? Lower brand affinity and, naturally, a bruised App Store rating. Because if there’s one thing users love, it’s receiving almost what they wanted.

This backlash represented a major risk.

On one side, we were carefully expanding account approvals using machine learning models and improving the app experience to make account conditions clearer. On the other side, we desperately needed to monitor whether this public frustration was quietly snowballing into another brand disaster.

<h2>The "Simple" Solution</h2>

At first glance, the solution seemed trivial: Why not use an LLM to read reviews and complaints from multiple channels and classify whether each one was specifically about being approved for a digital account without credit?

In fact, the company had just hired an AI vendor to classify reviews using nothing more than prompt engineering. And, honestly, the results looked promising. Through the tool’s interface, the segment of complaints we cared about looked coherent. Very few absurd classifications. Anecdotally, the mistakes even felt reasonable.

Which, as every data scientist learns sooner or later, is exactly when you should become suspicious.

<h2>The Question Nobody Was Asking</h2>

The visualization clearly suggested that the LLM + prompt setup had decent precision. But what about recall? In other words: were we actually capturing most real cases, or were we simply getting a polished-looking subset while missing the majority of the problem?

Time for some good old-fashioned manual labor. I downloaded a random sample of 750 reviews and manually labeled them in a spreadsheet.

Yes, manually.

No magic. No AI. Just me, a spreadsheet, and the growing realization that perhaps the robots weren’t replacing us that quickly. Then I ran the company’s shiny AI classifier and calculated precision and recall. The results?

* Precision: 85%
* Recall: a painful 42%

In plain English: when it flagged a complaint, it was usually right. The problem was that it simply missed most of them.

<h2>A Subtle but Important Confusion</h2>

While annotating the data, I noticed something interesting, there was another very common complaint that looked almost identical: Customers who wanted a digital account but got rejected because they weren’t eligible for credit were often being confused with customers who received a digital account but no credit.

The wording was remarkably similar. At that point, I made a deliberate modeling decision: treat both complaints as the same category.

Why?

Because what we were doing could increase complaints about not receiving credit. But if, at the same time, it reduced complaints from people being denied accounts altogether, we could reasonably argue that this wasn’t net brand deterioration.

Conveniently, the model’s inability to perfectly distinguish between both complaint types suddenly became less of a bug and more of a feature. The precision and recall numbers mentioned above already reflect this revised manual labeling strategy.

<h2>Prompt Engineering Hits a Wall</h2>

I tried tuning the original prompt. Some improvements here, some regressions there, the familiar short blanket problem we had already discussed in the article about [Podium: cover one side, expose the other](/work/olxbrasil/search/podium-the-algorithm-that-defeated-bm25/).

The tuning became increasingly specific. And the more specific it got, the more uncomfortable I became. At some point, I realized I was effectively handcrafting the logic the machine was supposed to learn by itself. It started feeling suspiciously like overfitting, except I was the one being overfit to the dataset.

It was time to stop pretending prompts were enough and build an actual model.

<h2>Building a Real Classifier</h2>

I downloaded 3,000 additional random samples and labeled them manually.

Again.

Because apparently my relationship with spreadsheets had become serious.

I tested a few relatively simple classification approaches. The best-performing one used XGBoost with text embeddings generated through a BERT model from Sentence Transformers. The results improved:

* Precision: 81%
* Recall: 65%

Better. Still not good enough.

<h2>Fine-Tuning an LLM (Properly This Time)</h2>

Then I thought:

What if I fine-tuned GPT to behave like a classifier instead of trying to bully it into becoming one through prompts?

OpenAI allows fine-tuning through its interface. Token costs are higher for fine-tuned models, which initially looked concerning, but the experiment felt worth running. I created a very simple dataset:

Input: review text
Output: one of only two words: "yes" or "no"

We fine-tuned the model using those 3,000 labeled samples. The results on the test set were excellent:

* Precision: 91%
* Recall: 86%

Finally, something good enough for monitoring purposes.


![/assets/images/llmrecall.png](/assets/images/llmrecall.png)


<h2>The Cost (Surprisingly) Wasn't the Problem</h2>

Ironically, cost turned out to be the least interesting part of the story. Yes, token pricing for a fine-tuned GPT model was higher. But because the model had effectively learned to respond with a single token, inference became absurdly cheap.

The fine-tuning itself cost around $9 (mostly because we ran several experiments), and the monthly cost of evaluating new reviews stayed below $1. For a problem tied to brand reputation, that was practically pocket change.


<h2>The Most Boring Ending Possible</h2>

We automated the classification of incoming reviews.

The data became a dashboard.

We checked it daily.

Then weekly.

Then monthly.

And eventually, we forgot it existed.

Which, in observability, is often the happiest ending you can hope for.

Because by then, we had gained enough confidence that with all the changes we were doing in the app, opening digital accounts without credit was not creating the same brand backlash that had happened in the past.

And sometimes, success looks suspiciously like becoming boring.
