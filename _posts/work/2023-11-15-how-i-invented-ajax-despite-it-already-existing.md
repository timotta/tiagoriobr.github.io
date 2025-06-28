---
layout: post.html
title: How I invented Ajax despite it already existing
tags: [work, indata, angaturama]
path1: work
path2: indata
path3: angaturama
---

This is the story of how I invented Ajax (Asynchronous JavaScript + XML) despite it already existing, and how a junior developer would greatly benefit from mentorship at the beginning of their career.

Between 2003 and 2004, I worked for a very small software company. There were only three developers, and each one worked separately on a group of softwares, as if they were three one-person teams. I had little experience and had recently graduated, and I also did not have the habit of reading books and articles to learn. All my learning until then was based on empirical experimentation, solving real problems from personal projects and the companies I was working for.

At that time, the majority of websites and web applications would reload the entire pages every time a click or form submission occurred. And for me, that was indeed the only way to exchange information between the browser and the server. My knowledge was limited to that.

However, one of the projects at Indata involved customizing a GIS project from Mexico. In this project, I noticed that information was loaded on the page without having to reload the entire page. I found that amazing, a revolution within my limited knowledge. I needed to learn that!

Notice, at that time we didn't have Chrome's Web Developer Tools. We used Internet Explorer to debug websites. JavaScript errors were masked, there was no way to inspect anything. Additionally, the JavaScript code on the client side of this software was minified.

Reading line by line of that obfuscated code I found the so-called XMLHttpRequest object where the magic was happening. But I didn't understand anything. To me, that was the end of the execution line. There was nothing more after it.

I couldn't notice the callback that would be executed through it. It wasn't due to a total unawareness of the pattern, as at that time I had already developed some games in Java that used listeners in response to user actions, a similar pattern, but due to my lack of practice, I couldn't associate it.

Nowadays, I try to understand why I couldn't associate one thing with another, and my only hypothesis is that the abstraction of a callback for user action made sense to me at the time, as it is an external interruption to the code's execution flow, while the callback within the execution flow didn't make sense in my limited brain at that time.

Also, Google was not very popular in Brazil yet, and all search tools (in Portuguese because at the time I didn't have experience in other languages either) were directories and did not search internally within websites and texts. Neither did my colleagues at the company know that technology. So, for some time, I was stuck without understanding how that GIS software could load data from the server without reloading the page.

So one day I remembered an HTML tag that I rarely used, but had learned in an online HTML and JavaScript course: the iframe. I noticed that with the iframe, I could communicate with the parent using JavaScript and exchange information. This was the solution I needed.

With iframe, I would be able to retrieve information from the server and populate it in the parent through a function call, sending the data as a parameter. In fact, it was the same callback pattern used by XMLHttpRequest, but in this case, it made sense to me, as it was an interruption coming from another page being loaded.

At the time, I was developing Angaturama, a receptive tourism company management system. I started using the "Ajax" technique through iframes, and as a result, the system became very user-friendly. We even created a shortcut key to display hidden iframes that were hidden by CSS containing the results for debugging purposes.

A few years after I left the company, Google started to become more popular in Brazil. I learned English, developed the habit of reading books, technical articles, and participating in software discussion groups. During this period, I began to notice that there was a trending term called "Ajax". Everywhere I looked, people were talking about it, and the infamous XMLHttpRequest. In 2006, jQuery was born and made everything even easier.

When I discovered all of this, I felt like the boy from the movie ["Mongolian ping pong"](https://www.imdb.com/title/tt0461804/) who is sent to school and finds a court with several other boys playing ping pong, with that ball he spent months trying to figure out what it was.

In a later meeting of Indata employees, I remember us laughing about this makeshift job done on the Angaturama and how, due to our lack of knowledge at the time, I became famous among them for inventing "Ajax" despite its existence already.