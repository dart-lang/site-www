---
title: Dart overview
description: A short introduction to Dart
---

<img style="padding: 30px; float: right; width: 300px" src="{% asset
logo_lockup_dart_horizontal.png @path %}" alt="Dart product logo">

Dart is a client-optimized language for developing fast apps on any platform.
Its goal is to offer the most productive programming language for
multi-platform development, paired with a
[flexible execution runtime platform](/platforms) for app frameworks.

Languages are defined by their _technical envelope_,
the many choices that are made during development that
shape the capabilities and strengths of a language.
Dart is designed for a technical envelope that is
particularly suited to client development,
prioritizing both development (sub-second stateful hot reload) and
high-quality production experiences across
a wide variety of compilation targets (web, mobile, and desktop).

Dart also forms the foundation of [Flutter](https://flutter.dev).
Dart provides the language and runtimes that power Flutter apps,
but Dart also supports many core developer tasks like
formatting, analyzing, and testing code.


## Dart: The language

The Dart language is type safe;
it uses static type checking to ensure that
a variable’s value _always_ matches the variable’s static type.
Sometimes, this is referred to as sound typing.
Although types are mandatory,
type annotations are optional because of type inference.
The Dart typing system is also flexible,
allowing the use of a 'dynamic' type combined with runtime checks,
which can be useful during experimentation or
for code that needs to be especially dynamic.

Dart offers [sound null safety](/null-safety),
meaning that values can’t be null unless you say they can be.
With sound null safety, Dart can protect you from
null exceptions at runtime through static code analysis.
Unlike many other null-safe languages,
when Dart determines that a variable is non-nullable,
that variable is always non-nullable.
If you inspect your running code in the debugger,
you’ll see that non-nullability is retained at runtime
(hence _sound_ null safety).

This code sample showcases a number of Dart language features:
libraries, async calls, nullable and non-nullable types,
arrow syntax, generators, streams, and getters.
A more comprehensive set of annotated language examples can be found in
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
  var total = 0; // inferred to be of type int
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
interactively](https://dartpad.dev/b2e3a914bd39d0408d0580c42ef2e58b?null_safety=true)
using [DartPad](https://dartpad.dev), an online execution environment for Dart.
To learn more about the language, take the [Dart language
tour](/guides/language/language-tour).


## Dart: The libraries

Dart has [a rich set of core libraries](/guides/libraries) that
provides essentials for many everyday programming tasks. This includes:

* Built-in types, collections, and other core functionality for
  every Dart program
  (`dart:core`)
* Richer collection types such as queues, linked lists, hashmaps, and
  binary trees
  (`dart:collection`)
* Encoders and decoders for converting between different data representations,
  including JSON and UTF-8
  (`dart:convert`)
* Mathematical constants and functions, and random number generation
  (`dart:math`)
* File, socket, HTTP, and other I/O support for non-web applications (`dart:io`)
* Support for asynchronous programming, with classes such as `Future` and `Stream`
  (`dart:async`)
* Lists that efficiently handle fixed-sized data
  (for example, unsigned 8-byte integers) and SIMD numeric types
  (`dart:typed_data`)
* Foreign function interfaces for interoperability with
  other code that presents a C-style interface
  (`dart:ffi`)
* Concurrent programming using isolates:
  independent workers that are similar to threads but
  don't share memory, communicating only through messages
  (`dart:isolate`)
* HTML elements and other resources for web-based applications that need to
  interact with the browser and the Document Object Model (DOM)
  (`dart:html`)

The [library tour](/guides/libraries/library-tour) demonstrates
some of the classes provided in Dart through a series of working examples.

Beyond the core libraries, many APIs are provided through
a comprehensive set of packages.
Dart also offers many useful supplementary packages, including the following:
* [characters](https://pub.dev/packages/characters)
* [intl](https://pub.dev/packages/intl) 
* [http](https://pub.dev/packages/http)
* [crypto](https://pub.dev/packages/crypto)
* [markdown](https://pub.dev/packages/markdown)

In addition, there are thousands of packages from
third-party publishers and the broader community,
including packages for the following:
* [XML](https://pub.dev/packages/xml) 
* [Windows integration](https://pub.dev/packages/win32)
* [SQLite](https://pub.dev/packages/sqflite_common)
* [compression](https://pub.dev/packages/archive)


## Dart: The platform

Dart's compiler technology lets you run code in different ways:

* **Native compilation**: For apps targeting mobile and desktop devices,
  Dart includes both a Dart VM with just-in-time (JIT) compilation and
  an ahead-of-time (AOT) compiler for producing machine code.

* **Web compilation**: For apps targeting the web,
  Dart includes both a development time compiler (dartdevc) and
  a production time compiler (dart2js).
  Both compilers translate Dart into JavaScript,
  which is supported on all browsers.

<img src="{% asset Dart-platforms.svg @path %}" width="800px" alt="An
illustration of the targets supported by Dart">

In addition, [Flutter](https://flutter.dev) provides tooling and UI libraries to
build UIs that run on iOS, Android, macOS, Windows, and Linux.


## Learning Dart

You have many choices for learning Dart. Here are a few that we recommend:

* [Explore Dart in the browser](https://dartpad.dev/) through DartPad,
  a web-based execution environment for Dart code.
* [Take a tour of the Dart language](/guides/language/language-tour),
  which shows you how to use each major Dart feature.
* [Complete a Dart tutorial](/tutorials/server/cmdline) that 
  covers the basics of using Dart to build for the command line.
* [Work through extensive online training][udemy]
  from Dart experts.
* [Explore the API documentation](https://api.dart.dev/) that
  describes the Dart core libraries.
* [Read a book about Dart programming](/resources/books).

[udemy]: https://www.udemy.com/course/complete-dart-guide/?couponCode=NOV-20
