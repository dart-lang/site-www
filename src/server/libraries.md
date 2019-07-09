---
title: "Command-line & server libraries and packages"
short-title: CLI & server libraries
description: Libraries and packages that can help you write Dart command-line & server apps.
---

The [Dart SDK][] contains [dart:io][] and other libraries
that provide low-level command-line & server APIs.

[Dart SDK]: /tools/sdk
[dart:io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html

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

The [Pub site]({{site.pub}}) doesn't currently support
limiting your search to packages that support command-line and server apps.
You can, however, search for words that describe the functionality you need.

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
| [appengine]({{site.pub-pkg}}/appengine) | Provides support for running server applications written in Dart on [Google App Engine][] using [Custom Runtimes with Flex Environment.][] |
| [aqueduct]({{site.pub-pkg}}/aqueduct) | Supports building scalable REST APIs that run on the Dart VM. |
| [angel_framework]({{site.pub-pkg}}/angel_framework) | A high-powered HTTP server with support for dependency injection & sophisticated routing. |
| [crypto]({{site.pub-pkg}}/crypto) | Implements cryptographic hashing functions for algorithms such as SHA-1, SHA-256, MD5, and HMAC. |
| [grpc]({{site.pub-pkg}}/grpc) | Implements [gRPC,][] a high performance, open source, general RPC framework that puts mobile and HTTP/2 first. |
| [http_multi_server]({{site.pub-pkg}}/http_multi_server) | Extends the [dart:io HttpServer][HttpServer] class with support for multiple servers. |
| [http_server]({{site.pub-pkg}}/http_server) | Provides utility classes that work with [HttpServer][] to serve web content. |
| [shelf]({{site.pub-pkg}}/shelf) | Provides a model for web server middleware that encourages composition and easy reuse. |
{:.table .table-striped .nowrap}

[Google App Engine]: https://cloud.google.com/appengine/
[Custom Runtimes with Flex Environment.]: https://cloud.google.com/appengine/docs/flexible/custom-runtimes/
[general-purpose packages]: /guides/libraries/useful-libraries#general-purpose-packages
[gRPC,]: https://grpc.io/
[HttpServer]: https://api.dart.dev/stable/dart-io/HttpServer-class.html
