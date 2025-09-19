---
layout: post.html
title: "How I got the unfair reputation of disliking semantics"
tags: [work, globocom, farofus]
path1: work
path2: globocom
path3: farofus
---

When people today talk about semantic search, they usually mean vector embeddings, RAG pipelines, and all that fancy LLM jazz. But back in 2011, at Globo.com, we were into a very different kind of “semantics”: the Semantic Web.

And let me tell you, my first encounter with SPARQL felt like love at first sight.

<h2>Falling in Love with SPARQL</h2>

Before I even joined [TechTudo](https://www.techtudo.com.br/), I had already been introduced to [SPARQL](https://jena.apache.org/tutorials/sparql_pt.html) at Globo.com. At the time, many of Globo’s products were experimenting with organizing their entities in ontologies stored in [Virtuoso](https://vos.openlinksw.com/owiki/wiki/VOS).

For the uninitiated, SPARQL is like SQL’s eccentric cousin who reads philosophy books and talks about relationships. Data isn’t rows and columns. It’s triples: subject, predicate, object. And you can chain these triples into hierarchies that go up, down, sideways — it’s like the family tree of knowledge.

When I learned it, I thought: “Wow, this is beautiful. This is the future. I’m going to tell my grandchildren about this.”

But as in many relationships, the problems weren’t with SPARQL itself...

<h2>The Big Semantic Web Dream</h2>

The whole Virtuoso/SPARQL setup wasn’t there because TechTudo really needed it. No. It was part of Globo.com’s grand plan: connect all products — G1, GE, GShow, GloboVideos — into one giant semantic brain. Content would flow magically between them, like neurons firing in the collective consciousness of Globo.

In practice?

Well… politics happened. Business didn’t really want to share traffic. Everyone wanted to receive visitors, but no one wanted to give it away. So the “semantic web of everything” became more like a semantic web of… each spider.

Meanwhile, we — humble TechTudo folks — were left dealing with the side effects of this dream.

<h2>The Return of the Big Oracle</h2>

Here’s the irony: just before Virtuoso, Globo.com had invested a ton of effort breaking down its big, scary Oracle monolith into smaller databases. This gave teams autonomy, agility, and sanity.

Then came Virtuoso. Centralized. Schema changes requiring massive coordination. Overnight deployments. Zero autonomy.

I still have an email from that era coined with the phrase “the return of the big Oracle”. That was exactly what it felt like. Déjà vu, but with more RDF.

And since TechTudo was considered “the little sibling” compared to G1, GE, or GShow, guess whose schema requests always ended up at the bottom of the priority list? Yep. Ours.


<h2>Endless Debates About Printers and Android</h2>

Now, you might ask: “But did you really need to change the schema that often?”
Oh yes.

At TechTudo we worked side by side with editors, and they constantly saw opportunities to improve navigation and SEO by tweaking hierarchies.

Examples:

* Printers and Scanners were categories. But what about Multifunctions? Both printer and scanner, but also its own category. Existential crisis in hardware form.
* Android and iOS were operating systems. But many readers also thought Android was a type of phone. Technically wrong, but SEO doesn’t care about your feelings.

We had dozens of situations like this.

The problem? Every change required weeks of discussion because opportunities to actually implement changes were rare. It was like playing chess, but if you touched a piece, you had to wait two weeks for someone else to move it.


<h2>The MySQL Rebellion</h2>

At some point, I thought: “Enough philosophy. Let’s get practical.”

So we prototyped a “diet version” of semantics using MySQL:

 Hierarchies modeled with n-to-n tables.
 Entities and content synced asynchronously into other tables with all ancestors (basically, pre-computed tags).

Did we lose SPARQL’s expressive power? Absolutely. Did we care? Nope.
Because in practice, all we really needed was:

* Give me all content for this entity
* Give me the related entities of this entity

With MySQL, we could do this quickly, and without begging another team for permission.

And the best part: editors could experiment. Try a hierarchy change, see the results, undo if necessary. No more weeks of debates about printers’ identities. Just: test, learn, move on.

The vibe changed instantly. People got bolder, faster, happier. Autonomy is a hell of a drug.


<h2>The Evolution</h2>

Eventually, the Semantic Web team evolved their platform and moved towards ElasticSearch. With multi-value keyword fields, they could replicate some of what we hacked in MySQL, while also improving query performance.

Editing the schema was still a no-go — but for Globo’s major products, that wasn’t really a big issue. They didn’t need constant tweaks to their hierarchies the way TechTudo did. And hey, at least queries got faster. Baby steps.


<h2>Rumors of My “Hatred” for Semantics</h2>

![/assets/images/semantic.png](/assets/images/semantic.png)

Of course, the rumor mill started. “He doesn’t like semantics,” they said.

Totally unfair!

I loved SPARQL so much I even built a [Ruby prototype (ActiveRecord-style)](https://github.com/timotta/active-semantic) for it, and later a full proprietary Python library. I was a fanboy!

What I didn’t like was the centralized bottleneck. It wasn’t a tech problem, it was an autonomy problem.

SPARQL will always have a special place in my heart. But in TechTudo, the real win wasn’t about elegant queries. It was about giving editors — and the team — the courage to try, fail, and learn fast.

And yes… we did finally figure out what to do with printers.

