---
title: Dart overview
description: A short introduction to Dart
---

<img style="padding: 30px; float: right; width: 300px" src="{% asset
logo_lockup_dart_horizontal.png @path %}" alt="Dart product logo">

Dart is a client-optimized language for fast apps on any platform. Our goal is
to offer the most productive programming language for multi-platform
development, paired with a [flexible execution runtime
platform](https://dart.dev/platforms) for app frameworks across Google.

Languages are defined by their "technical envelope": the many choices that are
made during development that shape their capabilities and strengths. Dart is
designed for a technical envelope that is particularly suited to client
development, prioritizing both development (sub-second stateful hot reload) and
high-quality production experiences across a wide variety of compilation targets
(web, mobile, desktop).

Dart also forms the foundation of [Flutter](https://flutter.dev): it provides
the language and runtimes that power Flutter apps, but also supports many core
developer tasks like formatting, analyzing, and testing code.

## Dart: The Language

The Dart language is type safe: it uses static type checking to ensure that a
variable’s value always matches the variable’s static type, sometimes referred
to as sound typing. Although types are mandatory, type annotations are optional
because of type inference. The Dart typing system is also flexible, allowing the
use of a 'dynamic' type combined with runtime checks, which can be useful during
experimentation or for code that needs to be especially dynamic.

Dart offers sound null safety, meaning that values can’t be null unless you say
they can be. With sound null safety, Dart can protect you from null exceptions
at runtime through static code analysis. Unlike many other null-safe languages,
when Dart determines that a variable is non-nullable, that variable is always
non-nullable: if you inspect your running code in the debugger, you’ll see that
non-nullability is retained at runtime (hence "sound" null safety).

This code sample showcases a number of Dart language features: libraries, async
calls, nullable and non-nullable types, arrow syntax, generators, streams and
getters. A more comprehensive set of annotated language examples can be found in
[Dart by Example](http://jpryan.me/dartbyexample/) by
[@jryanio](https://twitter.com/jryanio).

```dart
import 'dart:async';
import 'dart:math' show Random;

main() async {
  print('Compute π using the Monte Carlo method.');
  await for (final estimate in computePi().take(100)) {
    print('π ≅ $estimate');
  }
}
/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch: 100000}) async* {
  var total = 0;
  var count = 0;
  while (true) {
    final points = generateRandom().take(batch);
    final inside = points.where((p) => p.isInsideUnitCircle);

    total += batch;
    count += inside.length;
    final ratio = count / total;

    // Area of a circle is A = π⋅r², therefore π = A/r².
    // So, when given random points with x ∈ <0,1>,
    // y ∈ <0,1>, the ratio of those inside a unit circle
    // should approach π / 4. Therefore, the value of π
    // should be:
    yield ratio * 4;
  }
}
Iterable<Point> generateRandom([int? seed]) sync* {
  final random = Random(seed);
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble());
  }
}
class Point {
  final double x, y;
  const Point(this.x, this.y);
  bool get isInsideUnitCircle => x * x + y * y <= 1;
}
```

[This sample can be run
live](https://nullsafety.dartpad.dev/b2e3a914bd39d0408d0580c42ef2e58b) using
[DartPad](https://dartpad.dev), our online execution environment for Dart. For
more on the language, take the [Dart language
tour](https://dart.dev/guides/language/language-tour).

## Dart: The Libraries

Dart has [a rich set of core libraries](https://dart.dev/guides/libraries) that
provide essentials for many everyday programming tasks. This includes:

- Built-in types, collections, and other core functionality for every Dart
  program (`dart:core`)
- Richer collections types such as queues, linked lists, hashmaps and binary
  trees (`dart:collection`)
- Encoders and decoders for converting between different data representations,
  including JSON and UTF-8 (`dart:convert`)
- Mathematical constants and functions, and random number generation
  (`dart:math`)
- File, socket, HTTP, and other I/O support for non-web applications (`dart:io`)
- Support for asynchronous programming, with classes such as Future and Stream
  (`dart:async`)
- Lists that efficiently handle fixed sized data (for example, unsigned 8 byte
  integers) and SIMD numeric types (`dart:typed_data`)
- Foreign function interfaces for interop with other code that presents a
  C-style interface (`dart:ffi`)
- Concurrent programming using isolates: independent workers that are similar to
  threads but don't share memory, communicating only via messages
  (`dart:isolate`)
- HTML elements and other resources for web-based applications that need to
  interact with the browser and the DOM (Document Object Model) (`dart:html`)

Our [library tour](https://dart.dev/guides/libraries/library-tour) demonstrates
some of the classes provided in Dart through a series of worked examples.

Beyond the core libraries, many APIs are provided through a comprehensive set of
packages. Dart itself offers many useful supplementary packages including
[characters](https://pub.dev/packages/characters),
[intl](https://pub.dev/packages/intl), [http](https://pub.dev/packages/http),
[crypto](https://pub.dev/packages/crypto) and
[markdown](https://pub.dev/packages/markdown). In addition, there are many
thousands of packages from third-party publishers and the broader community,
including packages for [XML](https://pub.dev/packages/xml), [Windows
integration](https://pub.dev/packages/win32),
[SQLite](https://pub.dev/packages/sqflite_common) and [compression]
(https://pub.dev/packages/archive).

## Dart: The Platform

Dart's compiler technology lets you run code in different ways:

- Native: For apps targeting mobile and desktop devices, Dart includes both a
  Dart VM with JIT (just-in-time) compilation and an AOT (ahead-of-time)
  compiler for producing machine code.

- Web: For apps targeting the web, Dart also includes both a development time
  compiler (dartdevc) and a production time compiler (dart2js), both of which
  translate Dart into JavaScript that is supported on all browsers.

<img src="{% asset Dart-platforms.svg @path %}" width="800px" alt="An
illustration of the targets supported by Dart">

## Learning Dart

We have lots of ways for you to learn Dart. You can:

- [Explore Dart in the browser](https://dartpad.dev/) through DartPad, our
  web-based execution environment for Dart code.
- [Take a tour of the Dart
  language](https://dart.dev/guides/language/language-tour) that shows how to
  use each major Dart feature.
- [Complete a Dart tutorials](https://dart.dev/tutorials/server/cmdline) that
  covers the basics of building for the command line with Dart.
- Work through extensive [online
  training on Dart](https://www.udemy.com/course/complete-dart-guide/?couponCode=NOV-20)
  from experts.
- Explore the [Dart API documentation](https://api.dart.dev/) that describes the
  Dart core libraries.
- [Read a book on Dart programming](https://dart.dev/resources/books).