---
layout: post.html
title: "Capybara, pareto principle and bureaucracy"
tags: [work, personal, capybara]
path1: work
path2: personal
path3: capybara
---

In December 2017, I proudly released [Capybara and the Goo](https://play.google.com/store/apps/details?id=com.timotta.games.monsterarrow) game into the wild.

It had taken me two years to develop, though—confession time—about 80% of the actual work was crammed into just three months. The rest of the time? Endless tweaking of layouts, designs, and silky-smooth transitions. Basically, a Pareto principle masterclass: 20% inspiration, 80% fiddling.

The original idea was to make something like the classic game Lemmings. But as so often happens in game dev, the project evolved… and mutated… until I had something completely different. The capybara protagonist was born out of pure local inspiration: my hometown is crawling with capybaras. They’re fluffy, they’re cute, and honestly, who wouldn’t want one as their game’s mascot?

At launch, the game had a mini boom—over a thousand installs! Not bad for a gooey rodent experiment. The only catch was that I hadn’t built in any sticky “keep playing forever” mechanics like collectibles or social hooks. The only long-term engagement feature was a ranking system using Google Play Games. My plan was to add new content slowly over time… but then life (and shinier projects) got in the way. The game slipped into the shadows.

Years passed. Google Play eventually yanked it from the store, disabled my developer account, and buried me under ignored emails about SDK updates and new forms. Bureaucracy: 1, Tiago: 0.

Then, out of nowhere, my Panamanian niece asked her dad (my brother-in-law) if she could play “the Capybara game.” Panic! I had no way to give her access—the game was gone, and I wasn’t even sure I could build it again after all this time.

Spoiler: I couldn’t. The game was built in [Love2D](https://love2d.org/)—a [Lua](https://www.lua.org/)-based game engine with an Android wrapper—and everything was tied to an ancient version of that setup. Updating it was anything but simple. Since the engine isn’t exactly mainstream, it felt like every bug was a one-of-a-kind nightmare just for me. What I thought would take two days stretched into two painful weeks.

Past Tiago had at least left some gifts: a bunch of handy visual debug tools I’d learned to build back in my Globo Videos (now [Globo Play](https://globoplay.globo.com/)) days, back when we were migrating from the good old Windows Media Player to the brave new world of Macromedia Flash.

![/assets/images/capybara.png](/assets/images/capybara.png)

But Past Tiago had also left traps: cryptic magic numbers with names so indecipherable that even Future Tiago couldn’t guess what they meant. Thanks, buddy.

Still, the hardest boss fight wasn’t the code—it was Google Play. Endless forms, mysterious “review” failures, especially for my bank statement. No explanation, just “Nope. Try again.” After nearly a week of trial and error, I finally broke through.

And so, [Capybara and the Goo](https://play.google.com/store/apps/details?id=com.timotta.games.monsterarrow) is back! My family can play, my niece is happy, and maybe—just maybe—I’ll add new levels, collectibles, or social features this time. That is, if Google Play doesn’t drain all my life energy first. They’ve already set a deadline: update again by November 1st, or else. Bureaucracy never sleeps.
