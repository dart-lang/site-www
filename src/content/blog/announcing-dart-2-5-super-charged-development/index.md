---
title: "Announcing Dart 2.5: Super-charged development"
description: "Today we’re announcing the stable release of the Dart 2.5 SDK, which includes technical previews of two major new developer features: ML…"
publishDate: 2019-09-10
author: "mit-mit"
image: images/0EzNuk5GmPG3-yjT4.png
category: announcements
tags:
  - programming
  - dart
  - flutter
  - announcements
---


Today we’re announcing the stable release of the Dart 2.5 SDK, which includes technical previews of two major new developer features: *ML Complete —* code completion powered by machine learning (ML) — and the `dart:ffi` foreign function interface for calling C code directly from Dart. Dart 2.5 also has improved support for [constant expressions](https://dart.dev/guides/language/language-tour#final-and-const).

This release is another step toward our vision of the best client-optimized language for creating fast apps for any platform. ML Complete is a powerful addition to our existing suite of productivity tools like [hot reload](https://flutter.dev/docs/development/tools/hot-reload), [customizable static analysis](https://dart.dev/guides/language/analysis-options), and [Dart DevTools](https://flutter.dev/docs/development/tools/devtools/overview). The second preview feature, `dart:ffi`, enables you to leverage existing native APIs on the many operating systems where Dart code runs, as well as existing cross-platform native libraries written in C.

Speaking of our ambition to create the best client-optimized language, it was great to see the new [IEEE Spectrum Top Programming Language](https://spectrum.ieee.org/computing/software/the-top-programming-languages-2019) 2019 ratings come out this past week with Dart now included. Dart enters the IEEE Spectrum programming language ratings as #16. It’s also #10 under trending, and #6 when filtering to languages for mobile (behind Java, C, C++, C#, and Swift).

<DashImage src="images/0EzNuk5GmPG3-yjT4.png" />


## Preview: ML Complete, code completions ranked by machine learning

One of the core advantages of typed programming languages is that additional information captured in the types enables the IDE/editor to aid developers by offering completions as they type their code. With code completions, developers can both avoid misspellings and explore APIs by typing the beginning of expected symbols and choosing from the offered completions.

As APIs grow, exploration becomes difficult, as the list of possible completions gets too long to browse through alphabetically. We’ve been working hard over the past year to apply machine learning to the problem. Simplified, this works by training a model of likely member occurrences based on a given context by analyzing a [large corpus of GitHub](https://console.cloud.google.com/marketplace/details/github/github-repos) open-source Dart code. This model — powered by [TensorFlow Lite](https://www.tensorflow.org/lite) — can then be used to predict the likely next symbol as the developer is editing. We’re calling this new feature *ML Complete*. Here’s an example of developing a new `MyHome` widget using the [Flutter](https://flutter.dev) framework:

<DashImage src="images/0a3q1D4T6uoftk8SJ.gif" alt="Sample developer experience creating a Flutter widget using ML Complete" caption="Sample developer experience creating a Flutter widget using ML Complete" />


Let’s take a deeper look at how this works. Imagine that you’re writing a small program to calculate the time that’s one day from the current time. Using ML Complete you get the experience on the left, below. First, notice how it’s able to offer a completion to `DateTime.now()` based on the variable having the name now. Next, notice how we get a completion on the variable name tomorrow, and finally `add(…)` is the second offered completion on now. In the non-ML Complete experience on the right, we have to manually start typing `DateTime`, we get no completions on the `tomorrow` variable name, and the `add(…)` method is much further down the list.

<DashImage src="images/1rA4mVfedEzJCN_ayVymm1A.gif" />


<DashImage src="images/1cmHliNwHDwjNV-fdMScWMA.gif" alt="Code completion experience with ML Complete (left) and without (right)" caption="Code completion experience with ML Complete (left) and without (right)" />


## How to try out ML Complete

ML Complete is launching in preview today. It’s built directly into the Dart analyzer, so it’s available across all Dart-enabled editors, including Android Studio, IntelliJ, and VS Code. See [this wiki page](https://github.com/dart-lang/sdk/wiki/Previewing-Dart-code-completions-powered-by-machine-learning) for details on how to opt in to this preview feature, and for details on how to provide feedback and report issues.

Because the feature is still in preview, the version in the current Flutter and Dart stable releases does not include the performance and polish work that we expect to have in later builds. We therefore recommend that you temporarily use the Flutter [dev channel](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) or a Dart [dev channel](https://dart.dev/tools/sdk/archive#dev-channel) when previewing this feature.

## Preview: `dart:ffi` foreign function interface for Dart-C interop

Many developers have asked us for better support for calling C code from Dart. One very clear signal is the Flutter issue tracker, where C interop is the single [highest rated open feature request](https://github.com/flutter/flutter/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) with more than 600 👍 votes. Many interesting use cases are behind these requests, ranging from calling low-level platform APIs like [stdlib.h](https://pubs.opengroup.org/onlinepubs/009695399/basedefs/stdlib.h.html) or [Win32](https://en.wikipedia.org/wiki/Windows_API) to leveraging existing cross-platform libraries and utilities written in C like TensorFlow, Realm, and SQLite.

Currently, support for calling C directly from Dart is limited to deep integration into the Dart VM using [native extensions](https://dart.dev/server/c-interop-native-extensions). Alternatively Flutter apps can use C indirectly by calling the host using [platform channels](https://flutter.dev/docs/development/platform-integration/platform-channels) and calling onwards to C from there; this is an undesirable double indirection. We aspire to offer a new mechanism that offers great performance, is easy to approach, and works across the many supported Dart [platforms and compilers](https://dart.dev/platforms).

Dart-C interop enables two main scenarios:

* Calling into a C-based system API on the host operating system (OS)

* Calling into a C-based library, either for a single OS or cross-platform

## Calling C-based operating system APIs

Let’s take a concrete look at the first category. We’ll call the Linux command [`system`](https://man.openbsd.org/system.3). This command enables executing any system command; the argument you pass to it is essentially passed to the shell/terminal and run there. Here’s the C header for this command:

```dart
// C header: int system(const char *command) in stdlib.h
```

The core challenge of any interop mechanism is dealing with the differences in semantics across two languages. For `dart:ffi`, the Dart code needs to represent two things:

1. The C function and the types of its arguments and return type

1. The corresponding Dart function, and its types

We do that by defining two typedefs:

```dart
// C header typedef:
typedef SystemC = ffi.Int32 Function(ffi.Pointer<Utf8> command);

// Dart header typedef:
typedef SystemDart = int Function(ffi.Pointer<Utf8> command);
```

Next we need to load the library and look up the function we’re going to call. How to do this depends on the operating system; in this example we’re using macOS. (We have [complete examples](https://github.com/dart-lang/samples/tree/master/ffi/system-command) for macOS, Windows, and Linux.)

```dart
// Load `stdlib`. On MacOS this is in libSystem.dylib.
final dylib = ffi.DynamicLibrary.open('/usr/lib/libSystem.dylib');

// Look up the system function.
final systemP = dylib.lookupFunction<SystemC, SystemDart>('system');
```

Next, we encode the string argument using the encoding relevant for the particular operating system, invoke the function, and free the argument memory again:

```dart
// Allocate a pointer to a Utf8 array containing our command.
final cmdP = Utf8.toUtf8('open http://dart.dev');

// Invoke the command.
systemP(cmdP);

// Free the pointer.
cmdP.free();
```

This code executes the system command, causing the system-default browser to open dart.dev:

<DashImage src="images/0-S9fZutz89QcrwEw.gif" alt="*Executing the system command via dart:ffi to open the default browser*" caption="*Executing the system command via dart:ffi to open the default browser*" />


## Calling C-based frameworks and components

A second core use of `dart:ffi` is to invoke C-based frameworks and components. The ML-based code completion discussed in the beginning of this post is a concrete example of this! It uses [TensorFlow Lite](https://www.tensorflow.org/lite), which is a [C-based API](https://www.tensorflow.org/lite/api_docs/cc). Using `dart:ffi` allows us to run TensorFlow across all the operating systems where we need to offer code completions, with the high performance of the native TensorFlow implementation. If you want to take a peek at the code for the Dart TensorFlow integration, look at [this repo](https://github.com/dart-lang/tflite_native).

We also expect that the ability to call C-based libraries will be of great use to Flutter apps. You can imagine calling native libraries such as [Realm](https://github.com/realm/realm-core) or [SQLite](https://www.sqlite.org/c3ref/intro.html), and we think `dart:ffi` will be valuable for enabling plugins for [Flutter desktop](https://github.com/flutter/flutter/wiki/Desktop-shells).

## Wrapping APIs and code generation

As you may have noticed, there’s a bit of programming overhead in describing the functions and looking up their symbols. A lot of this boilerplate code could be generated from the C header files. We’re currently focused on providing the underlying primitives, but would love to collaborate with anyone who’s interested in working on a generator.

## How to try dart:ffi

The `dart:ffi` library is launching in preview today. Because it’s still in preview, we recommend that you use the Flutter [master channel](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) or a Dart [dev channel](https://dart.dev/tools/sdk/archive#dev-channel) to get quick access to our changes and improvements as they’re made. Note that the API is likely to have breaking changes between now and its completion, as we add polish and broaden support for common patterns. You can get a detailed view into what [we currently have planned](https://github.com/dart-lang/sdk/projects/13) for our first release. Here are a few limitations you should know about:

* The library doesn’t support nested structs, inline arrays, packed data, or platform-dependent primitive types.

* Performance of pointer operations is lacking (but can be worked around using [Pointer.asExternalTypedData](https://github.com/dart-lang/sdk/blob/master/sdk/lib/ffi/ffi.dart#L132)).

* The library has no support for finalizers (callbacks invoked when an object is about to be garbage collected).

The [C interop documentation](https://dart.dev/guides/libraries/c-interop) and [`dart:ffi` API reference](https://api.dart.dev/dev/) document the core concepts and point to examples that you can review. If you experience any issues or have questions, we invite you to post on the [Dart FFI discussion group](https://groups.google.com/forum/#!forum/dart-ffi), or [file an issue](https://github.com/dart-lang/sdk/issues/new?labels=area-vm,library-ffi).

## Improved constant expressions

Dart has long supported creating [const variables and values](https://dart.dev/guides/language/language-tour#final-and-const); these are guaranteed to be compile-time constant, and thus have very good performance characteristics. In previous releases, constant expressions were a bit limited. As of Dart 2.5, we support many more ways to define constant expressions, including the ability to use casts and the new control flow and collection spread features shipped in [Dart 2.3](https://medium.com/dartlang/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff):

```dart
// Example: these are now valid compile-time constants.
const Object i = 3;
const list = [i as int];
const set = {if (list is List<int>) ...list};
const map = {if (i is int) i: "int"};
```

## Closing thoughts

We’ve got an exciting next few quarters lined up ahead of us, with work well underway for [extension methods](https://github.com/dart-lang/language/issues/41), enforcing that references are [non-nullable](https://medium.com/dartlang/dart-nullability-syntax-decision-a-b-or-a-b-d827259e34a3), and some early planning for [the language beyond that](https://github.com/dart-lang/language/projects/1). We’re also investigating improved concurrency support — for example the ability to better use multi-core processors on modern mobile phones.

We’re especially enthusiastic about non-nullable by default. We’ve lined up a [pretty ambitious plan](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md) for this feature, and have [a lot of work](https://github.com/dart-lang/language/issues?utf8=%E2%9C%93&q=is%3Aissue++label%3Annbd+) underway. A few more recent languages were designed with support for non-nullable from the beginning, while most existing languages that added non-nullable support in a later version settled for a fairly limited approach limited to additional static analysis. One main differentiator of our approach is that we’re aiming for full [sound non-nullable](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md#soundness) support. Briefly explained, this means that our understanding of non-nullability will extend to the core of the type system, and once our type system knows that something is non-nullable, we can fully trust that information, and our backend compiler is free to optimize the code. This soundness has large advantages, both in terms of offering a consistent “no-exceptions experience” and in terms of code size and runtime performance.

We’re always aware of the burden it places on our ecosystem whenever we change the language. Thus, we’re also [investing a lot](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md#migration-path) in providing rich migration tooling for existing code. We hope this tooling will offset the majority of the migration cost. We’re also adding a few dedicated language and tool features enabling stepwise migration, and will make an effort to get both our own code and shared code on [https://pub.dev](https://pub.dev) migrated.

We look forward to sharing more news later this year!