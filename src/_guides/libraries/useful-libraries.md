---
layout: default
title: "Commonly Used Dart Libraries"
description: "What are some of the most useful and popular Dart libraries and where can you learn more?"
---

You can leverage a wide array of available Dart libraries when writing your code.
Dart libraries are accessed in one of three ways:

* The core libraries, such as dart:core, dart:async, and dart:collections,
  are distributed with the SDK and documented at [api.dartlang.org]({{site.dart_api}}).
* Libraries shared with the Dart community are distributed as library packages,
  published at [pub.dartlang.org](https://pub.dartlang.org/), and documented at
  [dartdocs.org](https://www.dartdocs.org/). The [pub](/tools/pub/) tool
  allows you to create, publish, and manage library packages.
* Libraries that are not shared with the community are simply placed in the
  `/lib` directory of your [application's directory
  structure](https://www.dartlang.org/tools/pub/package-layout#public-directories).

This document talks about the first two kinds of libraries,
and tells you where to learn more about some of the most widely used Dart libraries.

<aside class="alert alert-info" markdown="1">
**Web libraries:**
If you write web apps, you should know about Angular 2, a web application framework.
You might try a [code lab for Angular Dart](https://webdev.dartlang.org/codelabs/ng2),
or refer to the [Angular Dart docs](https://angular.io/docs/dart/latest/).
For more information about Dart on the Web, see [webdev.dartlang]({{site.webdev}}).
</aside>

<aside class="alert alert-info" markdown="1">
**Flutter libraries:**
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
</aside>

<aside class="alert alert-info" markdown="1">
**Dart VM libraries:**
If you write servers or command-line applications, you'll
want to use [dart:io](https://api.dartlang.org/stable/dart-io/dart-io-library.html)
and related libraries, such as
[http_server](https://pub.dartlang.org/packages/http_server).
For more information, see [Dart VM](/dart-vm/).
</aside>

## Dart libraries and their corresponding packages

Dart's core libraries contain classes most commonly used by developers.
Classes that are still useful, but not as universally used,
are placed in packages outside of the SDK.
Separating out the less commonly used classes ensures that your app
isn't bloated by features that you don't need.
For example, the
[dart:collection](https://api.dartlang.org/stable/dart-collection/dart-collection-library.html)
library contains the Queue, HashMap, and HashSet classes. The
[collection package](https://www.dartdocs.org/documentation/collection/latest/collection/collection-library.html)
contains more specialized classes, such as CanonicalizedMap, MapKeySet, PriorityQueue,
and support for equality testing.

If you don't find the functionality you need on api.dartlang.org, check pub.dartlang.

<aside class="alert alert-info" markdown="1">
**Terminology:**
Libraries and packages aren't interchangeable terms. Both libraries and
applications are distributed as packages. A library can be part of a package,
but a package is not a library.
For more information on what constitutes a library package, see
[Create Library Packages](/guides/libraries/create-library-packages).
</aside>

Some of the libraries in the SDK have corresponding packages with additional
functionality. The following table includes some that you should know about:

| **SDK Library** | **Package** |
| [dart:async](https://api.dartlang.org/stable/dart-async/dart-async-library.html)<br>Support for asynchronous programming with classes such as Future and Stream. | [async](https://www.dartdocs.org/documentation/async/latest/)<br>Utility classes to work with asynchronous computations. For more information, see [Unboxing Packages: async part 1](http://news.dartlang.org/2016/03/unboxing-packages-async-part-1.html), [part 2](http://news.dartlang.org/2016/03/unboxing-packages-async-part-2.html), and [part 3](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html). |
| [dart:collection](https://api.dartlang.org/stable/dart-collection/dart-collection-library.html)<br>Classes and utilities that supplement the collection support in dart:core. | [collection](https://www.dartdocs.org/documentation/collection/latest)<br>Utility functions and classes to make working with collections easier. For more information, see [Unboxing Packages: collection](http://news.dartlang.org/2016/01/unboxing-packages-collection.html). |
| [dart:convert](https://api.dartlang.org/stable/dart-convert/dart-convert-library.html)<br>Encoders and decoders for converting between different data representations, including JSON and UTF-8.| [convert](https://www.dartdocs.org/documentation/convert/latest/)<br>This package contains encoders and decoders for converting between different data representations.|
| [dart:core](https://api.dartlang.org/stable/dart-core/dart-core-library.html)<br>Built-in types, collections, and other core functionality for every Dart program. | N/A |
| dart:js<br>Deprecated. | [js](https://www.dartdocs.org/documentation/js/latest)<br>Methods and annotations to specify interoperability with JavaScript APIs. Use this package instead of dart:js. |
{:.table .table-striped .nowrap}

Natalie Weizenbaum has written a series of posts called "Unboxing Packages."
Each post contains in-depth detail on how to use some of the Dart packages.
For more information,
see the [related posts](http://news.dartlang.org/search/label/Unboxing%20Packages)
on [news.dartlang.org](http://news.dartlang.org/).

## Other useful packages

Developers have written some excellent packages for use by the
Dart community.  Here are some popular and useful packages,
in alphabetical order:

[firebase3](https://pub.dartlang.org/packages/firebase3)
: [Firebase](https://firebase.google.com) is a popular cloud services provider.
  This Dart wrapper for Firebase allows you to easily publish your app to the cloud.

[intl](https://pub.dartlang.org/packages/intl)
: The intl library provides internationalization and localization facilities,
  and support for plurals and genders, date and number formatting and parsing,
  and bidirectional text.

[logging](https://pub.dartlang.org/packages/logging)
: The logging library provides a configurable mechanism for adding
  message logging to your application.

[mockito](https://pub.dartlang.org/packages/mockito)
: Mockito is a popular framework for developing unit tests.
  The Dart version of the Mockito library is especially useful if you are
  writing tests for dependency injection.

[path](https://pub.dartlang.org/packages/path)
: The path library provides common operations for manipulating paths on
  different OS platforms. See
  [Unboxing Packages: path](http://news.dartlang.org/2016/06/unboxing-packages-path.html)
  for more information.

[quiver](https://pub.dartlang.org/packages/quiver)
: A set of utility libraries that makes it easier and more convenient to use many Dart
  libraries. Some of the libraries where Quiver provides additional support
  include async, cache, collection, core, iterables, patterns, and testing.

[shelf](https://pub.dartlang.org/packages/shelf)
: Web server middleware for Dart. Shelf makes it easy to create and compose
  web servers, and parts of web servers.

[stagehand](https://pub.dartlang.org/packages/stagehand)
: A Dart project generator. WebStorm and IntelliJ use these templates
  when you create a new application, but you can also use the templates
  from the command line via
  [pub global activate](https://www.dartlang.org/tools/pub/cmd/pub-global).

[test](https://pub.dartlang.org/packages/test)
: A standard way of writing and running tests in Dart. This package replaces
  the deprecated unittest package.

Search for other available packages on [pub.dartlang.org](https://pub.dartlang.org/).

## Importing libraries and packages

If you need help with importing libraries into your code, see
[Using libraries](/guides/language/language-tour#libraries-and-visibility),
a section in the [language tour](/guides/language/language-tour), and
[Importing library
files](/guides/libraries/create-library-packages#importing-library-files),
a section in [Create Library Packages](/guides/libraries/create-library-packages).

## Resources

Use the following resources to learn more about libraries and library packages:

* [Create Library Packages](/guides/libraries/create-library-packages)
  explains how to create a library package.
* [Libraries and visibility](/guides/language/language-tour#libraries-and-visibility)
  in the [language tour](/guides/language/language-tour) covers using library files.
* The [pub](/tools/pub) documentation is useful, particularly
  [Pub Package Layout Conventions](/tools/pub/package-layout).
* [pub.dartlang.org](https://pub.dartlang.org) lists library packages available
  to the Dart community.
* [api.dartlang.org]({{site.dart_api}}) contains the generated docs for dart:* libraries.
* [docs.flutter.io](http://docs.flutter.io/) contains the generated docs for Flutter
  libraries.
* [dartdocs.org](https://www.dartdocs.org/) contains the generated docs for
  packages published on pub.dartlang.org.

