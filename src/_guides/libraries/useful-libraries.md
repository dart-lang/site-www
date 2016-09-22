---
layout: default
title: "Useful Dart Libraries You Should Know About"
description: "What are some of the most useful and popular Dart libraries and where can you learn more."
---

The Dart SDK contains a number of core libraries, such as dart:collection,
dart:async, and dart:convert. These libraries contain classes most
commonly used by developers.  Classes that are still useful,
but not as universally used, are placed in packages outside of the SDK.
Separating out the less commonly used classes ensures that the SDK
isn't bloated by features that you don't need.

For example, the
[dart:collection](https://api.dartlang.org/stable/dart-collection/dart-collection-library.html)
library contains the Queue, HashMap, and HashSet classes. The
[collection package](https://www.dartdocs.org/documentation/collection/latest/collection/collection-library.html)
contains more specialized classes, such as CanonicalizedMap, MapKeySet, PriorityQueue,
and support for equality testing.

The Dart SDK libraries are documented at [api.dartlang.org](https://api.dartlang.org/stable/).
Packages outside of the SDK are published to [pub.dartlang.org](https://pub.dartlang.org/)
and documented at [dartdocs.org](https://www.dartdocs.org/).
If you don't find the functionality you need on api.dartlang.org, check dartdocs.org.

Some of the libraries in the SDK have corresponding packages.
The following table includes some that you should know about:

| **SDK Library** | **Package** |
| [dart:async](https://api.dartlang.org/stable/dart-async/dart-async-library.html)<br>Support for asynchronous programming with classes such as Future and Stream. | [async](https://www.dartdocs.org/documentation/async/latest/)<br>Utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html). |
| [dart:collection](https://api.dartlang.org/stable/dart-collection/dart-collection-library.html)<br>Classes and utilities that supplement the collection support in dart:core. | [collection](https://www.dartdocs.org/documentation/collection/latest)<br>Utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection](http://news.dartlang.org/2016/01/unboxing-packages-collection.html). |
| [dart:convert](https://api.dartlang.org/stable/dart-convert/dart-convert-library.html)<br>Encoders and decoders for converting between different data representations, including JSON and UTF-8.| [convert](https://www.dartdocs.org/documentation/convert/latest/)<br>This package contains encoders and decoders for converting between different data representations.|
| [dart:core](https://api.dartlang.org/stable/dart-core/dart-core-library.html)<br>Built-in types, collections, and other core functionality for every Dart program. | N/A |
| dart:js<br>Deprecated. | [js](https://www.dartdocs.org/documentation/js/latest)<br>Methods and annotations to specify interoperability with JavaScript APIs. |
{:.table .table-striped .nowrap}

Other popular and useful packages that we recommend, in alphabetical order:

[firebase3](https://pub.dartlang.org/packages/firebase3)
: A Dart wrapper library for the Firebase.

[intl](https://pub.dartlang.org/packages/intl)
: Support for internationalization and localization facilities.

[logging](https://pub.dartlang.org/packages/logging)
: A configuratable mechanism for logging messages.

[mockito](https://pub.dartlang.org/packages/mockito)
: A Dart version of the Mockito framework.

[path](https://pub.dartlang.org/packages/path)
: A comprehensive, cross-platform path manipulation library.
  See [Unboxing Packages: path](http://news.dartlang.org/2016/06/unboxing-packages-path.html)
  for more information.

[quiver](https://pub.dartlang.org/packages/quiver)
: A set of utilitiy libraries that makes it easier and more convenient to use many Dart
  libraries.

[shelf](https://pub.dartlang.org/packages/shelf)
: Web server middleware for Dart.

[stagehand](https://pub.dartlang.org/packages/stagehand)
: A Dart project generator.

[test](https://pub.dartlang.org/packages/test)
: A standard way of writing and running tests in Dart.

Natalie Weizenbaum, one of the Dart engineers, has written a series of posts called
"Unboxing Packages" with in-depth detail on how to use some of the Dart packages:

* [Unboxing Packages: async, part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html)
* [Unboxing Packages: async, part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html)
* [Unboxing Packages: async, part 3](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html)
* [Unboxing Packages: collection](http://news.dartlang.org/2016/01/unboxing-packages-collection.html)
* [Unboxing Packages: json_rpc_2](http://news.dartlang.org/2016/05/unboxing-packages-jsonrpc2.html)
* [Unboxing Packages: source_span](http://news.dartlang.org/2016/02/one-of-best-aspects-of-package.html)
* [Unboxing Packages: stack_trace](http://news.dartlang.org/2016/01/unboxing-packages-stacktrace.html)
* [Unboxing Packages: stream_channel](http://news.dartlang.org/2016/04/unboxing-packages-streamchannel.html)
* [Unboxing Packages: string_scanner](http://news.dartlang.org/2016/02/unboxing-packages-stringscanner.html)
* [Unboxing Packages: vm_service_client](http://news.dartlang.org/2016/05/unboxing-packages-vmserviceclient.html)

