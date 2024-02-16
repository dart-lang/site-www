---
title: Commonly used packages
description: Some of the most useful and popular packages, and where you can learn more.
---

{% assign pub = site.pub %}
{% assign pubpkg = site.pub-pkg %}

This page lists some of the most popular and useful
[packages](/guides/packages) that Dart developers have published.
To find more packages—and search [core libraries](/libraries)
as well—use the [pub.dev site.]({{pub}})

Commonly used packages fall into three groups:

* [General-purpose packages](#general-purpose-packages)
* [Packages that expand on Dart core libraries](#packages-that-correspond-to-sdk-libraries)
* [Specialized packages](#specialized-packages)

## General-purpose packages

Use these packages for a wide range of projects.

| Package | Description | Commonly used APIs |
|----|----|----|
| [archive][] | Encodes and decodes various archive and compression formats. | Archive, ArchiveFile, TarEncoder, TarDecoder, ZipEncoder, ZipDecoder |
| [characters][] | Manipulates strings for user-perceived characters (Unicode grapheme clusters). | String.characters, Characters, CharacterRange |
| [cronet_http][] | Provides access to the Android [Cronet][cronet] HTTP client using the same interface as `package:http`. | |
| [cupertino_http][] | Provides access to Apple's [Foundation URL Loading System][furl] using the same interface as `package:http`. | |
| [http][] | Provides set of high-level functions and classes to simplify consuming HTTP resources. | delete(), get(), post(), read() |
| [intl][] | Internationalization and localization facilities, with support for plurals and genders, date and number formatting and parsing, and bidirectional text. | Bidi, DateFormat, MicroMoney, TextDirection |
| [json_serializable][] | Generates JSON manipulation code. To learn more, consult [JSON Support](/guides/json). | @JsonSerializable |
| [logging][] | Adds message logging to your application. | LoggerHandler, Level, LogRecord |
| [mockito][] | Mocks objects in tests. Helps when you write tests for dependency injection. Use with the [test][] package. | Answering, Expectation, Verification |
| [path][] | Manipulates different types of paths. To learn more, consult [Unboxing Packages: path.]({{site.news}}/2016/06/unboxing-packages-path.html) | absolute(), basename(), extension(), join(), normalize(), relative(), split() |
| [quiver][] | Simplifies using core Dart libraries. Some of the libraries where Quiver provides additional support include async, cache, collection, core, iterables, patterns, and testing. | CountdownTimer (quiver.async); MapCache (quiver.cache); MultiMap, TreeSet (quiver.collection); EnumerateIterable (quiver.iterables); center(), compareIgnoreCase(), isWhiteSpace() (quiver.strings) |
| [shelf][] | Provides web server middleware for Dart. Shelf makes it easy to create and compose web servers, and parts of web servers. | Cascade, Pipeline, Request, Response, Server |
| [stack_trace][] | Parses, inspects, and manipulates stack traces that Dart produces. Also transforms stack traces into a more readable format than the native StackTrace implementation. To learn more, consult [Unboxing Packages: stack_trace.]({{site.news}}/2016/01/unboxing-packages-stacktrace.html) | Trace.current(), Trace.format(), Trace.from() |
| [test][] | Standardizes writing and running tests in Dart. | expect(), group(), test() |
| [yaml][] | Parses YAML markup. | loadYaml(), loadYamlStream() |

{:.table .table-striped .nowrap}

[archive]: {{pubpkg}}/archive
[characters]: {{pubpkg}}/characters
[cronet_http]: {{pubpkg}}/cronet_http
[cupertino_http]: {{pubpkg}}/cupertino_http
[http]: {{pubpkg}}/http
[intl]: {{pubpkg}}/intl
[json_serializable]: {{pubpkg}}/json_serializable
[logging]: {{pubpkg}}/logging
[mockito]: {{pubpkg}}/mockito
[path]: {{pubpkg}}/path
[quiver]: {{pubpkg}}/quiver
[shelf]: {{pubpkg}}/shelf
[stack_trace]: {{pubpkg}}/stack_trace
[test]: {{pubpkg}}/test
[yaml]: {{pubpkg}}/yaml
[Cronet]: {{site.android-dev}}/develop/connectivity/cronet
[furl]: {{site.apple-dev}}/documentation/foundation/url_loading_system

## Packages that expand on Dart core libraries {:#packages-that-correspond-to-sdk-libraries}

Each of the following packages builds upon a [core library](/libraries),
adding functionality and filling in missing features:

| Package | Description | Commonly used APIs |
|----|----|----|
| [async][] | Expands on dart:async, adding utility classes to work with asynchronous computations. To learn more, consult [Unboxing Packages: async part 1][async-1], [part 2][async-2], and [part 3][async-3]. | AsyncMemoizer, CancelableOperation, FutureGroup, LazyStream, Result, StreamCompleter, StreamGroup, StreamSplitter |
| [collection][] | Expands on dart:collection, adding utility functions and classes to make working with collections easier. To learn more, consult [Unboxing Packages: collection][collect]. | Equality, CanonicalizedMap, MapKeySet, MapValueSet, PriorityQueue, QueueList |
| [convert][] | Expands on dart:convert, adding encoders and decoders for converting between different data representations. One of the data representations is _percent encoding_, also known as _URL encoding_. | HexDecoder, PercentDecoder |
| [io][] | Contains two libraries, ansi and io, to simplify working with files, standard streams, and processes. Use the ansi library to customize terminal output. The io library has APIs for dealing with processes, stdin, and file duplication. |  copyPath(), isExecutable(), ExitCode, ProcessManager, sharedStdIn |

{:.table .table-striped .nowrap}

[async]: {{pubpkg}}/async
[collection]: {{pubpkg}}/collection
[convert]: {{pubpkg}}/convert
[io]: {{pubpkg}}/io
[async-1]: {{site.news}}/2016/03/unboxing-packages-async-part-1.html
[async-2]: {{site.news}}/2016/03/unboxing-packages-async-part-2.html
[async-3]: {{site.news}}/2016/04/unboxing-packages-async-part-3.html
[collect]: {{site.news}}/2016/01/unboxing-packages-collection.html

## Specialized packages

To find specialized packages such as packages for Flutter and web development,
consult the following sections.

### Flutter packages

To learn more about Flutter packages,
consult [Using packages][flutterpkg] in the Flutter documentation
or search the pub.dev site for [Flutter packages][fluttersearch].

[flutterpkg]: {{site.flutter-docs}}/development/packages-and-plugins/using-packages
[fluttersearch]: {{pub}}/flutter

### Web packages

To learn more about web packages,
consult [Web libraries and packages][webpkg]
or search the pub.dev site for [web packages][pkgsearch].

[webpkg]: /web/libraries
[pkgsearch]: {{pub}}/web

### Command-line and server packages

To learn more about CLI or server packages,
See [Command-line and server libraries and packages](/server/libraries).
Or use the pub.dev site to [search for other packages.]({{pub}})
