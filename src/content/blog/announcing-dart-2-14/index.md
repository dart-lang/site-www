---
title: "Announcing Dart 2.14"
description: "Apple Silicon support, and improved productivity with default lints, better tools, and new language features"
publishDate: 2021-09-08
author: mit-mit
image: images/1qlsMfajTUkBw1APUpjcCZg.png
category: announcements
tags:
  - announcements
  - dart
  - programming
layout: blog
---


Today we’re releasing version 2.14 of the Dart SDK, the next release in our ongoing journey to make the best platform for building apps through a unique combination of portability, productivity, and robustness. This time around we have better support for Apple Silicon, and a number of productivity enhancements such as standard lints for catching errors as you write your code through code style analysis, a faster pub tool, better formatting of code with cascades, and a few small language features.

<DashImage src="images/1qlsMfajTUkBw1APUpjcCZg.png" />


## Apple Silicon support in the Dart SDK

Since Apple announced their new [Apple Silicon](https://support.apple.com/en-us/HT211814) processors in late 2020, we’ve worked on updating the Dart SDK to add support for native execution on the new processors. The needed changes have been available in the dev channel for a while, in the beta channel for the past month, and as of Dart 2.14.1 are now available in the Dart stable channel. When you [download](https://dart.dev/get-dart) a macOS SDK, make sure to pick the ARM64 option. Note that the Dart SDK bundled in the Flutter SDK doesn’t have these improvements yet.

The support includes both running the SDK/Dart VM itself on Apple Silicon, and support for compiling executables (with [`dart compile`](https://dart.dev/tools/dart-compile#exe)) that run on Apple Silicon. The Dart command-line tools start much faster now that they are using native Apple Silicon support.

## Standard lints shared for Dart and Flutter

Developers often prefer their code to follow a certain style. Many of these rules aren’t just stylistic preferences (like the well-known tabs vs. spaces discussion), but cover coding styles that are likely to lead to mistakes or introduce bugs. As an example, the Dart style guide requires using curly braces for all control flow structures, such as if-else statements. This prevents the classic [dangling else](https://en.wikipedia.org/wiki/Dangling_else) problem, where there is ambiguity over how to interpret several nested if-else statements. Another example is type inference. While it’s fine to use type inference when declaring variables with initial values, it’s important to specify the type when [declaring uninitialized variables](https://dart-lang.github.io/linter/lints/prefer_typing_uninitialized_variables.html), to ensure type safety.

One option for enforcing good code style is to have some form of human enforcement, often via a code review. However it’s often much more effective to enforce rules via static analysis that runs as you write your code.

In Dart, this static analysis is highly [configurable](https://dart.dev/guides/language/analysis-options), and we have [hundreds of style rules](https://dart.dev/tools/linter-rules) (also known as *lints*). With this wealth of options, it can be a bit overwhelming to choose which rules to enable. The Dart team maintains a [Dart style guide](https://dart.dev/guides/language/effective-dart/style), which describes what we believe is the best way of writing and styling Dart code, but historically we haven’t had an official set of linter rules that correspond to the style guide.

Many developers — and the pub.dev site [scoring](https://pub.dev/help/scoring) engine — have used the [pedantic](https://github.com/google/pedantic) set of lint rules. Pedantic, however, has its origins in the Google-internal style guide for Dart, which for historical reasons differs from the general Dart style guide. Additionally, the Flutter framework never used the pedantic set of rules, and instead had its own set of canonical rules.

This might sound a bit messy, and indeed it was. But with today’s releases we’re happy to announce that we now have a brand new set of lint collections that implement the style guide, and that the Dart and Flutter SDKs have been updated to use these rule sets by default for new projects. The rule sets are:

* [`package:lints/core.yaml`:](https://github.com/dart-lang/lints/blob/main/lib/core.yaml) ****The main rules from the Dart style guide that we believe all Dart code should follow. The pub.dev scoring engine has been updated to use these instead of pedantic.

* [`package:lints/recommended.yaml`](https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml)**:** The core rules, plus additional recommended rules. This set is recommended for all general Dart code.

* [`package:flutter_lints/flutter.yaml`](https://github.com/flutter/packages/blob/master/packages/flutter_lints/lib/flutter.yaml): The core and recommended rules, plus additional Flutter-specific recommended rules. This set is recommended for all Flutter code.

If you have existing projects, we strongly recommend that you upgrade to these new sets of rules. Upgrading from pedantic takes [just a few steps](https://github.com/dart-lang/lints#migrating-from-packagepedantic).

## Dart formatter and cascades

We made several optimizations to how the Dart formatter formats code with [cascades](https://dart.dev/guides/language/language-tour#cascade-notation). Before, the formatter would in some cases produce confusing formatting. For example, what is `doIt()` called on in this example?

```
var result = errorState ? foo : bad..doIt();
```


It might look like it’s always called on `bad`, but actually the cascade applies to the entire `?` expression, so the cascade is called on the result of that expression, and not just on the false clause. The new formatter makes this clear:

```
var result = errorState ? foo : bad
  ..doIt();
```


Other changes relate to how lines with multiple cascades are formatted, and how far cascades generally are indented. We also greatly increased the speed of formatting code containing cascades; in Dart code generated for [protocol buffers](https://developers.google.com/protocol-buffers/docs/reference/dart-generated), we’re seeing up to a 10x improvement in formatting speed.

For all the details, see the [tracking issue](https://github.com/dart-lang/dart_style/pull/1033).

## Pub support for ignoring files

Currently when you [publish](https://dart.dev/tools/pub/publishing) a package to the [pub.dev](https://pub.dev) community repository, pub grabs all the files in that folder with a few exceptions, skipping hidden files (those that begin with a dot: `.`) and files listed in `.gitignore`. Several developers have requested the ability to control which files are ignored outside of the list in `.gitignore`. For example, you might have some internal development tools in a `tool/` folder that you use for *maintaining* your package, but that aren’t relevant to people who *use* your package.

The updated pub command in Dart 2.14 supports a new `.pubignore` file, where you can list the files that you don’t want to upload to pub.dev. This file uses the same format as `.gitignore` files. For details, see the [package publishing documentation](https://dart.dev/tools/pub/publishing#what-files-are-published).

## Pub and `dart test` performance

While pub is perhaps most used for managing code dependencies, it also has a second important utility: powering tools. One such example is the Dart test tool, exposed via the `dart test` command. This command is really just a wrapper around the `command pub run test:test`, which runs the `test` entrypoint in [`package:test`](https://github.com/dart-lang/test/blob/master/pkgs/test/bin/test.dart). Before invoking that entrypoint, pub first compiles it to native code that can be run faster.

Before Dart 2.14, any change to the pubspec (including ones unrelated to `package:test`) would invalidate this build of test, and you’d see a bunch of output like this containing “Precompiling executable”:

```
$ dart test
Precompiling executable... (11.6s)
Precompiled test:test.
00:01 +1: All tests passed!
```


In Dart 2.14, pub is much smarter about when to invalidate the build step, so the build happens only when the version changes. Further, we improved how we perform that build step using parallelization, so the step itself completes much faster. We’ve seen it take half the time on some packages that we’ve tested.

## New language features

Dart 2.14 also contains a number of small language features. This time we focused on more specific improvements that are perhaps of more narrow utility, but enable more specialized use cases that weren’t previously supported.

First, we added a new [triple shift](https://github.com/dart-lang/language/issues/120) operator (`&gt;&gt;&gt;`). This is similar to the existing shift operator (`&gt;&gt;`), but where `&gt;&gt;` performs an arithmetic shift, `&gt;&gt;&gt;` performs a logical, or unsigned, shift where zero-bits are shifted into the most significant bit regardless of whether the number being shifted is positive or negative.

We’ve also removed an old restriction on type arguments, which disallowed using generic function types as a type argument. All of the following were invalid before 2.14, but are now allowed:

```
late List<T Function<T>(T)> idFunctions;
var callback = [<T>(T value) => value];
late S Function<S extends T Function<T>(T)>(S) f;
```


And finally, we’ve made a small adjustment to annotation types. (Annotations such as [`@Deprecated`](https://api.dart.dev/stable/2.13.4/dart-core/Deprecated-class.html) are commonly used in Dart code to capture metadata.) Previously annotations couldn’t be passed type arguments, so code like `@TypeHelper&lt;int&gt;(42, "The meaning")` wasn’t allowed. This restriction has now been removed.

## Package and core library changes

We’ve made a number of enhancements to core Dart packages and libraries, including:

* `dart:core`: Added static methods `hash`, `hashAll`, and `hashAllUnordered` to the `Object` class. These can be used to combine the hash codes of multiple objects in a consistent way ([hashAll example](https://api.dart.dev/stable/2.14.0/dart-core/Object/hashAll.html)).

* `dart:core`: The native `DateTime` class now better handles local time around daylight saving time changes that aren’t precisely one hour — for example Lord Howe Island, Australia, which uses a 30-minute shift.

* [`package:ffi`](https://pub.dev/packages/ffi): Added support for managing memory using an [arena](https://pub.dev/documentation/ffi/latest/ffi/Arena-class.html) allocator ([example](https://github.com/dart-lang/sdk/blob/master/samples/ffi/resource_management/arena_sample.dart)). Arenas are a form of [region-based memory management](https://en.wikipedia.org/wiki/Region-based_memory_management), where resources are automatically freed once the arena/region is exited.

* [`package:ffigen`](https://pub.dev/packages/ffigen): Now supports generating Dart typedefs from C typedefs.

## Breaking changes

Dart 2.14 also contains a number of smaller, [previously announced](https://github.com/dart-lang/sdk/blob/master/docs/process/breaking-changes.md) breaking changes. These changes are expected to impact just a few specialized use cases.

### [#46545](https://github.com/dart-lang/sdk/issues/46545): Removal of support for ECMAScript5

[All modern browsers](https://caniuse.com/es6) support recent ECMAScript versions, so two years ago we [announced](https://groups.google.com/a/dartlang.org/g/announce/c/x7eDinVT6fM/m/ZSFl2a9tEAAJ?pli=1) a plan to deprecate support for ECMAScript 5 (ES5). This enables us to leverage improvements in the latest ECMAScript and generate smaller output. In Dart 2.14 this work is complete, and the Dart web compilers no longer support ES5. As a result, older browsers — such as IE11 — are no longer supported.

### [#46100](https://github.com/dart-lang/sdk/issues/46100): Deprecation of stagehand, dartfmt, and dart2native

In the October 2020 [Dart 2.10 blog post](https://medium.com/dartlang/announcing-dart-2-10-350823952bd5), we announced our work to combine all the Dart CLI developer tools into a single, combined `dart` tool (similar to the `flutter` tool). As part of that evolution, Dart 2.14 deprecated the former `dartfmt` and `dart2native` commands, and discontinued `stagehand`. These tools all have equivalent replacements in the [unified `dart` tool](https://dart.dev/tools/dart-tool).

### [#45451](https://github.com/dart-lang/sdk/issues/45451): Deprecation of VM Native Extensions

We’ve deprecated the Dart VM’s Native Extensions, our older mechanism for calling native code from Dart code. Dart [FFI](https://dart.dev/guides/libraries/c-interop) (foreign function interface) is our current mechanism for this use case, and we’re actively [evolving](https://medium.com/dartlang/announcing-dart-2-13-c6d547b57067) that to be even more powerful and easy to use.

## Null safety update

We launched sound null safety in March in the [Dart 2.12](https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87) release. Null safety is Dart’s latest major productivity feature, intended to help you avoid null errors — a class of bugs that are often hard to spot.

Since our last update, we’ve seen great progress on migrations of existing packages and apps to enable the sound checking benefits of null safety. For packages on pub.dev, 100% of the top-250 packages now support null safety, and 94% of the top-1000 support it. This means that more developers can run their apps with full [sound null safety](https://dart.dev/null-safety/unsound-null-safety#sound-and-unsound-null-safety). Analytics show that 56% of `flutter run` sessions execute with full soundness. Thanks to all developers in the ecosystem for your migration work!

## 2.14 availability and continued momentum

The enhanced Dart SDK containing the above changes is available today in the Dart 2.14.1 and [Flutter 2.5](https://medium.com/flutter/whats-new-in-flutter-2-5-6f080c3f3dc) SDKs. We hope you’ll enjoy the new enhancements and features.

Also, we want to take the opportunity to extend our thanks to the awesome Dart community. As witnessed through a number of recent updates to programming language surveys, the Dart momentum is strong. The well-respected [RedMonk ranking](https://redmonk.com/sogrady/2021/08/05/language-rankings-6-21/) mentions *“Dart’s remarkable ascent”* and places Dart in the top 20 for the first time. StackOverflow’s comprehensive [2021 Developer Survey](https://insights.stackoverflow.com/survey/2021#technology-most-loved-dreaded-and-wanted) was equally delightful to read: Dart was reported to be the 7th most Loved programming language by developers. We’re truly delighted to see the Dart platform have continued growth and momentum.