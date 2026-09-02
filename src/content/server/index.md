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

## Server architectures and frameworks {#frameworks}

Dart supports multiple backend architectures depending on your application
requirements:

| Architecture / framework | Best suited for | Key advantages | Data and persistence |
| :--- | :--- | :--- | :--- |
| **[Cloud Functions for Firebase](https://firebase.google.com/docs/functions/start-dart)** | Serverless HTTP and callable APIs, Flutter backends | Shared code with Flutter, zero server management, fast AOT cold starts | Cloud Firestore and Cloud Storage via [`firebase_admin_sdk`]({{site.pub-pkg}}/firebase_admin_sdk) |
| **[Serverpod](https://serverpod.dev)** | Full-stack applications requiring relational databases | Code generation, built-in authentication, database migrations | PostgreSQL, Redis |
| **[Dart Frog](https://dart-frog.dev/)** | Fast REST APIs, modular microservices | Minimalistic routing, dependency injection, built on Shelf | Database agnostic |
| **[Shelf]({{site.pub-pkg}}/shelf)** | Custom web servers, composable middleware | Lightweight primitive, modular architecture | Database agnostic |

{:.table .table-striped}

For more tools and IDE plugins, see the [Tools](/tools) page.
For additional options, see [#server packages on pub.dev][server-pkgs].

[server-pkgs]: {{site.pub-pkg}}?q=topic%3Aserver

## Building serverless backends with Cloud Functions for Firebase

Write Cloud Functions for Firebase using Dart to enable full-stack development,
reuse code between your client and backend, and respond to Firebase triggers.
Dart Cloud Functions compile Ahead-of-Time (AOT) to native binaries that deploy
directly to Google Cloud infrastructure, delivering fast cold-start performance
with minimal memory overhead.

To get started, see the
[Cloud Functions for Firebase documentation][firebase-docs].

[Firebase Functions package]({{site.pub-pkg}}/firebase_functions)
: The core package to write backend functions and APIs in Dart.

[Firebase Admin SDK package]({{site.pub-pkg}}/firebase_admin_sdk)
: Access Firebase services securely from backend servers or Cloud Functions.
  Use it to manage data, send notifications, or verify auth tokens.

[Firebase Functions for Dart repository][firebase-repo]
: GitHub repository with quickstart guides, examples, and source code.

[firebase-docs]: https://firebase.google.com/docs/functions/start-dart
[firebase-repo]: https://github.com/firebase/firebase-functions-dart

### Sharing code between Flutter apps and Dart backends

When you use Dart for both your Flutter client and Firebase backend, you can
organize your workspace into a monorepo or multi-package structure with a
shared package:

```text
my_project/
├── packages/
│   ├── app/           # Flutter frontend application
│   ├── functions/     # Cloud Functions for Firebase in Dart
│   └── shared/        # Shared models, DTOs, and validation logic
```

By placing data classes, JSON serialization logic, and validation rules in
`package:shared`, any change to your data models propagates across both client
and server, keeping your frontend and backend synchronized.

## Samples

[A simple Dart HTTP server][simple-sample]
: * Uses the [`shelf`][] package.
  * Also uses the [`shelf_router`][] and [`shelf_static`][] packages.
  * Is deployable on Cloud Run.

[A Dart HTTP server that uses Cloud Firestore][cloud-sample]
: * Uses Cloud Firestore with the [`firebase_admin_sdk`][] package.
  * Is deployable on Cloud Run.

[simple-sample]: {{site.repo.dart.samples}}/tree/main/server/simple
[cloud-sample]: {{site.repo.dart.samples}}/tree/main/server/google_apis
[`firebase_admin_sdk`]: {{site.pub-pkg}}/firebase_admin_sdk
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
