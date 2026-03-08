---
layout: post.html
title: "A Week Trying to Vibe Code, and Getting Addicted #4"
tags: [work, general, articles]
path1: work
path2: general
path3: articles
---

A few weeks ago I wrote a post about [my first attempts at using AI](/work/general/articles/a-day-trying-to-vibe-code-failing-1/) to program in a vibe coding style. In that post I explained how my first experiment was mostly frustrating. I had the strong impression that I was actually slower using AI than programming the traditional way. Using models for anything beyond autocomplete or quick questions felt like asking a very confident intern who had read half the documentation.

My plan was to write a post 2, then a post 3, documenting the journey until I eventually started feeling more productive. Those two intermediate posts would have described my experience using Cline, a VS Code plugin.

At first it looked promising. The AI could structure things and generate code that appeared to work. But as the project evolved, the code quality dropped quickly. Eventually the code became so bad that it was almost impossible to keep building on top of it.

I had to intervene constantly. Fixing things, reorganizing parts of the system, trying to maintain some coherence. It felt less like programming and more like cleaning up after a very enthusiastic robot that had just discovered copy and paste. In the end, posts 2 and 3 would basically have been about another failure. Slightly better than the first one, but still a failure.

Then came the fourth attempt, which is the one that actually matters.

This time I changed the approach. Instead of using a plugin inside the editor, I experimented with a workflow closer to command line tools, inspired by projects like Claude Code. Since I did not want to start paying for these tools immediately, I tried KiloCode, which offers the Minimax model for free with a fairly generous limit. As engineers know, "free with limits" is usually enough motivation to try something.

That is when things finally started working.

I began building a project from scratch. In total it took less than a week, working roughly three hours per day. The most interesting part is that I barely touched the code. Which is both impressive and slightly unsettling if you have spent most of your career writing it.

Some architectural decisions were not great and there was a fair amount of duplicated code, but even then I could fix things through vibe coding itself. I would explain the issue and ask the AI to refactor it. It turns out explaining problems is much easier when the computer is the one who created them.

One important detail is that I was still thinking like an engineer during many of the iterations. Instead of only describing the product and letting the AI figure everything out, I often gave implementation instructions. For example: when the user clicks this button, send a POST request to this endpoint. The endpoint should check if the user is logged in and then perform a specific action.

Whenever my prompt was written purely from a product perspective, many important technical details related to reliability, security, and performance were ignored. That might be because my `AGENTS.md` file or agent configuration does not yet include enough technical rules.

For example, the service I am building includes a quota reservation system. There is a potential race condition when the last quotas are being reserved. When I wrote the prompt purely from a product perspective, I did not mention that problem, even though it was in the back of my mind. As a result, the AI never considered the scenario where simultaneous requests could reserve more quotas than actually available. A non-technical person could easily ship something like this to production because, well, it works on my machine.

Security provided another example. Some very basic protections were simply missing. CSRF tokens were not implemented, and requests could be executed inside iframes. These protections are standard in most web applications, but the model did not add them on its own. I had to notice the problem and ask for them explicitly. Apparently security is still a human responsibility, at least for now.

A third example appeared when I asked for new required attributes in the database. The agent created the migration, the tests passed, and everything looked fine. Except it was not. The real database already contained records without the new field. The `AGENTS.md` rules required running local tests, but the test database had no initial data. Everything passed while quietly preparing a future production incident. In other words, a very authentic software engineering experience.

These bumps in the road did not really diminish the overall positive experience.

Especially when it comes to user interfaces.

I did not have to manually work on the frontend at all. The classic meme of Peter Griffin adjusting the blinds to fix CSS never happened. The AI handled everything, even understanding screenshots when I pointed out UI changes I wanted. Which is impressive, since CSS has historically confused both humans and machines.

![/assets/images/vibe-4.jpg](/assets/images/vibe-4.jpg)

But maybe the most important question about this fourth attempt is simple.

Did I deliver this project faster than I would have using the traditional approach?

Surprisingly, the answer is no.

Not because I would have coded faster on my own. Quite the opposite. Vibe coding is so fast that it broke my usual habit of working iteratively and cutting scope. If I were programming without AI, I would have reduced the scope to deliver something within the same time. The project would still go to production, but with fewer features. With vibe coding I did not need to cut scope. Instead I added extra validations, additional features, and a few more screens.

So the total time was roughly the same, but the delivered scope was larger.

From an iterative development perspective that may not always be ideal. Some of those features might never be used. They may simply become additional maintenance work in the future. Future me might not appreciate current me quite as much as current me hopes.

Another question I still cannot answer is how this speed would work inside a team. This entire experiment happened in a personal project. There were no other developers, no pull requests, and no code reviews.

The speed at which the code was generated is not necessarily compatible with the speed at which humans review pull requests. Either I open many small PRs and lose part of the vibe coding advantage, or I open huge PRs that nobody really reviews properly because they are simply too large.

If we are moving toward a more "post industrial" model of software development where agents perform much of the implementation, engineering processes may need to evolve as well. Right now I honestly do not know what that will look like.

What I do know is that the fourth attempt finally worked.

And it made something very clear to me. When you develop software through vibe coding, you lose a bit of the classic pleasure of writing code and solving problems directly in the implementation. But you gain a different kind of satisfaction. The satisfaction of seeing ideas turn into working software almost at the speed of your thoughts.

And at least for me, that turned out to be surprisingly addictive.
