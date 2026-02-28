---
title: "Announcing Dart 2.1: Improved performance & usability"
description: "Today, we’re announcing the stable release of Dart 2.1, an update to Dart 2 that new language features and performance improvements"
publishDate: 2018-11-15
author: mit-mit
image: images/1xZHP-8eEl6qJCCTKXyQZ8w.png
category: announcements
tags:
  - dart
  - flutter
  - programming
  - programming-languages
  - announcements
layout: blog
---


Today, we’re announcing the stable release of Dart 2.1, an update to Dart 2 that offers smaller code size, faster type checks, better usability for type errors, and new language features to improve productivity when building user experiences.

<DashImage src="images/1xZHP-8eEl6qJCCTKXyQZ8w.png" />


## Landing Dart 2

Dart 2 was a huge upgrade to the Dart platform. It completed the transformation from our early web roots to a mainstream programming language suitable for fast development of rich user experiences across mobile and web. Dart is somewhat unique as a language in offering both a virtual machine (VM) and compilation to both native machine code and JavaScript. This supports the differing needs of the various platforms, for both development and production.

As part of the transition to Dart 2, we added a [sound type system](https://www.dartlang.org/guides/language/sound-dart) to support large teams building complex apps, new compiler support for generating native code optimized for mobile devices, and completely reworked [web platform tools](https://webdev.dartlang.org/tools). Dart powers [Flutter](https://flutter.io), our fast-growing toolkit for building beautiful native experiences for iOS and Android from a single code base; it is also the language used by some of the largest projects at Google, such as Google Ads.

Since the [launch of Dart 2](https://medium.com/dartlang/dart-2-stable-and-the-dart-web-platform-3775d5f8eac7) back in August, we’ve worked on getting the whole ecosystem onto Dart 2. We switched our [dartlang.org](https://www.dartlang.org/) website over to use Dart 2 examples everywhere, and we offered [tools and documentation for migrating](https://medium.com/dartlang/getting-ready-for-dart-2-and-making-your-packages-look-great-on-the-pub-site-118464d7f59d) Dart 1.x packages. We understand that the large changes in Dart 2 involved migration work for existing Dart developers, and we’re very thankful to those who have helped us build a new foundation for the future. Our focus now shifts to taking advantage of these investments to deliver improvements to performance and productivity.

## Dart 2.1 language support for int-to-double conversion

New Flutter developers are often tripped up by analysis errors like these when specifying padding, setting font sizes, etc.:

<DashImage src="images/19hItMsF9iM2BHzbuJkHNbg.png" />


From a system point of view, these errors make sense: The API expects one type (a double), and the developer specifies a value of a different type (an int). However, from a usability point of view it seems a bit foolish: There is a trivial conversion from int to double, so why not just do that? Dart 2.1 now [infers where an int can be silently evaluated as a double](https://github.com/dart-lang/language/issues/4):

<DashImage src="images/1bJV4DQzBey1fc64nerTprg.png" />


## Dart 2.1 language support for mixins

We also [improved Dart’s support for mixins](https://github.com/dart-lang/language/issues/7). If you haven’t encountered Dart mixins before, it’s worth reading this great [introduction to Dart mixins](https://medium.com/flutter-community/dart-what-are-mixins-3a72344011f3) by Romain Rastel. Dart 2.1 introduces a new syntax for mixins, featuring a new `mixin` keyword that you can use to define classes that can only be used as mixins. We’ve also added support so that mixins can extend other classes (previously they could only extend `Object`) and can invoke methods in their superclass.

One example of extending non-Object classes is from Flutter’s [animation APIs](https://flutter.io/tutorials/animation/#rendering-animations), where the `SingleTickerProviderStateMixin` — a framework class that provides a ticker for advancing an animation by a single frame — [declares a mixin](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/ticker_provider.dart#L66) that implements the general TickerProvider interface. Animations are only applicable to stateful widgets (as the position in the animation is considered state). The new mixin support allows us to express this by declaring that only classes that extend the Flutter State class can use the mixin:

<DashImage src="images/0uUIuZJgNCevxAkZQ.png" />


## Dart 2.1 compile-time type checks

Dart 2’s sound type system protects you during development, telling you when you violate the contract specified by the types. For example, let’s say you’re creating a state class for Flutter. This class is expected to extend the framework `State` class. A `State` class expects to be passed the `StatefulWidget` that it contains the state for.

<DashImage src="images/1Y_8yHDINe7LtvmyFmCqWzw.png" />


Now, should you make a programming mistake and — say — pass it a descendant of `StatelessWidget` instead of `StatefulWidget`, the type information enables the tools to catch the mistake and show you a warning immediately:

<DashImage src="images/1Ym0nqsHWlTscD140Urk0xw.png" />


These *edit-time* type checks were added in Dart 2.0 (powered by the [Dart Analyzer](https://www.dartlang.org/tools/analyzer)). However, there is another place where you might expect these type checks, namely at *compile time*, when you do a Flutter release build. These checks were incomplete in Dart 2.0, which could lead to usability issues where bad source code could compile without producing any errors. In Dart 2.1, these checks are complete, and the Analyzer and Dart compiler contain the same checks.

## Dart 2.1 performance improvements for Flutter developers

Dart 2 was generally faster than Dart 1.x for [AOT-compiled code](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf) running on our VM, such as Flutter apps. In a few edge cases, though, the comprehensive checks added by the [new type system](https://www.dartlang.org/guides/language/sound-dart) caused an undesirable overhead of 20–40%. In Dart 2.1 we’ve greatly reduced the cost of the type checks, both for AOT-compiled code and for code run in the VM with JIT (just-in-time) compilation.

One concrete case that benefits from this is our developer tools (which run using the VM). For example, performing code analysis of one large benchmark app (based on multiple concatenated copies of the Flutter Gallery) used to take ~41 seconds; now it takes ~25 seconds.

## Dart 2.1 performance improvements for web developers

We also improved the code size and compile time for Dart code running on the web. We focused on the output size of [dart2js](https://webdev.dartlang.org/tools/dart2js) and are seeing good results, such as a [17% reduction in minified output size and 15% improvement in compilation time](https://twitter.com/kevmoo/status/1055292888626515968) for one of our samples.

## Changes beyond the core SDK

In addition to the above-mentioned changes in the Dart SDK, we’ve made some exciting changes outside of the core SDK.

Protocol buffers (or *protobuf* for short) are a platform-neutral mechanism for serializing structured data. They’re used extensively inside of Google and are also seeing strong adoption outside of Google — for example as part of [gRPC](https://grpc.io/). Dart is now an officially supported protobuf language, and we have added detailed documentation on the [core protocol buffers website](https://developers.google.com/protocol-buffers/) with both a [tutorial](https://developers.google.com/protocol-buffers/docs/darttutorial) and [reference](https://developers.google.com/protocol-buffers/docs/reference/overview) documentation.

You may have heard about [knative](https://cloud.google.com/knative/) — a platform based on [Kubernetes](https://kubernetes.io/) — to support building, deploying, and managing serverless workloads. We recently investigated support for serving Dart code on knative, and [created a small sample](https://github.com/knative/docs/tree/master/serving/samples/helloworld-dart). This is likely too low-level for most Dart app developers, but we find it very exciting from a platform perspective, and anticipate this will be a critical building block to get better support for serving Dart code in the Google Cloud — for example to create backends for Flutter apps.

## Getting Dart 2.1

[Dart SDK 2.1](https://www.dartlang.org/tools/sdk/archive) is available from the Dart homepage. If you’re a Flutter developer, Dart 2.1 is included as part of the upcoming Flutter 1.0 release.

We’ve also updated [DartPad](https://dartpad.dartlang.org/) to run Dart 2.1, and have added samples for [int-to-double](https://dartpad.dartlang.org/e93b969fed77325db0b848a85f1cf78e) and [mixins](https://dartpad.dartlang.org/b60dc2fc7ea49acecb1fd2b57bf9be57).

## What’s next

We expect to ship several 2.x releases that take advantage of the Dart 2 platform foundation. We’ll base these on the needs of our framework partners and app developers. In 2019 we expect to investigate the following areas:

* Continued evolution of the Dart language: For Dart 2.2, we’re investigating a number of changes, such as refinements to [const expressions](https://github.com/dart-lang/language/issues/61) and support for a new [Set literal](https://github.com/dart-lang/language/issues/37). Beyond 2.2 we’re looking into our support for Unicode strings, and are investigating whether we can offer better null safety.

* Further improvements to optimize Dart as a language for creating user interfaces: Dart 2 began this journey with its new type system and optional new, Dart 2.1 added int to double value inference, and we are currently investigating a number of potential improvements such as support for [conditionals in widget lists](https://github.com/dart-lang/language/issues/78), [expanding collections of objects](https://github.com/dart-lang/language/issues/47) into other collections, and even potentially [removing the need to terminate statements](https://github.com/dart-lang/language/issues/72) with semicolons.

* Even better performance: We’ll continue to reduce the size and performance of compiled Dart code, including better support for using multi-core processors, further reduction of code size to improve download and startup time, and potentially more control for whether size or runtime performance is most critical.

For more about both Dart and Flutter, we’d love you to join us at [Flutter Live](https://developers.google.com/events/flutter-live/), an online event taking place on December 4th that will be streamed live on the web. We’re excited to share more about the roadmap with you then.

That’s it for now. We hope you enjoy Dart 2.1!