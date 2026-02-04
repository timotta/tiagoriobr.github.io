---
layout: post.html
title: "Tree hug dream unlocked by AI"
tags: [work, olxbrasil, hackday]
path1: work
path2: olxbrasil
path3: hackday
---

In Brazil, the term "tree hug" is commonly used to describe those company off-sites filled with talks, workshops, and team dynamics that usually happen once a year. Despite not being formally hired by OLX yet, my attendance had already been informally agreed upon, so about two weeks before my official start date in February 2019, I joined an off-site, a.k.a. my very first corporate tree hug in OLX.

One of the activities involved splitting into groups to imagine what OLX would look like in the future and present it. After each presenttion, we were asked to imagine a post-future and present again. This cycle repeated several times, until we eventually reached a point where AI would automatically identify products you no longer needed, sell them to someone who did, pick them up from your home, deliver them to the buyer, and transfer the money to you, all without interrupting you at all. It would feel as natural as electricity or water service does today, quietly running in the background and charged via automatic debit.

What struck me was that, somewhere along those futuristic leaps, there was actually a solution that felt achievable in short term: the user would take a single photo of their living room, and OLX would automatically identify everything that could be sold and pre-generate listings. The user would simply choose which items they actually wanted to sell.

That idea stuck with me. But OLX had so many more basic and urgent problems to solve that prioritizing disruptive ideas like this was optimistic, at best. On top of that, I didn’t have much experience with object detection in images, which made it hard to justify tackling this during a hackday if I wanted even a small chance of delivering something. Of course, that’s a bit of an excuse. I could have studied on my own beforehand. But in Data Science there is always so much to study that I usually focused on whatever was closest to my current work. In short, excuses.

Ironically four years later, the opportunity appeared. ChatGPT and the OpenAI APIs were starting to gain popularity, and since OLX cared quite a bit about cost efficiency, I began exploring open-source LLMs that were emerging at the time. During these experiments, I started using Hugging Face and was introduced to YOLO. It looked surprisingly simple, almost plug-and-play. The remaining question was whether it would need fine-tuning for the very specific domain of Brazilian living rooms.

Then came the second opportunity, my last hackday at the company. I had already delivered the [hybrid search project](/work/olxbrasil/search/jouney-hybrid-search/) and was actively interviewing elsewhere, but why not try to finally realize that dream born during my first tree hug?

I collected a sample dataset of Brazilian living room photos from Google Images to test YOLO’s object detection capabilities. It’s worth noting that YOLO doesn’t identfy brands or models, at least not the Apache 2.0 licensed version I used at the time. So when it detected a television, for example, I could only generate a draft listing for "a TV," along with suggested minimum and maximum price ranges for that region.

Visually, the results were quite satisfying across the anecdotal examples I tested. Of course, with only one day of work, I didn’t have time to annotate data properly or evaluate recall and precision. Science was done, vibes-based. On top of that, since we already had minimum and maximum prices per product, we could estimate how much money the user might make by selling those items, something like "you could earn between X and Y reais."

![/assets/images/tree-hug-dream.png](/assets/images/tree-hug-dream.png)

Naturally, this was just a proof of concept. I didn’t implement the full integration into the OLX app during the hackday, and I didn’t have time to do so afterward since I was already on my way out. As an active OLX user to this day, I can see that this 2019 dream still hasn’t been prioritized, which probably makes sense. It’s not a very common use case, and realistically, users wouldn’t rely on a single photo alone. Each detected item would still need to be reviewed and polished individually, so the “one photo to sell everything" dream would still come with a fair amount of work for the user.

Still, I got the satisfaction of proving that one of the many dreams imagined during that first tree hug was, in fact, possible.