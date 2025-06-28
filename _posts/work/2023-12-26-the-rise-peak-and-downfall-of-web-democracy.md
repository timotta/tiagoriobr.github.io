---
layout: post.html
title: The rise, peak and downfall of Web Democracy
tags: [work, personal, webdemocracy]
path1: work
path2: personal
path3: webdemocracy
---

This is the story about the rise, peak, and downfall of a politicians' rating app that I created and maintained for years as a pet project, along with an explanation of why it was shut down.

It all began in 2008, when Orkut was the most used social network in Brazil and it had started to release an Open Social API for application integration. I then had the idea of creating an app where you could rate and discuss Brazilian politicians.

The app was simple, a list of elected politicians and candidates with information gathered through web crawlers on the internet itself, a positive and negative evaluation, and a comments section. This would generate lists of the best, worst, and most controversial politicians.

And with the open social API, it would still be possible to find friends who are most politically similar to you. I actually didn't end up implementing this part because, as mentioned, it was a pet project and I didn't dedicate a considerable amount of time to it.

At a certain point, Orkut began to decline in Brazil with the growth of Facebook. In this other social network, there was already the possibility of creating applications, and I spent some time adapting Web Democracy to work on both, with Open Social and Facebook. However, the Facebook application API was very unstable, it changed a lot, and it did not bring as much return as the application on Orkut.

So after changing the application about three times to adapt it to Facebook, I decided to extract Web Democracy from the social networks and turn it into a website. It was a good decision. The number of accesses started to grow again due to the good implemented SEO, and it remained like that for a long time until it was shut down.

During this period, interesting things happened.

In a radio station in the countryside of Minas Gerais, a politician was questioned about a low rating on Web Democracy, and his response was an accusation that the application had been bought by his opponents.

Another politician threatened to sue me through a Facebook message if I didn't take down his profile because it would be defamation. The interesting thing is that this politician was highly rated on the app. I explained this to him and removed him from the platform. Then he asked to come back and I refused.

There was a period when leaders of a Brazilian liberal movement reached out to me to have the website ally with them. I refused because the concept of Web Democracy was to be a neutral platform without ideologies.

During the time I was on the air, I was starting a recommendation systems course, so I implemented a Content-Based recommendation for the website that had a good result in increased engagement, and I even released the data to the recommendation systems community: http://programandosemcafeina.blogspot.com/2015/11/dados-abertos-do-web-democracia.html

At some point, I tried to create new features for the application, such as the ability to create petitions, promote them, and evaluate them. However, this tool did not gain much success.

And then you ask me: With so much fun, why did the Web Democracy fall?

Web Democracy was developed using Ruby on Rails. Since I didn't work regularly on this project, every time I came back to develop something it was a challenge. This was because it was always necessary to update some Ruby library, whose ecosystem at the time ignored the concept of compatibility between versions.

I had even implemented a very comprehensive test suite with 100% coverage, however, whenever there was an update of rspec, cucumber, rails, or any other dependency of these libraries, even the test code would fail. This caused me an incredible laziness to work on the project.

Another technical difficulty was the frequent updating of politicians that needed to be done. With every new pre and post election, a new crawler had to be made because the source websites would change. It always required effort to bypass captchas, session cookies, and created bursts for protection.

Not to mention that, as I wouldn't want to lose the old assessments and comments or duplicate politicians, I needed to create a match between them. Notice that the sources of information didn't always have the CPF (Brazilian taxpayer ID), so the match wasn't that simple: Names changed, nicknames changed, parties changed, and even states changed.

I even developed a heuristic that gave me 100% precision in the match, but with low recall. To deal with uncertain cases, I created an annotation interface for the possible politicians that would be a match and manually did it myself. It was quite a tedious task.

In a certain year, which I can't quite remember, laziness got the best of me and I stopped doing these updates, and as a result, the Web Democracy platform became outdated. Additionally, Google's algorithm changed during this period, further deprioritizing repeated content, thus limiting the app's access even more.

With very few monthly visits, outdated and only burdening me in hosting, I decided to kill the project for good in 2022. Occasionally, I still visit the comments and suggestions page of Web Democracy with a bittersweet nostalgia for a project that brought so much joy and sadness: http://programandosemcafeina.blogspot.com/2008/08/web-democracia-criticas-e-sugestoes.html.



