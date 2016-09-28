---
layout: default
title: "Commonly Used Dart Libraries"
description: "What are some of the most useful and popular Dart libraries and where can you learn more?"
---

You can use many Dart libraries when writing your code. You can find
Dart libraries in three ways:

* The core libraries&mdash;such as dart:core, dart:async, and dart:collection&mdash;are
  distributed with the SDK and documented at [api.dartlang.org]({{site.dart_api}}).
* Libraries shared with the Dart community are distributed as library packages,
  published at [pub.dartlang.org](https://pub.dartlang.org/).
  The [pub](/tools/pub/) tool allows you to create, publish, and manage library packages.
* You can use libraries from GitHub or your local file system by placing them in the
  `/lib` directory of your [application's directory
  structure](https://www.dartlang.org/tools/pub/package-layout#public-directories).

This document discusses the first two kinds of libraries,
and tells you where to learn more about some of the most widely used Dart libraries.

<aside class="alert alert-info" markdown="1">
**Tip:**
If you don't find the functionality you need on [api.dartlang.org]({{site.dart_api}}),
check [pub.dartlang.org](https://pub.dartlang.org/).
</aside>

Looking for web, server, or Flutter libraries?
See [Specialized libraries](#specialized-libraries).

## Dart SDK libraries

The SDK libraries (dart:core, dart:async, dart:math, dart:convert) contain the
fundamental classes used in Dart applications.
Classes that aren't as universal are placed in packages outside of the SDK.

The [library tour](/guides/libraries/library-tour) walks you through the
libraries distributed with the SDK.

## Useful packages

Developers have written some excellent packages for use by the
Dart community.  Here are some popular and useful packages,
in alphabetical order:

| **Package** | **Description** | **Commonly used APIs** |
| [firebase3](https://pub.dartlang.org/packages/firebase3) | A wrapper for [Firebase](https://firebase.google.com) that allows you to easily publish your app to the cloud. | Auth, Database, Query, Storage |
| [http](https://pub.dartlang.org/packages/http) | A set of high-level functions and classes that make it easy to consume HTTP resources. | delete(), get(), post(), read() |
| [intl](https://pub.dartlang.org/packages/intl) | Internationalization and localization facilities, and support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [logging](https://pub.dartlang.org/packages/logging) | A configurable mechanism for adding message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito](https://pub.dartlang.org/packages/mockito) | A popular framework for mocking objects in tests. Especially useful if you are writing tests for dependency injection. Used in conjunction with the [test](https://pub.dartlang.org/packages/test) package. | Answering, Expectation, Verification |
| [path](https://pub.dartlang.org/packages/path) | Common operations for manipulating different types of paths. For more information, [Unboxing Packages: path](http://news.dartlang.org/2016/06/unboxing-packages-path.html). | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver](https://pub.dartlang.org/packages/quiver) | Utilities that make using core Dart libraries more convenient. Some of the libraries where Quiver provides additional support include async, cache, collection, core, iterables, patterns, and testing. | CountdownTimer, (quiver.async), MapCache (quiver.cache), MultiMap, TreeSet (quiver.collection), EnumerateIterable (quiver.iterables), center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings)  |
| [shelf](https://pub.dartlang.org/packages/shelf) | Web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace](https://pub.dartlang.org/packages/stack_trace) | Methods for parsing, inspecting, and manipulating stack traces produced by the underlying Dart implementation. Also provides functions to produce string representations of stack traces in a more readable format than the native StackTrace implementation. For more information, [Unboxing Packages: stack_trace](http://news.dartlang.org/2016/01/unboxing-packages-stacktrace.html). | Trace.current(), Trace.format(), Trace.from() |
| [stagehand](https://pub.dartlang.org/packages/stagehand) | A Dart project generator. WebStorm and IntelliJ use Stagehand templates when you create a new application, but you can also use the templates from the command line via [pub global activate](https://www.dartlang.org/tools/pub/cmd/pub-global). | Templates include console-full, console-simple, server-shelf, web-angular, and web-simple. |
| [test](https://pub.dartlang.org/packages/test) | A standard way of writing and running tests in Dart. | expect(), group(), test() |
{:.table .table-striped .nowrap}

To find more packages, see [pub.dartlang.org](https://pub.dartlang.org/).

## Packages that correspond to SDK libraries

These "expansion pack" libraries have the same name as their counterpart in the SDK.
Each of these libraries builds upon an SDK library, adding
additional functionality and filling in missing features:

| **Package** | **Description** | **Commonly used APIs** |
| [async](https://www.dartdocs.org/documentation/async/latest/) | Utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3.](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection](https://www.dartdocs.org/documentation/collection/latest) | Utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection.](http://news.dartlang.org/2016/01/unboxing-packages-collection.html) | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
|[convert](https://www.dartdocs.org/documentation/convert/latest/) | Contains encoders and decoders for converting between different data representations. Note that one of the data representations is commonly known as URL-encoded (named `percent` here). | HexDecoder, PercentDecoder |
{:.table .table-striped .nowrap}

## Specialized libraries

This page doesn't include some of the more specialized libraries that are covered
elsewhere.

### Web libraries

If you write web apps, check out Angular 2, a web application framework.
Other available resources are the
[js](https://www.dartdocs.org/documentation/js/latest) package
for interoperability with JavaScript APIs, and the
[dart:html](https://api.dartlang.org/stable/dart-html/dart-html-library.html)
library for low-level HTML programming.<br>
More information: [webdev.dartlang.org]({{site.webdev}})

### Flutter libraries

Use Flutter to write mobile applications.
The core libraries distributed with the Flutter SDK are documented at
[docs.flutter.io](http://docs.flutter.io/). To import these libraries,
follow the instructions in [Importing libraries from
packages](https://www.dartlang.org/tools/pub/get-started#importing-libraries-from-packages).
Additional third-party libraries for Flutter can be found on GitHub.
For information about how to use a shared library,
see its README documentation on GitHub.<br>
More information: [flutter.io]({{site.flutter}})

### Dart VM libraries

If you write servers or command-line applications, check out
[dart:io](https://api.dartlang.org/stable/dart-io/dart-io-library.html)
and related libraries.<br>
More information: [Dart VM]({{site.dart_vm}})

## Resources

Use the following resources to learn more about libraries and library packages.

### Importing and using libraries

* [Using libraries](/guides/language/language-tour#libraries-and-visibility),
  a section in the [language tour](/guides/language/language-tour)
* [Importing library
  files](/guides/libraries/create-library-packages#importing-library-files),
  a section in [Create Library Packages](/guides/libraries/create-library-packages)
* [Pub docs](/tools/pub), particularly
  [Pub Package Layout Conventions](/tools/pub/package-layout)

### Creating library packages

* [Create Library Packages](/guides/libraries/create-library-packages)

### Using specific libraries and packages

* [A Tour of the Dart Libraries](/guides/libraries/library-tour)
* Posts tagged with the
  [Unboxing Packages](http://news.dartlang.org/search/label/Unboxing%20Packages)
  label on on [news.dartlang.org.](http://news.dartlang.org/),
  written by Natalie Weizenbaum.
  This page links to some of Natalie's posts, but she covers other packages
  not mentioned here, such as stream_channel, vm_service_client, and json_rpc_2.

### Packages contributed by the community

* [pub.dartlang.org](https://pub.dartlang.org)

### API reference documentation

* [api.dartlang.org]({{site.dart_api}}) contains the generated docs for dart:* libraries.
* [docs.flutter.io](http://docs.flutter.io/) contains the generated docs for Flutter
  libraries.
* [dartdocs.org](https://www.dartdocs.org/) contains the generated docs for
  packages published on pub.dartlang.org.

