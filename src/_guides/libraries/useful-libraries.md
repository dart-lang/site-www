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
  published at [pub.dartlang.org.]({{site.pub}})
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
If you don't find the functionality you need on [api.dartlang.org,]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}})
check [pub.dartlang.org.]({{site.pub}})
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
| [http]({{site.pub-pkg}}/http) | A set of high-level functions and classes that make it easy to consume HTTP resources. | delete(), get(), post(), read() |
| [intl]({{site.pub-pkg}}/intl) | Internationalization and localization facilities, with support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [logging]({{site.pub-pkg}}/logging) | A configurable mechanism for adding message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito]({{site.pub-pkg}}/mockito) | A popular framework for mocking objects in tests. Especially useful if you are writing tests for dependency injection. Used with the [test]({{site.pub-pkg}}/test) package. | Answering, Expectation, Verification |
| [path]({{site.pub-pkg}}/path) | Common operations for manipulating different types of paths. For more information, see [Unboxing Packages: path.](https://news.dartlang.org/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver]({{site.pub-pkg}}/quiver) | Utilities that make using core Dart libraries more convenient. Some of the libraries where Quiver provides additional support include async, cache, collection, core, iterables, patterns, and testing. | CountdownTimer (quiver.async); MapCache (quiver.cache); MultiMap, TreeSet (quiver.collection); EnumerateIterable (quiver.iterables); center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings)  |
| [shelf]({{site.pub-pkg}}/shelf) | Web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace]({{site.pub-pkg}}/stack_trace) | Methods for parsing, inspecting, and manipulating stack traces produced by the underlying Dart implementation. Also provides functions to produce string representations of stack traces in a more readable format than the native StackTrace implementation. For more information, see [Unboxing Packages: stack_trace.](https://news.dartlang.org/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [stagehand]({{site.pub-pkg}}/stagehand) | A Dart project generator. WebStorm and IntelliJ use Stagehand templates when you create a new application, but you can also use the templates from the command line. | Generally used through an IDE or the `stagehand` command. |
| [test]({{site.pub-pkg}}/test) | A standard way of writing and running tests in Dart. | expect(), group(), test() |
| [yaml]({{site.pub-pkg}}/yaml) | A parser for YAML. | loadYaml(), loadYamlStream() |
{:.table .table-striped .nowrap}

To find more packages, see [pub.dartlang.org.]({{site.pub}})

## Packages that correspond to SDK libraries

Each of these "expansion pack" libraries builds upon an SDK library, adding
additional functionality and filling in missing features:

| **Package** | **Description** | **Commonly used APIs** |
| [async]({{site.pub-pkg}}/async) | Expands on dart:async, adding utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](https://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](https://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3.](https://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection]({{site.pub-pkg}}/collection) | Expands on dart:collection, adding utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection.](https://news.dartlang.org/2016/01/unboxing-packages-collection.html) | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
|[convert]({{site.pub-pkg}}/convert) | Expands on dart:convert, adding encoders and decoders for converting between different data representations. One of the data representations is _percent encoding_, also known as _URL encoding_. | HexDecoder, PercentDecoder |
|[io]({{site.pub-pkg}}/io) | Contains two libraries, ansi and io, to simplify working with files, standard streams, and processes. Use the ansi library to customize terminal output. The io library has APIs for dealing with processes, stdin, and file duplication. |  copyPath(), isExecutable(), ExitCode, ProcessManager, sharedStdIn |
{:.table .table-striped .nowrap}
{% comment %}
  update-for-dart-2
  TODO: Add math after it's been updated
{% endcomment %}

## Specialized libraries

This page doesn't include some of the more specialized libraries that are covered
elsewhere.

### Web libraries

If you write web apps, check out AngularDart, a web application framework.
Other available resources are the
[js package]({{site.pub-pkg}}/js)
for interoperability with JavaScript APIs,
the [firebase package]({{site.pub-pkg}}/firebase)
for access to the Firebase JavaScript API, and the
[dart:html library]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html)
for low-level HTML programming.

**Learn more:** [webdev.dartlang.org]({{site.webdev}})

### Server-side libraries

If you write servers or command-line applications, check out
[dart:io]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html)
and related libraries.

**Learn more:** [server-side Dart]({{site.dart_vm}})

### Flutter libraries

If you write mobile apps, check out Flutter.
The core libraries distributed with the Flutter SDK are documented at
[docs.flutter.io.](https://docs.flutter.io/) To import these libraries,
follow the instructions in [Importing libraries from
packages](/tools/pub/get-started#importing-libraries-from-packages).

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
* [Unboxing Packages](https://news.dartlang.org/search/label/Unboxing%20Packages)
  posts, written by written by Natalie Weizenbaum and published on
  [news.dartlang.org.](https://news.dartlang.org/)
  This page links to some of Natalie's posts, but she covers other packages
  not mentioned here, such as stream_channel, vm_service_client, and json_rpc_2.

### Packages contributed by the community

* [pub.dartlang.org]({{site.pub}})

### API reference documentation

* [api.dartlang.org]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}) contains the generated docs for dart:* libraries.
* [pub.dartlang.org]({{site.pub}}) hosts the generated docs for published packages.
* [docs.flutter.io](https://docs.flutter.io/) contains the generated docs for Flutter
  libraries.

