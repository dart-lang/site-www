---
title: "An update on Dart macros & data serialization"
description: "We have invested significant time and resources to prototype macros over the past couple years. Unfortunately, each time we solved a major…"
publishDate: 2025-01-29
author: "vijaysmenon"
---


We have invested significant time and resources to prototype [macros](https://dart.dev/language/macros) over the past couple years. Unfortunately, each time we solved a major technical hurdle, we saw new ones pop up. At this point, we are not seeing macros converging anytime soon toward a feature we are comfortable shipping, with the quality and developer-time performance we want.

After considering the opportunity cost — in particular, the features we could be shipping to the community instead — we’ve made the difficult decision to stop our work on macros.

## Background

We believe that Dart offers a unique combination of strengths: (1) the ahead-of-time compilation and performance typical of static languages, and (2) the fast development cycle (e.g., stateful hot reload) typical of dynamic languages. As we’ve evolved Dart, we’ve been careful to evaluate language changes against both of these rubrics.

Powerful metaprogramming — built on rich introspection — has always been a challenge in this context. Runtime introspection (e.g., reflection) makes it difficult to perform the tree-shaking optimizations that allow us to generate smaller binaries. Static introspection (e.g., macros) can take a couple forms. Most languages take a syntactic approach, with limited static reflection on the syntax of programs. We did not believe this was sufficient to achieve our goals. Instead, we aimed to build a macro system which supported deep semantic introspection on the program at compile time. Semantic introspection, unfortunately, turned out to introduce large compile-time costs which made it difficult to keep stateful hot reload *hot*.

We’ve concluded we’re simply too far away from shipping macros with the developer-time performance we require. Our current implementation regresses both editing (e.g., static analysis and code completion) and incremental compilation (the first step of a hot reload). We are not confident we can adequately solve these problems in a reasonable timeframe.

## Moving Forward

We’ve decided to focus on other features we’re more confident about shipping.

One area we’ll be investing in is better support for data in Dart. This is the [most requested issue](https://github.com/dart-lang/language/issues/314) across the Dart & Flutter issue trackers. In fact, our primary motivation for macros was to provide better data handling, serialization, and deserialization. We will still pursue better data, but we intend to do so with more bespoke language features.

Another area we’ll be investing in is improving build times and the overall code generation experience. We’ve already identified [improvements for build_runner](https://github.com/dart-lang/build/issues/3800). We also plan to ship [augmentations](https://github.com/dart-lang/language/blob/main/working/augmentation-libraries/feature-specification.md), a feature we prototyped as part of macros. We believe this language feature stands on its own and will improve existing code generation. We still aim to [ship this feature](https://github.com/dart-lang/language/issues/4154) independently.

We understand this news will be disappointing to many of you. We remain interested in [exploring general metaprogramming](https://github.com/dart-lang/language/issues/1482) in the long term as it has a number of potential use cases beyond data. Nevertheless, we also want to be clear with our community that we will not be shipping macros in the foreseeable future.

We’d like to thank everyone who tried macros, provided feedback, and contributed directly via PRs. That input and energy will feed into the work we do next. We’re excited about the improvements we can offer this year.