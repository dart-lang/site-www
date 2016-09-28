---
layout: default
title: "Commonly Used Dart Libraries"
description: "What are some of the most useful and popular Dart libraries and where can you learn more?"
---

You can use a wide array of available Dart libraries when writing your code.
Dart libraries are distributed in one of three ways:

* The core libraries, such as dart:core, dart:async, and dart:collection,
  are distributed with the SDK and documented at [api.dartlang.org]({{site.dart_api}}).
* Libraries shared with the Dart community are distributed as library packages,
  published at [pub.dartlang.org](https://pub.dartlang.org/).
  The [pub](/tools/pub/) tool allows you to create, publish, and manage library packages.
* Libraries that are not shared with the community are simply placed in the
  `/lib` directory of your [application's directory
  structure](https://www.dartlang.org/tools/pub/package-layout#public-directories).

This document talks about the first two kinds of libraries,
and tells you where to learn more about some of the most widely used Dart libraries.

<aside class="alert alert-info" markdown="1">
If you don't find the functionality you need on [api.dartlang.org]({{site.dart_api}}),
check [pub.dartlang.org](https://pub.dartlang.org/).
</aside>

## Dart SDK libraries

Dart's core libraries contain classes most commonly used by developers.
Classes that are still useful, but not as universally used,
are placed in packages outside of the SDK.
Separating out the less commonly used classes ensures that your app
isn't bloated by features that you don't need.

The following table includes the most commonly used libraries in the Dart SDK:

| **SDK Library** | **Description** | **Example classes and members** |
| [dart:async](https://api.dartlang.org/stable/dart-async/dart-async-library.html) | Support for asynchronous programming. | Future, Stream |
| [dart:collection](https://api.dartlang.org/stable/dart-collection/dart-collection-library.html) | Classes and utilities that supplement the collection support in dart:core. | Queue, HashMap, HashSet |
| [dart:convert](https://api.dartlang.org/stable/dart-convert/dart-convert-library.html) | Encoders and decoders for converting between different data representations, including JSON and UTF-8.| Converter, Base64Decoder, LineSplitter, UTF8Decoder |
| [dart:math](https://api.dartlang.org/stable/dart-math/dart-math-library.html) | Mathematical constants and functions, plus a random number generator. | Random, max(), min() |
{:.table .table-striped .nowrap}

Looking for web, server, or Flutter libraries?
See [Specialized libraries](#specialized-libraries).

## Corresponding Dart packages

These "expansion pack" libraries have the same name as their counterpart in the SDK.
Each of these libraries builds upon an SDK library, adding
additional functionality and filling in missing features:

| **Package** | **Description** | **Example classes and members** |
| [async](https://www.dartdocs.org/documentation/async/latest/) | Utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3.](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection](https://www.dartdocs.org/documentation/collection/latest) | Utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection.](http://news.dartlang.org/2016/01/unboxing-packages-collection.html) | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
|[convert](https://www.dartdocs.org/documentation/convert/latest/) | Contains encoders and decoders for converting between different data representations. Note that one of the data representations is commonly known as URL-encoded (named `percent` here). | HexDecoder, PercentDecoder |
{:.table .table-striped .nowrap}

Looking for web, server, or Flutter libraries?
See [Specialized libraries](#specialized-libraries).

## Other useful packages

Developers have written some excellent packages for use by the
Dart community.  Here are some popular and useful packages,
in alphabetical order:

| **Package** | **Description** | **Example classes and members** |
| [firebase3](https://pub.dartlang.org/packages/firebase3) | [Firebase](https://firebase.google.com) is a popular cloud services provider.  This Dart wrapper for Firebase allows you to easily publish your app to the cloud. | Auth, Database, Query, Storage |
| [http](https://pub.dartlang.org/packages/http) | A set of high-level functions and classes that make it easy to consume HTTP resources. | delete(), get(), post(), read() |
| [intl](https://pub.dartlang.org/packages/intl) | Provides internationalization and localization facilities, and support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [logging](https://pub.dartlang.org/packages/logging) | Provides a configurable mechanism for adding message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito](https://pub.dartlang.org/packages/mockito) | Mockito is a popular framework for mocking objects in tests.  The Dart version of the Mockito library is especially useful if you are writing tests for dependency injection. Used in conjunction with the [test](https://pub.dartlang.org/packages/test) package. | Answering, Expectation, Verification |
| [path](https://pub.dartlang.org/packages/path) | Provides common operations for manipulating different types of paths. See [Unboxing Packages: path](http://news.dartlang.org/2016/06/unboxing-packages-path.html) for more information. | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver](https://pub.dartlang.org/packages/quiver) | A set of utility libraries that makes it easier and more convenient to use many Dart libraries. Some of the libraries where Quiver provides additional support include async, cache, collection, core, iterables, patterns, and testing. | CountdownTimer, (quiver.async), MapCache (quiver.cache), MultiMap, TreeSet (quiver.collection), EnumerateIterable (quiver.iterables), center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings)  |
| [shelf](https://pub.dartlang.org/packages/shelf) | Web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace]() | Provides the ability to parse, inspect, and manipulate stack traces produced by the underlying Dart implementation. Also provides functions to produce string representations of stack traces in a more readable format than the native StackTrace implementation. See [Unboxing Packages: stack_trace](http://news.dartlang.org/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [stagehand](https://pub.dartlang.org/packages/stagehand) | A Dart project generator. WebStorm and IntelliJ use these templates when you create a new application, but you can also use the templates from the command line via [pub global activate](https://www.dartlang.org/tools/pub/cmd/pub-global). | Templates include console-full, console-simple, server-shelf, web-angular, and web-simple. |
| [test](https://pub.dartlang.org/packages/test) | A standard way of writing and running tests in Dart. | expect(), group(), test() |
{:.table .table-striped .nowrap}

Search for other available packages on [pub.dartlang.org](https://pub.dartlang.org/).

## Specialized libraries

This page doesn't include some of the more specialized libraries that are covered
elsewhere. Learn more about the following topics using the provided links:

### Web libraries

If you write web apps, you should know about Angular 2, a web application framework.
You might try a [code lab for Angular Dart](https://webdev.dartlang.org/codelabs/ng2),
or refer to the [Angular Dart docs](https://angular.io/docs/dart/latest/).
Other available resources are the
[js](https://www.dartdocs.org/documentation/js/latest) package
for interoperability with JavaScript APIs, and the
[dart:html](https://api.dartlang.org/stable/dart-html/dart-html-library.html)
library for low-level HTML programming.
For more information about Dart on the Web, see [webdev.dartlang.org]({{site.webdev}}).

### Flutter libraries

If you write mobile applications, you'll want to use Flutter.
The core libraries distributed with the Flutter SDK are documented at
[docs.flutter.io](http://docs.flutter.io/). To import these libraries,
follow the instructions in this
[guide](https://www.dartlang.org/tools/pub/get-started#importing-libraries-from-packages).
Additional third-party libraries for Flutter can be found on GitHub.
For information about how to use a shared library,
see its README documentation on GitHub.
For more information about writing mobile applications using Dart,
see [flutter.io]({{site.flutter}}).

### Dart VM libraries

If you write servers or command-line applications, you'll
want to use [dart:io](https://api.dartlang.org/stable/dart-io/dart-io-library.html)
and related libraries. For more information, see [Dart VM](/dart-vm/).

## Resources

Use the following resources to learn more about libraries and library packages:

* To learn about importing libraries into your code, see
  [Using libraries](/guides/language/language-tour#libraries-and-visibility),
  a section in the [language tour](/guides/language/language-tour), and
  [Importing library
  files](/guides/libraries/create-library-packages#importing-library-files),
  a section in [Create Library Packages](/guides/libraries/create-library-packages).
* Natalie Weizenbaum has written a series of posts called "Unboxing Packages."
  Each post contains in-depth detail on how to use some of the Dart packages.
  This page links to some of her posts, but she covers other packages
  not mentioned here, such as stream_channel, vm_service_client, and json_rpc_2.
  For more information,
  see the [related posts](http://news.dartlang.org/search/label/Unboxing%20Packages)
  on [news.dartlang.org.](http://news.dartlang.org/)
* [Create Library Packages](/guides/libraries/create-library-packages)
  explains how to create a library package.
* The [pub](/tools/pub) documentation is useful, particularly
  [Pub Package Layout Conventions](/tools/pub/package-layout).
* [pub.dartlang.org](https://pub.dartlang.org) lists library packages available
  to the Dart community.
* [api.dartlang.org]({{site.dart_api}}) contains the generated docs for dart:* libraries.
* [docs.flutter.io](http://docs.flutter.io/) contains the generated docs for Flutter
  libraries.
* [dartdocs.org](https://www.dartdocs.org/) contains the generated docs for
  packages published on pub.dartlang.org.

