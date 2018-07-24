---
layout: default
title: "Commonly Used Dart Libraries"
description: "What are some of the most useful and popular Dart libraries and where can you learn more?"
---

You can use many Dart libraries when writing your code.
Dart libraries come from a variety of sources:

* Core libraries&mdash;such as dart:core, dart:async, and dart:collection&mdash;are
  distributed with the SDK and documented at [api.dartlang.org]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}).
* Libraries shared with the Dart community are distributed as library packages,
  published at [pub.dartlang.org](https://pub.dartlang.org/).
  The [pub](/tools/pub/) tool allows you to create, publish, and manage library packages.
* Libraries from GitHub, a URL, or a local path can be included in your application.
  For more information, see
  [Dependency sources](/tools/pub/dependencies#dependency-sources),
  a section in [Pub Dependencies](/tools/pub/dependencies).
* Local libraries are placed under the `/lib` directory of your [application's directory
  structure](/tools/pub/package-layout#public-directories).

This document discusses the first two kinds of libraries,
and tells you where to learn more about some of the most widely used Dart libraries.

<aside class="alert alert-info" markdown="1">
**Tip:**
If you don't find the functionality you need on [api.dartlang.org]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}),
check [pub.dartlang.org](https://pub.dartlang.org/).
</aside>

Looking for web, server, or Flutter libraries?
See [Specialized libraries](#specialized-libraries).

## Dart SDK libraries

The SDK libraries (such as dart:core, dart:async, dart:math, dart:convert)
contain the fundamental classes used in Dart applications.
Classes that aren't as universal are placed in packages outside of the SDK.

The [library tour](/guides/libraries/library-tour) walks you through the
libraries distributed with the SDK.

## Commonly used packages

Developers have written some excellent packages for use by the
Dart community.  Here are some popular and useful packages,
in alphabetical order:

| **Package** | **Description** | **Commonly used APIs** |
| [firebase](https://pub.dartlang.org/packages/firebase) | A wrapper for [Firebase](https://firebase.google.com) that allows you to easily publish your app to the cloud. | Auth, Database, Query, Storage |
| [http](https://pub.dartlang.org/packages/http) | A set of high-level functions and classes that make it easy to consume HTTP resources. | delete(), get(), post(), read() |
| [intl](https://pub.dartlang.org/packages/intl) | Internationalization and localization facilities, with support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [logging](https://pub.dartlang.org/packages/logging) | A configurable mechanism for adding message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito](https://pub.dartlang.org/packages/mockito) | A popular framework for mocking objects in tests. Especially useful if you are writing tests for dependency injection. Used with the [test](https://pub.dartlang.org/packages/test) package. | Answering, Expectation, Verification |
| [path](https://pub.dartlang.org/packages/path) | Common operations for manipulating different types of paths. For more information, see [Unboxing Packages: path.](http://news.dartlang.org/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver](https://pub.dartlang.org/packages/quiver) | Utilities that make using core Dart libraries more convenient. Some of the libraries where Quiver provides additional support include async, cache, collection, core, iterables, patterns, and testing. | CountdownTimer (quiver.async); MapCache (quiver.cache); MultiMap, TreeSet (quiver.collection); EnumerateIterable (quiver.iterables); center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings)  |
| [shelf](https://pub.dartlang.org/packages/shelf) | Web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace](https://pub.dartlang.org/packages/stack_trace) | Methods for parsing, inspecting, and manipulating stack traces produced by the underlying Dart implementation. Also provides functions to produce string representations of stack traces in a more readable format than the native StackTrace implementation. For more information, see [Unboxing Packages: stack_trace.](http://news.dartlang.org/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [stagehand](https://pub.dartlang.org/packages/stagehand) | A Dart project generator. WebStorm and IntelliJ use Stagehand templates when you create a new application, but you can also use the templates from the command line. | Generally used through an IDE or the [`stagehand` command](http://stagehand.pub/). |
| [test](https://pub.dartlang.org/packages/test) | A standard way of writing and running tests in Dart. | expect(), group(), test() |
{:.table .table-striped .nowrap}

To find more packages, see [pub.dartlang.org](https://pub.dartlang.org/).

## Packages that correspond to SDK libraries

Each of these "expansion pack" libraries builds upon an SDK library, adding
additional functionality and filling in missing features:

| **Package** | **Description** | **Commonly used APIs** |
| [async](https://www.dartdocs.org/documentation/async/latest/) | Expands on dart:async, adding utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3.](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection](https://www.dartdocs.org/documentation/collection/latest) | Expands on dart:collection, adding utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection.](http://news.dartlang.org/2016/01/unboxing-packages-collection.html) | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
|[convert](https://www.dartdocs.org/documentation/convert/latest/) | Expands on dart:convert, adding encoders and decoders for converting between different data representations. One of the data representations is _percent encoding_, also known as _URL encoding_. | HexDecoder, PercentDecoder |
{:.table .table-striped .nowrap}

## Specialized libraries

This page doesn't include some of the more specialized libraries that are covered
elsewhere.

### Web libraries

If you write web apps, check out AngularDart, a web application framework.
Other available resources are the js package for interoperability with
JavaScript APIs, and the dart:html library for low-level HTML programming.

**Learn more:** [webdev.dartlang.org]({{site.webdev}})

### Server-side libraries

If you write servers or command-line applications, check out
[dart:io](https://api.dartlang.org/stable/dart-io/dart-io-library.html)
and related libraries.

**Learn more:** [server-side Dart]({{site.dart_vm}})

### Flutter libraries

If you write mobile apps, check out Flutter.
The core libraries distributed with the Flutter SDK are documented at
[docs.flutter.io](http://docs.flutter.io/). To import these libraries,
follow the instructions in [Importing libraries from
packages](https://www.dartlang.org/tools/pub/get-started#importing-libraries-from-packages).

**Learn more:** [flutter.io]({{site.flutter}})

## Resources

Use the following resources to learn more about libraries and library packages.

### Importing and using libraries

* [Using libraries](/guides/language/language-tour#libraries-and-visibility),
  a section in the [language tour](/guides/language/language-tour)
* [Importing library
  files](/guides/libraries/create-library-packages#importing-library-files),
  a section in [Create Library Packages](/guides/libraries/create-library-packages)
* [Pub docs](/tools/pub), particularly
  [Pub Package Layout Conventions](/tools/pub/package-layout) and
  [Dependency sources](/tools/pub/dependencies#dependency-sources)

### Creating library packages

* [Create Library Packages](/guides/libraries/create-library-packages)

### Using specific libraries and packages

* [A Tour of the Dart Libraries](/guides/libraries/library-tour), which
  gives examples of many commonly used dart:* APIs.
* [Unboxing Packages](http://news.dartlang.org/search/label/Unboxing%20Packages)
  posts, written by written by Natalie Weizenbaum and published on
  [news.dartlang.org.](http://news.dartlang.org/).
  This page links to some of Natalie's posts, but she covers other packages
  not mentioned here, such as stream_channel, vm_service_client, and json_rpc_2.

### Packages contributed by the community

* [pub.dartlang.org](https://pub.dartlang.org)

### API reference documentation

* [api.dartlang.org]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}) contains the generated docs for dart:* libraries.
* [dartdocs.org](https://www.dartdocs.org/) contains the generated docs for
  packages published on pub.dartlang.org.
* [docs.flutter.io](http://docs.flutter.io/) contains the generated docs for Flutter
  libraries.

