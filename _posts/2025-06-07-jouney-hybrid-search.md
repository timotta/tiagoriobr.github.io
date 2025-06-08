---
layout: post.html
title: "The Journey to Hybrid Search at OLX Brasil"
tags: [work, olxbrasil, search]
path1: work
path2: olxbrasil
path3: search
---

This is the story of how we improved the search experience at OLX Brasil in early 2024 by introducing semantic search.

We’ve always known that search is at the core of the user experience. When someone types something like “European football team shirt,” they’re not just entering keywords — they’re expressing intent. Our traditional lexical search engine, [Podium](/work/olxbrasil/search/podium-the-algorithm-that-defeated-bm25/), handled direct matches well, but often failed when the query was more conceptual or abstract.

That’s where it all started — with a hackday.

<h2>From Hackday to Proof of Value</h2>

During an internal experiment started by [Daniel Araújo](https://www.linkedin.com/in/daniel-correa-araujo/), he tested the use of the OpenAI embeddings API to improve our ability to understand and respond to semantic queries. The idea was simple: what if search could understand concepts, not just strings?

The first tests showed something powerful: it was able to return relevant results for many examples of queries like “European football team shirt” — even when listing titles didn’t contain those exact words. This revealed real potential in semantic search.

But there was skepticism.

<h2>A PM’s Bet (and a Little Faith)</h2>

Our initial hypothesis was conservative: this technology wouldn’t increase replies (the number of contacts on listings). At best, we thought it might improve coverage slightly — and at a high operational cost. Still, our Product Manager, [Claudia Bozza](https://www.linkedin.com/in/claudiabozza/) believed in it and pushed forward, even when we flagged potential cost-benefit concerns.

And she was right.

<h2>First Version: Fast Build, Fast Results</h2>

We built a quick solution in just two weeks: if a lexical search returned no results, we would trigger a fallback semantic search. Even with this simple approach, the results were impressive. That gave us the confidence to invest in building a robust hybrid search system.

<h2>A Strategic Shift: Moving Away from OpenAI</h2>

As the solution evolved, we decided to move away from OpenAI’s API. Response times were too high for real-time search. We also tested Google’s Gemini, and faced similar issues.

Instead, we adopted local embedding generation using [sentence-transformers](https://sbert.net/), giving us more control and performance. We started generating vectors in-house, allowing the solution to scale more efficiently.

<h2>So why hybrid, and not purely semantic?</h2>

For OLX’s search engine, diversity and recency are critical metrics. We had already proven in several past experiments that both correlate strongly with the number of replies and how quickly items are sold.

When it comes to diversity, we noticed a major drawback in using a purely semantic approach: if we generated vector embeddings using only the ad title, diversity dropped to near zero for simple one- or two-word queries. This happened because the cosine distance between the word "iPhone" and an ad titled simply "iPhone" is effectively zero. Since we have a large volume of listings with minimal or generic titles, this led to highly repetitive results.

On the other hand, the more ad fields we added to the embedding (e.g. description, location), the better the diversity became — but at the cost of precision.

As for recency, even when we applied time decay functions in the final score computation, purely semantic search often returned very old listings — especially in queries with lots of potential matches (which is most of them). That’s because in vector search, you have to define how many items each shard should return. Those selected items won’t necessarily include the newest listings. For example, if a user searches for “iPhone” and we have 20,000 iPhone listings per shard, but only retrieve the top 50 per shard, the most recent ads might be buried in the remaining 19,950 items — even if their cosine distance is only slightly worse.

We could increase the number of items per shard, but that comes at a steep cost in processing time and infrastructure usage.

After extensive experimentation, we concluded that a hybrid search strategy offered the best of both worlds. The offline results confirmed this: hybrid search provided the strongest balance between ranking precision and overall quality.

<h2>Engineering the Hybrid Search Algorithm</h2>

Once the concept was validated, we moved into an intensive algorithm analysis phase. We ran over 40 offline experiments, evaluating key relevance metrics such as freshness, diversity and [R-DCG (ranking-aware precision)](https://medium.com/grupoolxtech/uma-nova-m%C3%A9trica-para-calcular-relev%C3%A2ncia-de-busca-65372f154f8f). During this phase, we validated several crucial parameters:

* The number of items to retrieve from the vector search
* Which ad fields (title, description, location, etc.) to use for embedding generation
* Which embedding model to use (and how it performed on our dataset)
* How to combine lexical and semantic results effectively
* How to sort results after merging both types of rankings
* Which type of time decay function to apply to maintain result recency

This meticulous tuning allowed us to strike the right balance between semantic understanding and ranking precision. At the end, we could choose the best combination of parameters to get an algorithm that improved:

* Freshness: +65%
* Diversity: +9%
* [R-DCG](https://medium.com/grupoolxtech/uma-nova-m%C3%A9trica-para-calcular-relev%C3%A2ncia-de-busca-65372f154f8f): +0.72%


<h2>Experiments in Production</h2>

Bringing the solution to production experiments wasn’t straightforward.

We had a hypothesis: the increased response time of lexical searches — caused by sharing infrastructure with the hybrid search — could negatively impact the control group’s metrics in A/B tests.

To ensure a fair comparison, we set up a dedicated ElasticSearch infrastructure specifically for the hybrid search experiments. This separation ensured that the computational overhead of vector search wouldn’t degrade the performance of pure lexical queries.

As a result, all experiments were run in an almost fully isolated infrastructure setup.

<h2>The Impact: Results that Justify the Investment</h2>

Despite the increase in response time, the gains in textual searches were undeniable:

* +3.7% in repliers
* +4.3% in replies
* +4.3% in clicks
* And most notably: a 94% reduction in “no result” queries

Encouraged by these results, we decided to roll out the solution to 100% of users. But there was a problem — the cost.

<h2>Performance: The Millisecond Challenge</h2>

Initially, the hybrid search response time was a major concern: **P95 > 300ms**, compared to **~80ms** for pure lexical search. This made a full rollout unfeasible without quadrupling our infrastructure costs.

To tackle this, we launched a series of 24 performance experiments, each focused on shaving off latency. And for each experiment, we monitored key business metrics as guardrails to ensure we didn’t lose the gains we had previously achieved. Some of the key optimizations included:

* Vector quantization
* Increasing the number of shards
* Upgrading ElasticSearch
* Reducing HNSW candidates
* Merging lexical search fields
* Generating embeddings using GPUs
* And more...

There was no silver bullet, but together these improvements brought **P95 down to ~120ms** — even faster than other companies in our group that had also implemented hybrid search.

<h2>Conclusion: Progress, Perception</h2>

The biggest improvements came in conceptual and indirect searches, where vector models truly understood user intent. But new challenges emerged too. Queries that previously returned nothing started returning irrelevant results, which led to complaints and a perception of low precision.

This perception didn’t exist in the pure Podium model — if a result didn’t match, it returned nothing. In the hybrid version, we had to deal with the qualitative nuance of returning something that might not feel useful to the user.

That was the focus of our work during my final months there — work I didn’t get to finish: tuning problematic cases and exploring ways to visually communicate that certain results might be "off", while still being the best semantic match available.

What stood out during this journey was the company’s willingness to invest — not only in research, but also financially — to improve user experience. Even with performance improvements, hybrid search required more computing power: more ElasticSearch resources and ongoing vector processing.

<h2>The Economics Behind the Rollback</h2>

Recently, some friends who still work at OLX shared that hybrid search was eventually sunset, and OLX reverted back to [Podium’s](/work/olxbrasil/search/podium-the-algorithm-that-defeated-bm25/) pure lexical model due to infrastructure costs.

As an active user of the platform, I had already noticed a drop in views and contacts on my OLX listings. I even tested the search myself to understand what was happening — and the absence of semantic understanding was immediately noticeable. [Raphael Pinheiro](https://www.linkedin.com/in/raphael-pinheiro-b6530a107/), who is not only a developer but also sells products made with his 3D printer, also noticed a sharp decline in views on his listings. He even mentioned it to me — without knowing that the hybrid search had been rolled back.

Of course, these are anecdotal examples, and the overall impact was probably small enough to justify the decision — especially in core categories like real estate, vehicles, appliances, and furniture. But for smaller, more niche categories, the effect may have been significant. A 50% drop in views and replies in those segments might represent less than 1% of the total, but for that specific seller, it’s a huge impact.

It’s unfortunate, because the progress was substantial and there was still room for optimization. All major players in search are investing in hybrid approaches, because they’re not only proven to deliver better results, but also offers better scalability for product development by avoiding manual tuning of lemmatization, synonyms, and other linguistic rules.

Hybrid search may be gone from production, but the knowledge, progress, and collaboration built along the way remain one of the most impactful chapters of that journey.

<h2>The Minds Behind the Magic</h2>

Just like [Podium](/work/olxbrasil/search/podium-the-algorithm-that-defeated-bm25/), the hybrid search was build collaborativelly by [me](https://www.linkedin.com/in/timotta/), [Daniel Araújo](https://www.linkedin.com/in/daniel-correa-araujo/) and [Raphael Pinheiro](https://www.linkedin.com/in/raphael-pinheiro-b6530a107/). The engineering manager at the time was [Paulo Silva](https://www.linkedin.com/in/paulohesilva/) and the product manager [Claudia Bozza](https://www.linkedin.com/in/claudiabozza/). A special thanks to [José Hisse](https://www.linkedin.com/in/josehisse/) and [Denilson Limoeiro](https://www.linkedin.com/in/denilsonjunior/) who helped us putting the vector generation running under GPU. Please accept my apologies if I inadvertently leave anyone out.