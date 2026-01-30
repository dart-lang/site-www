---
title: Command-line and server apps
shortTitle: CLI & server apps
description: All things relating to command-line and server apps.
showToc: false
---

This page points to tools and documentation
that can help you develop command-line and server apps.

## Tools

[DartPad](/tools/dartpad)
: Handy for both beginners and experts,
  DartPad lets you try out language features and dart:* APIs.

  :::note
  DartPad does **not** support using VM libraries, such as `dart:io`,
  or importing libraries from packages
  besides the [currently supported packages][].
  :::

[currently supported packages]: {{site.repo.dart.org}}/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

[Dart SDK](/tools/sdk)
: [Install the Dart SDK](/get-dart) to get the core Dart
  libraries and [tools](/tools).

## Frameworks

Server-side frameworks written in Dart include:

[Serverpod](https://serverpod.dev)
: A scalable app server that supports code generation,
  authentication, real-time communication, databases, and caching.

[Dart Frog](https://dart-frog.dev/)
: A fast, minimalistic backend framework for Dart.

More tools
: The [Tools](/tools) page links to generally useful tools,
  such as Dart plugins for your favorite IDE or editor.

For additional options, see [#server packages on pub.dev][server-pkgs].

[server-pkgs]: {{site.pub-pkg}}?q=topic%3Aserver

## Samples

[A simple Dart HTTP server][simple-sample]
: * Uses the [`shelf`][] package.
  * Also uses the [`shelf_router`][] and [`shelf_static`][] packages.
  * Is deployable on Cloud Run.

[A Dart HTTP server that uses Cloud Firestore][cloud-sample]
: * Uses the Cloud Firestore features in the [`googleapis`][] package.
  * Also uses the [`googleapis_auth`][], [`shelf`][], and
    [`shelf_router`][] packages.
  * Is deployable on Cloud Run.

[simple-sample]: {{site.repo.dart.samples}}/tree/main/server/simple
[cloud-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
[`googleapis`]: {{site.pub-pkg}}/googleapis
[`googleapis_auth`]: {{site.pub-pkg}}/googleapis_auth
[`shelf`]: {{site.pub-pkg}}/shelf
[`shelf_router`]: {{site.pub-pkg}}/shelf_router
[`shelf_static`]: {{site.pub-pkg}}/shelf_static

## More resources

[Dart API]({{site.dart-api}})
: API reference for dart:* libraries.

[`dart:io` documentation](/libraries/dart-io)
: Shows how to use the major features of the dart:io library.
  You can use the dart:io library in command-line scripts, servers, and
  non-web [Flutter apps.]({{site.flutter}})

[Using Google Cloud][]
: Guides and documentation on Google Cloud products
  that Dart servers can use, such as Cloud Run.

[Using Google APIs][]
: Resources to help you use Firebase and Google client APIs from a Dart app.

[Using Google Cloud]: /server/google-cloud
[Using Google APIs]: /resources/google-apis
