---
title: "Announcing Dart 2.2: Faster native code, support for set literals"
description: "Today, we’re announcing the stable release of the Dart 2.2 SDK, an incremental update to Dart 2 that offers improved performance of…"
publishDate: 2019-02-26
author: "mit-mit"
image: images/1saXdrIB-SjU2EL7gLGPUsA.png
category: announcements
tags:
  - programming
  - dart
  - flutter
  - announcements
---


Today, we’re announcing the stable release of the Dart 2.2 SDK, an incremental update to Dart 2 that offers improved performance of [ahead-of-time (AOT) compiled](https://en.wikipedia.org/wiki/Ahead-of-time_compilation) native code and a new set literal language feature.

<DashImage src="images/1saXdrIB-SjU2EL7gLGPUsA.png" />


## Dart performance improvements for Flutter developers

We continue our work to make [AOT-compiled code](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf), such as Flutter apps, even faster. In Dart 2.1, [we reduced overhead of type checks](https://medium.com/dartlang/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a), greatly reducing the cost of the type checks for both AOT-compiled code and for code run in the VM with JIT (just-in-time) compilation.

In Dart 2.2, we have focused specifically on performance of AOT-compiled code, improving AOT performance by [11–16% on microbenchmarks](https://github.com/flutter/flutter/pull/27789#issuecomment-464234710) (at the cost of a ~1% increase in code size). This improvement is the result of several quarters’ work to reduce the overhead of static calls. Our optimized AOT code is now able to call the destination directly using a PC-relative call (that is, using the [program counter](https://en.wikipedia.org/wiki/Program_counter)); before we had to make several lookups to an object pool to determine the destination address. These optimizations are especially useful when code contains lots of constructor and static method calls, such as Flutter user interface code that creates lots of widgets.

## Dart 2.2 set literal language feature

Dart’s core library (`dart:core`) contains a number of collection classes for modelling [Maps](https://api.dartlang.org/stable/dart-core/Map-class.html), [Lists](https://api.dartlang.org/stable/dart-core/List-class.html), and [Sets](https://api.dartlang.org/stable/dart-core/Set-class.html) of objects. Maps are collections of key-value pairs. Lists are ordered sequences of values, where each value may be accessed by an index, and may occur more than once. Sets are unordered collections of values, where each value can occur only once, and where you can efficiently check whether a value is in the set.

Dart collections are commonly initialized with compile-time constants, so Dart has a convenient literal syntax for expressing this initialization. In Dart, a List can be initialized with:

```dart
const List<String> releases = ['Dart 2.0', 'Dart 2.1', 'Dart 2.2'];
```

Previously, Dart supported the literal syntax only for Lists and Maps, so initialization of Sets was cumbersome as we had to initialize via a list:

```dart
Set<String> currencies = Set.of(['EUR', 'USD', 'JPY']);
```

This code is not just inconvenient and inefficient; the lack of literal support prevents making currencies a compile-time constant. With Dart 2.2’s extension of literals to support sets, we can initialize a set and make it const using a convenient new syntax:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```

For real-world examples of how the Flutter team is starting to apply set literals, see [PR #27811](https://github.com/flutter/flutter/pull/27811). For more general details on how to use set literals, see the [updated Dart 2.2 language tour](https://www.dartlang.org/guides/language/language-tour#sets).

## Building new language features with the Dart 2 Common Front-End (CFE)

The Dart language implementations — the Dart VM used by Flutter, the dart2js compiler, and the Dart dev compiler (dartdevc) — share a common front end. The Dart Common Front End, or CFE, parses Dart code, performs type inference, and translates Dart into a lower-level intermediate language that back-end implementations accept as input.

The set literals feature is an example of a language construct that we were able to develop rapidly because of the CFE. The code for parsing set literals and performing type inference was implemented once in the CFE for all Dart back ends. In addition, we built a front-end-only transitional implementation that could be used by the back ends initially. In the transitional implementation, the non-const version of the currencies set literal above was translated during compilation into the equivalent of:

```dart
Set<String> currencies = Set<String>()..add('EUR')..add('USD')..add('JPY');
```

The transitional implementation of const set literals is different because const sets cannot be built up incrementally in pieces. Instead, we implemented this in terms of a private unmodifiable set class that wraps a const map, where the set elements are the keys of the map:

```dart
const Set<String> currencies =
   _UnmodifiableSet<String>({'EUR': null, 'USD': null, 'JPY': null});
```

The unmodifiable set class implements the methods in the Set interface in terms of the wrapped map.

Overall, we were able to implement set literals initially as a CFE-only feature. The back ends could use the CFE implementation initially, and later develop their own native support independently of the initial launch of the feature. This allowed backends to postpone their native support until the performance aspects of this feature were better understood.

## Dart 2.2 language specification

Dart 2 was such a [substantial upgrade](https://medium.com/dartlang/dart-2-stable-and-the-dart-web-platform-3775d5f8eac7) to Dart that it’s taken us a while to get the formal [Dart language specification](https://www.dartlang.org/guides/language/spec) updated to match all the changes we made. We have finally completed that work, and the spec is up-to-date as of Dart 2.2. We’ve also moved the language specification source to the new [language repository](https://github.com/dart-lang/language/tree/master/specification), and added continuous integration to ensure a rolling draft specification is generated in PDF format as we evolve the specification for future versions of the Dart language. Both the 2.2 and rolling Dart 2.x specifications are available from the [Dart specification page](https://www.dartlang.org/guides/language/spec).

## Getting Dart 2.2

[Dart SDK 2.2](https://www.dartlang.org/tools/sdk/archive) is available from the Dart homepage today. If you’re a Flutter developer, Dart 2.2 is already included. (*Note*: the current Flutter master and dev channels will report Dart 2.2. [Today’s Flutter 1.2](https://developers.googleblog.com/2019/02/launching-flutter-12-at-mobile-world.html) stable release will report Dart 2.1.2; this has the same features as Dart 2.2).

That’s it for now. We hope you enjoy Dart 2.2!