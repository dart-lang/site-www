---
title: Command-line and server apps
short-title: CLI & server apps
description: All things relating to command-line and server apps.
toc: false
---

This page points to tools and documentation
that can help you develop command-line and server apps.

<p class="text-center">
  <a href="/tutorials/server/get-started" class="btn btn-primary btn-lg">Get started</a>
</p>


## Tools

[DartPad](/tools/dartpad)
: Handy for both beginners and experts,
  DartPad lets you try out language features and dart:* APIs.

  {{site.alert.note}}
    DartPad does **not** support using VM libraries, such as `dart:io`,
    or importing libraries from packages
    besides the [currently supported packages][].
  {{site.alert.end}}

[currently supported packages]: https://github.com/dart-lang/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

[Dart SDK](/tools/sdk)
: [Install the Dart SDK](/get-dart) to get the core Dart
  libraries and [tools](/tools).

## Frameworks

Server-side frameworks written in Dart include:

[Serverpod](https://serverpod.dev)
: A scalable app server that supports code generation,
  authentication, real-time communication, databases, and caching.

[Dart Frog](https://dartfrog.vgv.dev/)
: A fast, minimalistic backend framework for Dart.

More tools
: The [Tools](/tools) page links to generally useful tools,
  such as Dart plugins for your favorite IDE or editor.

For additional options, see [#server packages on pub.dev]({{site.pub}}/packages?q=topic%3Aserver).

## Tutorials

You might find the following tutorials helpful.

[Get started](/tutorials/server/get-started)
: Learn how to use the Dart SDK to develop command-line and server apps.

[gRPC Quickstart](https://grpc.io/docs/languages/dart/quickstart/)
: Walks you through running and modifying a client-server example that uses the gRPC framework.

[Write command-line apps](/tutorials/server/cmdline)
: Introduces dart:io and the args package.

[Write HTTP servers](/tutorials/server/httpserver)
: Features the shelf package.

## More resources

[Dart API]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}})
: API reference for dart:* libraries.

[dart:io section of the library tour](/guides/libraries/library-tour#dartio)
: Shows how to use the major features of the dart:io library.
  You can use the dart:io library in command-line scripts, servers, and
  non-web [Flutter apps.]({{site.flutter}})
