---
layout: post.html
title: "A Day Trying to Vibe Code, and Failing #1"
tags: [work, general, articles]
path1: work
path2: general
path3: articles
---

Today I spent some time experimenting with Vibe Coding using Cursor. I have been intentionally setting aside time every Friday to do this, trying to understand how other developers are getting real productivity gains from this way of working.

The task itself was fairly straightforward. I needed to extract part of some code that clearly did not belong where it was. The logic lived inside an HTTP request handler and was doing more than it should. It executed a task that should have been asynchronous, and the HTTP response was unnecessarily waiting for it to finish. The goal was to extract that logic into an asynchronous process and have the request handler simply publish a message to SQS, allowing the work to be processed later.

<h2>First attempt: too much, too soon</h2>

In my first attempt, I sent the full task to Cursor. I described what I wanted as clearly as possible in English and asked it to execute using agent mode. It started scanning, thinking, and waiting. After about 30 minutes, while I went off to handle other bureaucratic work, nothing had finished. Eventually, I gave up and stopped it.

<h2>Breaking the problem down</h2>

At that point, I assumed the task might still be too large. Even though it was not particularly complex, I decided to break it down further. I started by asking Cursor to do just one thing. I wanted it to extract the asynchronous logic into a separate method or function, duplicating whatever was necessary so that the new function would be fully isolated and triggered by a message.

This time, Cursor really shined. There was one important difference. I asked it to create a plan first and only asked it to execute after reviewing that plan. The result was solid. The extraction was done correctly and cleanly.

<h2>Tests: the first cracks</h2>

That said, it did not follow the project’s testing conventions very well. The new functionality was created without tests, and some existing tests for the original function were broken. Those tests still depended on mocks related to the logic that had just been extracted.

I wrote another prompt asking Cursor to fix the tests, and once again it delivered. The tests were corrected, and everything passed.

<h2>Human error and wasted time</h2>

The next step was to add tests for the newly created function. This time, the mistake was mine. I accidentally provided the wrong class name in the prompt. Cursor spent quite a while planning, and only after reviewing the plan did I realize the error. It was effectively planning to recreate tests that already existed, which left the process in a strange, half-blocked state. That mistake alone cost me about 15 minutes. Combined with the earlier attempt, I was already around 45 minutes deep.

<h2>Multiple agents, more complexity</h2>

After correcting the class name, I tried again, and once again the agent took a long time. At that point, I decided to experiment further and split the work across multiple agents.

I opened one agent to plan how the new function would be wired up as a new queue consumer. I opened another to handle an additional refactor I had noticed. There was rollout-related logic in the function that had been at 100 percent for a long time, yet the code still supported a 0 percent path that was no longer relevant and should be removed.

So now I had three agents running in parallel. One was focused on tests, one on wiring the queue consumer, and one on the refactor.

The first to respond was the refactor. I got the familiar blue loop screen, reviewed the changes, accepted them, and everything looked correct. Meanwhile, the other two agents continued thinking. That was another 15 minutes gone.

<h2>When things start to fall apart</h2>

Eventually, the remaining agents appeared stuck, repeating the same messages. I stopped them and reran only the test-related agent. This time it completed quickly, but it also partially reverted the refactor. Only part of the change was undone, leaving the codebase in a broken state due to missing dependent changes. I had no choice but to revert everything.

I tried one last time, reissuing the prompt to generate the tests. Once again, it started thinking and kept thinking. At that point, my day was over. I had to leave and head to the gym.

<h2>Final thoughts</h2>

![/assets/images/podium-math.gif](/assets/images/fail-vibe.png)

In the end, this was yet another day where I tried to Vibe Code and failed to complete the task.

My lingering feeling is that, had I done this work using only the AI as an autocomplete tool and as a way to ask questions, I would have finished the task in a fairly straightforward way. That said, this feeling is common when learning a new technology or adopting a new way of working. There is almost always an initial drop in productivity. My hope is that this learning curve eventually pays off, leading to a real and meaningful boost in productivity over time.