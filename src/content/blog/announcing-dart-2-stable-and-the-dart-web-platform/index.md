---
title: "Announcing Dart 2 Stable and the Dart Web Platform"
description: "Signals the rebirth of Dart as a mainstream programming language for mobile and web development"
publishDate: 2018-08-07
author: kevmoo
image: images/0YX3CcH4He_IIEhzx.png
category: announcements
tags:
  - flutter
  - dart
  - programming-languages
  - web-development
  - announcements
layout: blog
---


Today, we’re announcing the immediate availability of the stable release of Dart 2, including a rewrite of the Dart web platform that offers a unique combination of productivity, performance and scalability.

<DashImage src="images/1xV5sN0ycM2OxY5BbGDhdmg.png" />


Flutter developers are already enjoying many of the benefits of Dart 2, since Flutter has been bundling prerelease versions of the Dart 2 SDK for several months. However, the stable release of Dart 2 is another important milestone towards the stable release of Flutter, due to the tight coupling between framework and language. If you haven’t already installed Flutter, [start here](https://flutter.io/get-started/install/).

With the release of Dart 2, web developers can now leverage the same language, libraries and tools along with a number of web-specific enhancements. Web developers should start at the [Get Started](https://webdev.dartlang.org/guides/get-started) page for instructions on installing tools and building a first application.

## Dart: Growing Excitement

Dart 2 marks the rebirth of Dart as a mainstream programming language focused on enabling a fast development and great user experiences for mobile and web applications. We want to enable developers building client applications to be productive, with a language, framework and components that reduce boilerplate and let them concentrate on the business logic, along with tooling that identifies errors early, enables powerful debugging and delivers small, fast runtime code.

Over the last year, Dart has seen dramatic growth. Our own analytics suggest a ten-fold growth in external usage. In the last quarter, Dart was [one of the fastest growing languages on GitHub](https://madnight.github.io/githut/#/pull_requests/2018/2), as measured by pull requests; the growth of [StackOverflow questions](http://sotagtrends.com/?tags=[dart,perl,haskell,rust]&relative=false) also provides a vivid demonstration of Dart’s momentum:

<DashImage src="images/0s3bqLPad7xh_nFH-.png" />


Internally, Dart is one of a handful of languages Google uses for web application development, with millions of lines of code from dozens of different projects including Google Ads, Google Shopping and our own internal infrastructure teams.

In fact, you might already be using Dart without realizing it: the popular [Sass stylesheet preprocessor](https://sass-lang.com/) was recently [rewritten in Dart](http://sass.logdown.com/posts/7045860-dart-sass-100-is-released) to make it faster, more portable, and easier to write. Sass is now distributed as a standalone executable on Homebrew and Chocolatey, and compiled to pure JavaScript on npm. Dart makes it easy to install applications anywhere without external dependencies, and to slot into the workflows of both people who use Dart and people who don’t.

<DashImage src="images/0YX3CcH4He_IIEhzx.png" />


Dart 2 is focused on three areas: strengthening and tightening the language, developing our support for web and mobile frameworks, and bringing some of the tooling and components that support Google’s usage of Dart to the outside world. The rest of this post will explore these themes.

## Dart 2: A Client-Optimized Language

As we [highlighted in February](https://medium.com/dartlang/announcing-dart-2-80ba01f43b6), the [Dart type system](https://www.dartlang.org/guides/language/sound-dart) is *sound*. This means that a large class of issues is found before your users run your application — during analysis and compilation. As we scaled Dart to extremely large apps within Google, the type system caught more errors early in the development cycle, leading to higher quality production code.

With Dart 2, you can’t get into a state where an expression evaluates to a value that doesn’t match the expression’s static type. This means that you can scale your codebase to millions of lines, tackle large refactoring projects, and deploy your code with confidence.

Don’t worry: soundness doesn’t mean mountains of boilerplate. The type system includes advanced inference — even for generic type arguments.

```
final _field = [3.14, 6.28];

void main() {
  // No type parameter is provided, but <int> is inferred
  print([1, 2, 3].runtimeType); // List<int>

  // If types are unmatched, their common base type is used
  // int (1) and double (3.14) are both `num`
  print([1, 3.14].runtimeType); // List<num>

  // Inference goes beyond variables.
  // You can omit types on fields, too.
  print(_field.runtimeType); // List<double>
}
```


To learn more about the Dart 2 type system, check out [this page](https://www.dartlang.org/guides/language/sound-dart).

As mentioned in previous blog posts, Dart 2 also reduces the language ceremony in a few key areas: for example, the `new` keyword is now optional, and the `const` keyword is optional within a constant context.

Lastly, we’ve done lots of work behind the scenes to unify various supporting tools, with a common front-end that now supports our compilers and runtimes. This ensures consistency for our users now and promises to improve the velocity and quality of new features as Dart continues to evolve.

## Dart on the Web: A Rich, Powerful Framework

Web applications have been central to Dart’s mission from the start. In fact, most Dart development at Google is for web applications. One of the biggest is Google Ads, which powers billions of dollars of the web economy. In the process of migrating their code to Dart, they reduced the size of their UI codebase by 40% while improving developer productivity and application quality.

While the core Dart SDK provides libraries to access modern browser APIs, we also support a robust Angular-inspired framework for building complex web applications. [AngularDart 5](https://webdev.dartlang.org/angular), shipped as part of Dart 2, takes advantage of Dart’s sound type system and the [new build system](https://github.com/dart-lang/build) (described below) to offer fast incremental builds during development and smaller compiled JavaScript when you’re ready to deploy.

One major area of focus for this release has been improving the amount of code that is processed on page load, significantly reducing the ‘time to interactivity’ for web pages. Many apps have seen code size reduced by more than half compared to AngularDart 4.

To showcase the improvements in Dart’s web platform, we built out a [Dart-based client implementation for the HackerNews site](https://hnpwa.dartlang.org/) as a Progressive Web App; this is published along with other sample implementations at the popular [HNPWA site](https://hnpwa.com/). Using best practices for building Dart web apps, we were able to ship a full-featured experience that is fully interactive in one second on modern devices and under five seconds on a modest mobile device on a slow 3G network. This is competitive even with lightweight web frameworks that are optimized for smaller apps.

<DashImage src="images/1Zf8U7ODhydytCsOn6_pQcw.png" alt="[hnpwa.dartlang.org](https://hnpwa.dartlang.org/)" caption="[hnpwa.dartlang.org](https://hnpwa.dartlang.org/)" />


Our framework investments extend to our [core components](https://pub.dartlang.org/packages/angular_components), which we’ve also updated. You now have access to 100 new classes, including a number of date, time, and menu [Material components](https://material.io/). You can explore all of our components in the [component gallery](https://dart-lang.github.io/angular_components_example/).

<DashImage src="images/0drInYm1m0XD2vGZS.gif" alt="*Material Date Picker — one of the rich components available for your web application*" caption="*Material Date Picker — one of the rich components available for your web application*" />


## Flexible Tooling for Dart 2

With Dart 2, Dart becomes a first-class compiled-to-JavaScript language, with a dev cycle that web developers expect and excellent runtime performance characteristics. This is done while providing benefits most JS-targeted languages don’t provide: a sound type system and excellent support for native mobile apps.

With Dart 2, our web tools embrace a 100% JavaScript development model with two complementary JavaScript compilers. The development compiler, [dartdevc](https://webdev.dartlang.org/tools/dartdevc), provides fast incremental compilation while generating JavaScript that is easy to read and debug. This allows our production compiler, [dart2js](https://webdev.dartlang.org/tools/dart2js), to focus on producing highly optimized JavaScript for progressive web apps for mobile and complex enterprise experiences for the desktop. Both compilers leverage Dart’s sound type system to optimize their output.

Our web tools are based on a [new build system](https://github.com/dart-lang/build), designed to be fast, debuggable, and extensible. Now tasks like generating serialization code, compiling Sass to CSS and compiling Dart to JavaScript happen in one toolchain that supports fast, incremental updates as you change parts of your application. The build system is also designed to support uses beyond the web. An example: it’s being used by Flutter developers, to generate [JSON serialization code](https://flutter.io/json/#serializing-json-using-code-generation-libraries).

With Dart 2, we also have an expanded set of developer tools. In addition to support for [Android Studio](https://developer.android.com/studio/) and the JetBrains suite of tools, including [IntelliJ IDEA](https://www.jetbrains.com/idea/) and [WebStorm](https://www.jetbrains.com/webstorm/), we also support [Visual Studio Code](https://code.visualstudio.com/) with the [Dart Code extension](https://dartcode.org/). And we also have a great scratchpad for experimenting: [DartPad](https://dartpad.dartlang.org/), which has been fully updated for Dart 2.

Finally, the Dart SDK comes with a suite of other useful tools: a package manager that works with our [package site](https://pub.dartlang.org/), a [static analyzer](https://www.dartlang.org/tools/analyzer), a linter that you can consume from the command line or as a package, and tooling for [web documentation](https://pub.dartlang.org/packages/dartdoc) and [code formatting](https://pub.dartlang.org/packages/dart_style) that conforms with the [Dart style guide](https://www.dartlang.org/guides/language/effective-dart/style).

## Learn more

Check out the instructions for getting started with [Flutter](https://flutter.io/get-started/install/) and the [Dart web toolset](https://webdev.dartlang.org/guides/get-started).

The [release](https://groups.google.com/a/dartlang.org/forum/#!topic/announce/IUWWXwL7QB4) notes provide a detailed technical breakdown of the numerous other smaller improvements made since Dart 1, some of which are breaking changes for older Dart code. If you run into problems that a Google search can’t solve, we recommend starting at [StackOverflow](https://stackoverflow.com/questions/tagged/dart). Subscribe to the [Dart Announcements](https://groups.google.com/a/dartlang.org/forum/#!forum/announce) mailing list and [follow us on Twitter](https://twitter.com/dart_lang) to get updates. We’d also love to see you in our communities, for example the [Gitter](https://gitter.im/dart-lang/home) chat room and [r/dartlang subreddit](https://www.reddit.com/r/dartlang/).

## Thank you

Dart has become a general purpose language that is optimized for web and mobile development. We’ve been working on Dart 2 for several years, during which time it has touched every aspect of our ecosystem and required migrating millions of lines of code and hundreds of packages.

We are grateful to the [Dart](https://www.dartlang.org/) and [Flutter](https://flutter.io/) communities and well as the hundreds of Google engineers who have helped us on this journey. We couldn’t have done it without you!