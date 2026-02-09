---
title: "Announcing Dart 2.8"
description: "Faster package tools, new tool for ensuring dependencies never go stale"
publishDate: 2020-05-06
author: "mit-mit"
image: images/1JrrSSD8LCLMkAUIV8RJlkw.png
category: announcements
tags:
  - dart
  - flutter
  - dependency-management
  - announcements
---


Today we’re announcing a new release of the Dart SDK, version 2.8. We’re continuing to see amazing growth in the Dart community; we now have [millions of Flutter developers](https://medium.com/flutter/flutter-spring-2020-update-f723d898d7af) using Dart as their client-optimized language for building fast apps on any platform. While we’re still working hard on completing our [upcoming null safety](https://medium.com/dartlang/dart-2-7-a3710ec54e97) feature to make Dart an even more optimized language for building fast and stable user interfaces, we have a few exciting new features focused on making developers even more productive when managing dependencies.

The Dart platform comes with built-in support for package management via the [pub client tool](https://dart.dev/tools/pub/cmd) and the [pub.dev](https://pub.dev/) package repository, which has grown 200% over the past year and now is home to nearly 10,000 packages. As part of our ongoing work to improve the Dart ecosystem, the Dart 2.8 SDK brings two improvements to the pub client tool: much better performance in `pub get`, and a new tool for ensuring your package dependencies are kept up-to-date.

Dart 2.8 also brings a set of small breaking changes in the Dart language and libraries. These changes lay the groundwork for our first version of the null safety feature.

<DashImage src="images/1JrrSSD8LCLMkAUIV8RJlkw.png" alt="Announcing Dart 2.8: Faster package tools, new tool for ensuring dependencies never go stale" caption="Announcing Dart 2.8: Faster package tools, new tool for ensuring dependencies never go stale" />


## Breaking changes paving the way for null safety

A common source of app crashes is code that attempts to use a variable that happens to be `null`. Sir Tony Hoare, who introduced null references in the ALGOL programming language in 1965, famously called them his *“billion-dollar mistake”* in a [QCon talk in 2009](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/). In some cases null values are useful; the challenge is separating those from the cases where they aren’t. For the past year we’ve been busy building support for [sound null safety](https://github.com/dart-lang/language/issues/110) in Dart. This support will extend the type system to express variables that are always non-nullable, but in addition the type system will be fully sound: the Dart compilers and runtimes will be able to trust those types, and be able to produce optimized code when the type system guarantees that a variable isn’t null.

As you can imagine, this is a large undertaking with a lot of moving parts. To ensure that we can build null safety with clean semantics, we’ve decided to make some small breaking changes in the Dart language and libraries. These breaking changes make minor adjustments to corner cases of the Dart type system and to a few Dart core libraries to ensure great nullability-related usability and performance. We expect the actual impact of these breaking changes — which were [pre-announced](https://groups.google.com/a/dartlang.org/g/announce/c/JwPWiC0jTiU) on the Dart announcement list — to be minimal for regular app code. If you experience any issues with Dart 2.8, we encourage you to review [the breaking changes](https://github.com/dart-lang/sdk/issues/40686) and their descriptions and mitigation steps. If that doesn’t resolve the issue, please file an issue in [our issue tracker](https://github.com/dart-lang/sdk/issues). For a preview of the null safety experience, try the [null safety playground](https://nullsafety.dartpad.dev/53257b6da4cb128dc1e069df64748ed1).

## A higher quality package ecosystem

The pub package manager and [pub.dev](https://pub.dev) site power an ever-growing ecosystem for Dart and Flutter. Nearly 10,000 packages are available at pub.dev, and we’re continually amazed by the many interesting packages being shared. It’s been our core mission to help package authors create high-quality packages and to help app developers find those packages — for example, we’ve added [improved pub.dev discovery](https://medium.com/dartlang/improved-discovery-on-the-dart-package-site-9bfe24c3d7d3), [verified publishers](https://medium.com/dartlang/verified-publishers-98f05466558a), and [Flutter Favorites](https://flutter.dev/docs/development/packages-and-plugins/favorites).

Today we’re announcing much faster performance when retrieving packages from the [pub.dev](https://pub.dev) repository, and a new tool to help you keep all your package dependencies updated. With the complexity of modern apps, your app likely depends on dozens of packages. But how do you keep them all updated to the latest version, to ensure you are getting the most recent dependencies with all the bug fixes and performance improvements available? As of Dart 2.8, you can use `pub outdated`, a new tool for automatically determining which of your dependencies need to be updated to the latest and greatest versions.

## Dart 2.8 pub tool performance improvements

We optimized the performance of the pub tool by adding support for parallel fetching of packages when running `pub get`, and by deferring `pub run` precompilation.

In an informal benchmark of running `flutter pub get` on a new project created with `flutter create`, the total execution time decreased from about 6.5 seconds in Flutter 1.12 (which uses Dart 2.7) to just 2.5 seconds with Flutter 1.17 (Dart 2.8). In a larger app like the [Flutter gallery](https://github.com/flutter/gallery), the time drops from about 15 seconds to about 3 seconds!

## Managing dependencies with `pub outdated`

<DashImage src="images/1av2bRfpUdU2Fk4s8xRPnhA.gif" />


Dependencies in Dart code are captured in the [pubspec](https://kw-staging-dartlang-2.firebaseapp.com/tools/pub/pubspec) file. When you retrieve packages from [pub.dev](https://pub.dev/) by running the `pub get` command, the pub version solver (which uses the [PubGrub](https://medium.com/@nex3/pubgrub-2fb6470504f) algorithm) runs a process to determine the latest possible set of versions of all your dependencies that satisfies the constraints listed in your pubspec. Note that pub uses a single-version scheme where each package is included in a single-version-only in your app; this is an important optimization to ensure that your app size is as small as possible.

It’s [a best practice](http://dart.dev/tools/pub/dependencies#best-practices) to always use the latest stable package versions, but doing so can be laborious. Dart has support for upgrading to the latest versions that are [semantically compatible](https://dart.dev/tools/pub/dependencies#version-constraints) using [`pub upgrade`](https://dart.dev/tools/pub/cmd/pub-upgrade), but you can’t include new major versions of packages without updating the pubspec. The `pub outdated` command helps you understand when both minor and major versions are available by comparing currently used versions against the latest versions available on pub.dev.

Let’s consider a concrete example. Imagine you’re building an app, and its `pubspec.yaml` contains the following:

```
dependencies:
  foo: ^1.3.0
  bar: ^2.0.0
```


You run `pub get`, and the tool creates a `pubspec.lock` file with the following versions:

```
packages:
  foo:
    version: "1.3.0"
  bar:
    version: "2.0.1"
```


A few months pass, and pub.dev now has new versions of `foo` (1.3.1) and `bar` (2.1.0 and 3.0.3). How do you discover that these new versions are available? For the minor version upgrades (`foo` 1.4.0 and `bar` 2.1.0) you could run pub upgrade, but that wouldn’t give you `bar` 3.0.0. To discover that new version you’d have to visit each package on pub.dev and look at its latest version. Alternatively, you could use a community solution like Paulina Szklarska’s [version checker](https://plugins.jetbrains.com/plugin/12400-flutter-pub-version-checker) or Jeroen Meijer’s [pubspec assist](https://marketplace.visualstudio.com/items?itemName=jeroen-meijer.pubspec-assist).

With `pub outdated`, the Dart SDK now supports version discovery. If you’re using an IDE with Dart or Flutter support, use the **Pub outdated** action that’s shown when the `pubspec.yaml` file is open. Or you can run `pub outdated` (or `flutter pub outdated`) from the terminal:

```
**$** pub outdated

Dependencies            Current  Upgradable  Resolvable  Latest
foo                     1.3.0    1.3.1       1.3.1       1.3.1
bar                     2.0.1    2.1.0       3.0.3       3.0.3

1 upgradable dependency is locked (in pubspec.lock) to an older version.

To update it, use `pub upgrade`.

1 dependency is constrained to a version that is older than a resolvable version.
```


This output tells us that we can automatically upgrade to `foo` 1.3.1 with `pub upgrade`, which will put us on the latest version available of `foo`. But it also tells us that while we could upgrade automatically to `bar` 2.1.0, a version 3.0.3 is available. Because the upgrade to `bar` 3.0.3 is a major version upgrade, we need to opt into that upgrade by editing our `pubspec.yaml` file:

```
dependencies:
  foo: ^1.3.0
  bar: ^3.0.3
```


After we make that edit and run `pub upgrade`, `pub outdated` now reports that all dependencies are up-to-date:

```
**$** pub outdated

Dependencies            Current   Upgradable  Resolvable  Latest

all up-to-date
```


Success, we’re up-to-date! Because we just picked up new versions, including a new major version, we should review any potential breaking changes in those versions, and run all tests to make sure that our app still works as expected.

## Next steps

The performance improvements, [breaking changes](https://github.com/dart-lang/sdk/issues/40686), and new `pub outdated` command are available today in the stable [Dart 2.8 SDK](https://dart.dev/get-dart) and in the stable [Flutter 1.17 SDK](https://flutter.dev/docs/get-started/install). We recommend that you [run `pub outdated` today](https://dart.dev/tools/pub/cmd/pub-outdated) to see the health of your dependencies!

Should you find any issues, please report them in the [pub issue tracker](https://github.com/dart-lang/pub/issues), or in the [SDK issue tracker](https://github.com/dart-lang/sdk/issues) for general issues. We’d love to hear about your experience with `pub outdated`. Leave a comment below or send a tweet to [@dart_lang](https://twitter.com/dart_lang).