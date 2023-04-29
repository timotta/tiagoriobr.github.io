---
layout: post.html
title: The fantastic widget factory
tags: [work, globocom, webmedia]
path1: work
path2: globocom
path3: webmedia
---

This is the story of how we performed a series of workarounds to overcome the rigidity of an extremely controlled production environment, and successfully deliver a product and platform solution.

The case occurred in mid-2006 at Globo.com. At that time, the portal was divided into several independent sites, such as G1, GloboEsporte, Ego, among others. Generally, these sites displayed only text news, and all video assets were concentrated on another site called GMC, Globo Media Center.

Our initial goal was to break down the silo in relation to video content, allowing developers from other sites to offer GMC registered videos in a simple and standardized way. At the time, an API was already available (known as WebmediaAPI), but it did not standardize the display of these content offerings, which would require additional effort from these teams for implementation.

The solution we proposed would be to develop standardized visual widgets. These widgets would bring offers of various types such as recent videos, most viewed videos, best-rated videos, with the possibility of applying various filters and layout options. In this way, it would only be necessary to import a javascript into the page to offer video content in any Globo.com website.

Here comes our first issue: At that time, Globo.com websites used a platform called Vignette, which made all its content static during the publication of homepages and articles. In other words, the news articles were static HTML generated after each publication, and the homepages were the same. Any changes to the page needed an editor to publish them for them to be displayed.

This went against the dynamic nature of video content. How to maintain dynamically ordered content such as "most viewed" on a static HTML page? One way would be to use server-side includes, since the static files were served by Apache.

Unfortunately, there were many restrictions to make any changes to the infrastructure at globo.com in 2006. To achieve this, we would need a lot of persuasion, meetings, presentations and one-on-one conversations, with no guarantee of success. We did not have the necessary time or social skills required for this goal. But we had a lot of creativity!

So we decided to make these widgets on the client side. However, cross-domain requests to obtain information from WebmediaApi would only be possible if we could provide the necessary CORS headers. But to do this, changes to the infrastructure would also be necessary, as the application server (Apache) in front of WebmediaApi was also rigid, beyond our control, and exchanged all headers.

Our solution was to allow WebmediaApi to return javascript call to a callback function instead of the json content. We then had a JavaScript with the widget code, which included another "JavaScript" that was the WebmediaAPI call with the name of a dynamic function as a parameter. This function was "printed" in the API response as a function call to finally render the chosen and customized widget.

There was even a timeout control in case the callback took too long to respond.

This solved our problem and after a few sprints, we created a true widget factory. Needs and ideas would come, and we would generate the necessary widgets and filters on WebmediaApi. It was a success. So much so, that the standardized layout of the widgets created the need to update the GMC, the aggregator site for all videos, to use the same layouts standards. Thus, Globo Vídeos was born, the successor to GMC.

But there was a catch...

At that time, Google did not index pages rendered via JavaScript. And we needed at least Globo Videos to remain server-side rendered so that we wouldn't lose relevance in organic searches.

The solution: we started rendering javascript widgets on the server. Since everything in Vignette was java, we had to render using Rhino (if I'm not mistaken, before java 1.5 it was only possible to render javascript in the JVM through this lib).

To maintain the freshness of the data, the Globo Vídeos homepage began to be rendered on the server every X period of time. I don't remember if this automatic publication was done via cron or some Vignette tool, but the point is that static HTML began to be generated frequently, with the HTML of the widgets. However, the video pages continued to display client-side widgets as it would be impractical to render millions of HTML frequently.

An additional difficulty with this solution was that everything on Globo.com at the time was running on a WebLogic server. The solution we implemented to render server-side JavaScript worked in all environments: local, staging, QA... Only when it was deployed to production did it not work. After much debugging, we discovered that the WebLogic version in production was different from the other environments, and it already had an older version of Rhino expanded inside its jar file that overrode our newer Rhino version. To render the widgets, it was necessary to execute the code by instantiating another classloader.

In the end, we successfully developed a client-side widget platform that enabled all websites to independently and consistently offer videos without duplicating code. Additionally, we created a server-side rendered video product that could be indexed by Google.
