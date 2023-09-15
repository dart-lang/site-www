---
title: Command-line and server libraries and packages
short-title: CLI & server libraries
description: Libraries and packages that can help you write Dart command-line & server apps.
---

The [Dart SDK][] contains [dart:io][] and other libraries
that provide low-level command-line & server APIs.

[Dart SDK]: /tools/sdk
[dart:io]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html

## SDK libraries

The Dart SDK contains dart:io and other libraries
that provide low-level web APIs.

[The dart:io section](/guides/libraries/library-tour#dartio) of the library tour
: An example-driven tour of using the dart:io library.
  Topics include working with files & directories, and making & handling 
  HTTP requests.

[dart:io API reference][dart:io]
: Complete reference documentation for the dart:io library.


## Community packages

The [pub.dev site]({{site.pub}}) allows you to search for packages
that support command-line and server apps
by specifying the platforms your app needs to support.
You can also search for words that describe the functionality you need.

### Command-line packages

Command-line apps often use the following packages,
in addition to [general-purpose packages][] such as `archive`, `intl`, and `yaml`:

| **Package**                   | **Description** |
| [args]({{site.pub-pkg}}/args) | Parses raw command-line arguments into a set of options and values. |
| [cli_util]({{site.pub-pkg}}/cli_util) | Provides utilities for building command-line apps. |
| [completion]({{site.pub-pkg}}/completion) | Adds command-line completion to apps that use the `args` package. |
| [path]({{site.pub-pkg}}/path) | Provides comprehensive, cross-platform operations for manipulating paths. |
| [usage]({{site.pub-pkg}}/usage) | Wraps Google Analytics. |
{:.table .table-striped .nowrap}

### Server packages

Server apps can choose from many packages, in addition to
the packages listed in the previous table
and [general-purpose packages][] such as `logging`:

| **Package**                   | **Description** |
| [crypto]({{site.pub-pkg}}/crypto) | Implements cryptographic hashing functions for algorithms such as SHA-1, SHA-256, MD5, and HMAC. |
| [grpc]({{site.pub-pkg}}/grpc) | Implements [gRPC][], a high performance, open source, general RPC framework that puts mobile and HTTP/2 first. |
| [shelf]({{site.pub-pkg}}/shelf) | Provides a model for web server middleware that encourages composition and easy reuse. |
| [dart_frog]({{site.pub-pkg}}/dart_frog) | A fast, minimalistic backend framework for Dart built on top of Shelf. |
| [serverpod]({{site.pub-pkg}}/serverpod) | A scalable app server that supports code generation, authentication, real-time communication, databases, and caching. |
{:.table .table-striped .nowrap}

[general-purpose packages]: /guides/libraries/useful-libraries#general-purpose-packages
[gRPC]: https://grpc.io/
