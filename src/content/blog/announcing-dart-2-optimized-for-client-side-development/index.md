---
title: "Announcing Dart 2: Optimized for Client-Side Development"
description: "Today, we’re announcing Dart 2, a reboot of the language to be uniquely optimized for client-side development for web and mobile."
publishDate: 2018-02-22
author: asandholm
image: images/1E9T7YsI_ZU8gk4CewQg_QA.jpeg
category: announcements
tags:
  - dartlang
  - flutter
  - mobile-app-development
  - web-development
  - announcements
layout: blog
---


<DashImage src="images/1E9T7YsI_ZU8gk4CewQg_QA.jpeg" />


Today, we’re announcing [Dart 2](http://dartlang.org), a reboot of the language to embrace our vision of Dart: as a language uniquely optimized for client-side development for web and mobile.

With Dart 2, we’ve dramatically strengthened and streamlined the type system, cleaned up the syntax, and rebuilt much of the developer tool chain from the ground up to make mobile and web development more enjoyable and productive. Dart 2 also incorporates lessons learned from early adopters of the language including [Flutter](http://flutter.io), [AdWords](https://news.dartlang.org/2016/03/the-new-adwords-ui-uses-dart-we-asked.html), and [AdSense](https://news.dartlang.org/2016/10/google-adsense-angular-dart.html), as well as thousands of improvements big and small in response to customer feedback.

## Dart’s Core Tenets

Before we talk more about the advances in Dart 2, it’s worth identifying why we believe Dart is well positioned for the needs of client-side developers.

In addition to the attributes necessary for a modern, general purpose language, client-side development benefits from a language that is:

* **Productive.** Syntax must be clear and concise, tooling simple, and dev cycles near-instant and on-device.

* **Fast.** Runtime performance and startup must be great and predictable even on small mobile devices.

* **Portable.** Client developers have to think about three platforms today: iOS, Android, and Web. The language needs to work well on all of them.

* **Approachable.** The language can’t stray too far from the familiar if it wishes to be relevant for millions of developers.

* **Reactive.** A reactive style of programming should be supported by the language.

Dart has been used to ship many high-quality, mission-critical applications on the web, iOS, and Android at Google and elsewhere and is a great fit for mobile and web development:

* Dart increases developer velocity because it has a clear, succinct syntax and is able to run on a VM with a JIT compiler. The latter allows for [stateful hot reload](https://flutter.io/hot-reload/) during mobile development, resulting in super fast dev cycles, where you can edit code, compile and replace in the running app on the device.

* With its ability to efficiently compile to native code ahead of time, Dart provides predictable, high performance and fast startup on mobile devices.

* Dart supports compilation to native code (ARM, x86, etc.) for fast mobile performance as well as transpilation to efficient JavaScript for the web.

* Dart is approachable to many existing developers, thanks to its unsurprising object-oriented aspects and syntax that — according to our users— allows any C++, C#, Objective-C, or Java developer to be productive in a matter of days.

* Dart works well for reactive programming with its battle-hardened core libraries, including streams and futures; it also has great support for managing short-lived objects through its fast generational garbage collector.

## Dart 2: Better Client-Side Development

In Dart 2, we’ve taken further steps to solidify Dart as a great language for client-side development. In particular, we’ve added several new features including strong typing and improving how UI is defined as code.

### Strong, Sound Typing

The teams behind AdWords and AdSense have built some of Google’s largest and most advanced web apps with Dart to manage the ads that are bringing in a large share of Google’s revenue. From working closely with these teams, we identified a big opportunity to strengthen Dart’s type system. This helps Dart developers catch bugs earlier in the development process, better scale to apps built by large teams, and increase overall code quality.

This isn’t unique, of course. In the broader web ecosystem, there’s also a growing trend towards adding type annotations to JavaScript. For example, [TypeScript](https://www.typescriptlang.org/) and [Flow](https://flow.org/) both extend JavaScript with type annotations and inference to improve the ability to analyze code.

In the small example below, Dart 2’s type inference helps uncover a somewhat subtle error and as result, helps improve overall code quality.

```dart
void main() {
  List<int> prices = ['99', '27', '10000', '20000000'];
  
  // Sort in place from smallest to largest
  prices.sort();
  
  print('Lowest price is ${prices[0]}!');
}
```

What does this code do? You could reasonably expect that it would print ‘27’. But without Dart 2’s sound type system enabled it prints ‘10000’, because that happens to be the least element in the list of strings when ordered lexicographically. With Dart 2, however, this code will give a type error.

### UI as Code

When creating UI, having to switch between a separate UI markup language and the programming language that you’re writing your app in often leads to frustration. We’re striving to make the definition of UI as code a delightful experience to dramatically reduce the need for this context switching. Dart 2 introduces optional `new` and `const`. This much-requested feature is very valuable on its own, and also sets the direction for [other things to come](https://github.com/dart-lang/sdk/issues/27678). For example, with optional `new` and `const` we can clean up the definition of a UI widget so that it doesn’t use a single keyword.

```dart
// Before Dart 2
Widget build(BuildContext context) {
  return new Container(
    height: 56.0,
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    decoration: new BoxDecoration(color: Colors.blue[500]),
    child: new Row(
      ...
    ),
  );
}

// After Dart 2
Widget build(BuildContext context) =>
  Container(
    height: 56.0,
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    decoration: BoxDecoration(color: Colors.blue[500]),
    child: Row(
      ...
    ),
  );
```

## Client-Side Uses of Dart

### Mobile

One of the most significant uses of Dart is for [Flutter](http://flutter.io), Google’s new mobile UI framework to craft high-quality native interfaces for iOS and Android. The [official app](https://developers.googleblog.com/2017/08/hamilton-app-takes-stage.html) for the hugely popular show [Hamilton: The Musical](https://hamiltonmusical.com) is an example of what Flutter is enabling developers to build in record time. Flutter uses a reactive programming style and controls the entire UI pixel by pixel. For Flutter, Dart fits the bill in terms of ease of learning, reactive programming, great developer velocity, and a high-performance runtime system with a fast garbage collector.

### Web

Dart is a proven platform for mission-critical web applications. It has web-specific libraries like `dart:html` along with a full Dart-based [web framework](https://webdev.dartlang.org/). Teams using Dart for web development have been thrilled with the improvements in developer velocity. As Manish Gupta, VP of Engineering for Google AdWords, explains:
> The AdWords front-end is large and complex, and is **critical to the majority of Google’s revenue.**
> We picked Dart because of the great combination of **perf and predictability, ease of learning, a sound type system, and web and mobile support.**
> Our engineers are **two to three times more productive** than before, and we’re delighted we switched.

## Moving Forward

With Flutter and Dart, developers finally have the opportunity to write production-quality apps for Android, iOS, and the web with no compromises, using a shared codebase. As a result, team members can fluidly move between platforms and help each other with, e.g., code reviews. So far, we have seen teams like [AdWords Express](https://www.youtube.com/watch?v=PLHln7wHgPE) and [AppTree](https://www.youtube.com/watch?v=GpLb2XvKv20) share between 50% and 70% of their code across mobile and web.

Dart is an [open source project](https://github.com/dart-lang) and an open [ECMA standard](https://www.ecma-international.org/publications/standards/Ecma-408.htm). We welcome contributions to both the [Dart core project](http://github.org/dart-lang/sdk/) and the ever growing ecosystem of [packages for Dart](http://pub.dartlang.org).

You can try out Dart 2 in [Flutter](https://github.com/flutter/flutter/wiki/Trying-the-preview-of-Dart-2-in-Flutter) and the [Dart SDK](http://dartlang.org/install) from the command line. For the Dart SDK, get the latest Dart 2 pre-release from the dev channel and make sure to run your code with the `--preview-dart-2` flag. We also invite you to join our community on [gitter](https://gitter.im/dart-lang/home).

With the improvements announced today, Dart 2 is a productive, clean, battle-tested language that addresses the challenges of modern app development. It’s already loved by some of the most demanding developers on the planet, and we hope you’ll love it too.