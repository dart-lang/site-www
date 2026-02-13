---
title: "Life as a Dart intern"
description: "In this companion post to “Dart declaration-site variance”, hear about an intern‘s experience with Google’s Dart team."
publishDate: 2019-12-19
author: "kallentu"
image: images/06Ct-NyRGmYp_bmgp.png
category: other
tags:
  - programming
  - intern
  - dart
---


*I don’t know.*

Those three words run through the minds of software engineers every day. Engineering work consists of puzzles and problems, so not knowing something is just another indicator that an engineer has the capacity to grow. Yet, the lack of knowledge can also generate self-doubt.

Before I started my internship this fall, I didn’t know much about programming languages, type systems, or even variance (which was my entire project). As far as I knew, variance was just a value I needed to calculate the square root of, so I could obtain a standard deviation. Programming languages and compilers seemed like some black magic sorcery that mystified most developers.

Thankfully my manager, being the mind reader that he was, understood how I felt and remedied my nervousness.

*“So, I’m going to be completely honest, this project will throw you completely into the deep end. You don’t know anything yet, but that’s okay because I want you to ask questions, lots of them,”* he explained.

It was scary going head-first into a new project where I had little-to-no background knowledge of the work, but I knew I had support from my manager. He gave me the freedom to *try*, the freedom to *make mistakes*. It meant a lot to me.

That quick chat with my manager jump-started the first month of my time here: I met my team in Fremont Seattle and was ready to throw myself into this deep unknown called *variance,* which you can read about in the article [Dart declaration-site variance](https://medium.com/dartlang/dart-declaration-site-variance-5c0e9c5f18a5).

I had weekly variance boot camps with my manager, providing me with the theory that I had to translate into code. I remember reading the proposal of the [variance feature](https://github.com/dart-lang/language/issues/524) that I would be implementing and feeling overwhelmed at the seven milestones required to complete the project: (1) scan then parse the new keywords, (2) modify the kernel AST, (3) support variance in the subtyping algorithm, (4) add errors and warnings, (5) change the upper and lower bound calculation, (6) alter the type inference rules, and (7) work on the runtime behaviour changes.

Between changing the kernel (the compiler’s intermediate representation) and the subtyping logic, I needed to serialize and deserialize variance annotations. Runtime behaviour was considered a stretch goal, but I could barely understand the six tasks before it. I wasn’t sure where or how to begin.

But it got better.

I started each workday at 9 am. Scrambled eggs, sausages, kale, and orange juice were all I needed. I was ready to squint at code, wondering how in the world people made the first compiler.

I often worked on different components in parallel with one another. It kept me busy and I enjoyed organizing goals. Every morning I would create a new document that would list out what I wanted to accomplish, breaking down the goals into manageable tasks.

<DashImage src="images/06Ct-NyRGmYp_bmgp.png" alt="A typical to-do list" caption="A typical to-do list" />


At night, the Google office in Aarhus, Denmark, was active. Knowing that I had to work with a couple of engineers from Denmark, I often wrote up my questions, finalized them and sent them off late at night in Seattle. Code review times shifted forward 9 hours, but fortunately the time offset also let me proofread my own work more often before it was critiqued.

The critique from the team improved my ability to judge my own code and to contemplate the trade offs for different implementations. My reviewers pointed out areas I overlooked and asked questions about what variance is and how to use it. I’d fix my code, answer their questions, and make sure to watch out for the same issues in the future. More importantly, I’d dig deeper and ask myself, *How did they think of this improvement? What piece of knowledge can I take away from this, more than the corrected version of the code?* It was important to me that I learned from each comment, rather than mindlessly clicking the convenient **Done** button.

How I learned was through asking questions. There’s always a fragile balance between being a stubborn software engineer by gritting your teeth and grinding through code that doesn’t make any sense, and reluctantly poking the expert in that code base to help you. The latter almost always saved more time. I preferred allocating a decent amount of time to working independently, taking notes and writing questions as I came across new areas, then prodding another engineer when I had 2 or 3 questions and a solid roadblock. I realized I was much more productive inquiring about problems that would have required 3 hours of troubleshooting alone, compared to 10 minutes of direction and explanation from someone else.

Safety in a workplace also increases productivity.

Safety, for me, came in the form of asking questions, making jokes, and having lunch with the team. As soon as the clock flickered to 11:30, I knew that the next half hour would be filled with warm food and bright faces. Every day I would listen to the most elaborate stories and thoughts: the advantages of having 6 fingers, getting a cooked lobster as a Christmas gift, the hours of cleanup after mixing two different pipes in Factorio… anything and everything. My team supported me through my mistakes and my accomplishments. A good team makes it a lot easier to get out of bed in the morning to go to work.

The hours before and after lunch were also just as enjoyable. I spent most of the time reading code and understanding new concepts. The Dart compiler is comprised of many large, constantly changing components, which meant I needed to dive into a few different code bases. I loved having the opportunity to reach out to the front-end teams in charge of the static analysis, as well as the back-end teams who managed runtime behaviours. It was amazing to see how the components work together to create a new feature in the Dart language.

The rift between implementation and theory was the most challenging aspect of my project. It’s not every day that one would need to solidify a proof into tangible code. While working on variance, this rift surfaced when I had questions — sometimes my inquiries weaved the components of the language proposal with an appropriate implementation. The people I sought for answers either knew which file contained the subtyping algorithm, or knew how the subtyping changes affected assignment operations, but never both. It felt like building a treehouse with a couple pieces of plywood and an artist’s rendition of the end result.

Still, working on Dart was immensely rewarding and fun. I loved the challenge, especially knowing that there was so much to learn about areas beyond variance. Dart was, and still is, growing and evolving to better support the developers that use the language. I watched the team move like well-tuned clockwork when crucial issues surfaced and required immediate attention. I listened in as the team looked back on previous mistakes, ensuring that future processes don’t repeat them.

My internship on the Dart team improved my engineering skills, my communication skills, and my confidence in my own abilities. It taught me the importance of having a friendly, but also very functional team. It taught me the many ways that theory can translate into code, and the problem-solving techniques necessary to do so. It taught me more about myself and what I value in the work I do.

Thanks Dart. Until next time.