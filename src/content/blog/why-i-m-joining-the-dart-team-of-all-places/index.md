---
title: "Why I’m joining the Dart team, of all places"
description: "Two weeks ago, I transferred to the Dart team. For many, this was an obvious career move but there were some people who were genuinely surprised about it."
publishDate: 2016-01-07
author: filiph
image: images/19XE0rGIm0oY0GOs5onZyvQ.jpeg
category: other
tags:
  - dart
  - google
  - programming-languages
layout: blog
---


**UPDATE May 2018:** It’s 2 years later and this article still gets hundreds of reads a month. I should note some of the things below are outdated. For example, when I say “soon, you’ll be able to write Dart code for native Android and iOS apps” below — that’s already [very much possible](https://flutter.io/). So, enjoy this historical piece.

<DashImage src="images/1BMKEJA3Ej-Yxa6lx7mct7A.png" alt="One of the well-meaning responses." caption="One of the well-meaning responses." />


Responses ranged from mild astonishment to friendly teasing to outright negativity. I don’t blame them: to many people, Dart is a strange animal. You can find plenty of smart developers on the internet who strongly believe Dart won’t be successful or that it has already failed.

I strongly believe the opposite. I might be wrong, of course, but I’m sure enough about Dart that I’m betting my career on it.

So, here are a couple of reasons why I believe in Dart’s bright future. Obviously, you should keep in mind that *I’m a Google employee, on the Dart team*. I am as biased as anyone can get. If you want a non-Google-employee take, you have [other](http://astashov.github.io/blog/2015/11/18/when-dart-is-a-good-choice/) [options](http://mattbriggs.net/blog/2014/03/10/how-i-learned-to-stop-worrying/).

## **1. Dart is a big deal at Google**

<DashImage src="images/19XE0rGIm0oY0GOs5onZyvQ.jpeg" alt="Obligatory Zoolander reference." caption="Obligatory Zoolander reference." />


I can’t share the actual numbers (yet?) but there is a lot of Dart code being written at Google. Many lines of code. Every day.

Almost all of the code is mission critical. Dart is used by the product team that brings majority of the revenue to Google.

On top of that, Dart recently joined an exclusive club of only a handful of programming languages that require a special process for code reviews at Google.

In other words, Dart will be a success even if nobody except Google uses it. Having a lively community is of course a huge, *huge* blessing for any technology. It’s just that in the case of Dart, this definitely isn’t a requirement for survival right now.

## **2. Dart is very actively maintained**

Dart is stable now — currently v1.13 — but that doesn’t mean work on it has stopped or even slowed down. If you look at [github.com/dart-lang](https://github.com/dart-lang), you’ll see 139 repositories pertaining to Dart that are maintained by Google. Let’s have a look just at the core ([sdk](https://github.com/dart-lang/sdk)) repo.

For the last month, which included Christmas holidays, GitHub Pulse [reports](https://github.com/dart-lang/sdk/pulse/monthly):
> # *Excluding merges, **32** authors have pushed **408** commits to master and 412 commits to all branches. On master, 828 files have changed and there have been 93,059 additions and 88,236 deletions.*

Compare these numbers to those of other similar projects developed in the open, such as [Rust](https://github.com/rust-lang/rust/pulse/monthly), [Go](https://github.com/golang/go/pulse/monthly), [Scala](https://github.com/scala/scala/pulse/monthly), [TypeScript](https://github.com/Microsoft/TypeScript/pulse/monthly) or [Ruby](https://github.com/ruby/ruby/pulse/monthly).

I’m not saying that commit velocity is equivalent to quality or anything like that. But it should tell you something about the investment, the focus, and the rate of improvement.

Programming languages and their standard libraries are complex beasts that are never finished.

A popular programmer fantasy is that you design a beautiful, elegant system and then — it just works. They key word here is: ‘fantasy’. Yes, the technologies we use every day are often elegant in design but *more importantly* the best ones have a huge amount of work (and re-work) behind them.

Oh, and it’s not just about the quantity, of course. The team behind Dart is made of seasoned Google SWEs. People like Kasper and Lars (of V8 fame), Gilad (of Java lang spec fame), John (of inotify fame) contribute daily. And then there are guest stars like Erik (of C# and Rx fame). In my mind, the quality of SWEs is the best predictor of the quality of the technology they’re building.

## **3. Dart will soon run everywhere**

Dart’s first target was the web, but from the beginning it was designed as a general purpose programming language.

<YoutubeEmbed id="jjffmNHYHlc" title="Conway's Game of Life sample in Dart, running on Raspberry Pi + Sense HAT" fullwidth="true"/>


* You can compile Dart to JavaScript that runs in every browser.

* You can write command line tools and even servers in Dart.

* [Soon](http://dart-lang.github.io/fletch/), you’ll be able to write Dart code for micro-processors (think Raspberry Pi) and — more interestingly — for micro-*controllers* (think Arduino). This means developing for really compact, really cheap, really low-energy devices is no longer a C/C++/asm club.

* [Soon](http://flutter.io/), you’ll be able to write Dart code for native Android and iOS apps.

## **4. Dart is stable and consistent**

I’ve noticed that even early adopters are getting tired of the constant change in tooling and libraries *du jour*.

Dart is evolving, yes, but projects you wrote a year or two ago still use the same standard lib, the same language features, and the same package & dependency manager.

Even apart from that, there are ‘dartisan’ ways to do things — most Dart code I’ve seen follows the [official](https://www.dartlang.org/effective-dart/) Style Guide, Usage Guide and Design Guide. Readability is valued in the Dart community.

## **5. Programming in Dart feels right (to me)**

Ok, this is subjective. But let’s face it, our dev stack choices often are. If you can help it, you tend to use what feels right to you. Some developers love JavaScript, others hate it — although it’s still the same language. Same for Java, PHP, Ruby, or Dart.

A big reason why I’m perfectly willing to bet my career on Dart is that it’s not just me. There are a [lot](http://www.cnet.com/news/mixbook-sees-perfect-storm-for-googles-dart-language-q-a/) [of](http://suretalent.blogspot.cz/2012/04/dart-language-in-javascript-and-delphi.html) [smart](http://simonpai.github.io/2014/09/03/quire-building-with-dart/) [people](https://news.ycombinator.com/item?id=8222640) who use it and like the experience.

<YoutubeEmbed id="6p-Z6TXoN10" title="Notch recreating Doom in Dart (stream excerpt)" fullwidth="true"/>


Why? Dart is not for everyone, but for a particular type of developer it can be a breath of fresh air.

* It’s familiar (no weird syntax masturbation), especially if you’re coming from C#, ActionScript, Java, C, and the like.

* It’s unsurprising (no wtf semantics).

* It gets out of your way (*optional* types, unsoundness, GC, everything-is-an-object, mirrors)…

* … but it lets you write robust code (optional *types*, optional generics, libraries, packages, transformers).

* It makes it easy to do the usual things (async/await, string interpolation, this.field, null-aware operators).

* It comes with a well-thought-out standard lib.

So there you have it. During 2016 I think much of what I’m describing above will start to make more sense to more people.

But at least now you know why (I think) my transfer to the Dart team isn’t a complete brainfart.