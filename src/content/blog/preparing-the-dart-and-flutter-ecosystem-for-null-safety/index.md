---
title: "Preparing the Dart and Flutter ecosystem for null safety"
description: "Null safety is now API stable. Publish your stable packages now!"
publishDate: 2021-02-16
author: kevmoo
image: images/1VTEwPWrLp7D0teLcI-HALw.png
category: announcements
tags:
  - flutter
  - announcements
  - dart
layout: blog
---


<DashImage src="images/1VTEwPWrLp7D0teLcI-HALw.png" />


Today we’re announcing a new beta release of Dart. This beta represents a new level of stability and confidence in the new [sound null safety](https://medium.com/dartlang/why-nullable-types-7dd93c28c87a) type system, which we’ve been working on for over a year. The updated Dart beta (2.12.0–259.9.beta) is available on [dart.dev](https://dart.dev/get-dart) and is also included in the [beta channel of Flutter](https://flutter.dev/docs/get-started/install). We don’t anticipate any more breaking changes between now and the stable release of this feature.

If you’re a package developer, we invite you to begin publishing stable, null-safe versions of your packages to provide the best experience for users when we ship the stable version of Dart with null safety. We’ve started this process ourselves, publishing stable versions of null-safe packages such as [args](https://pub.dev/packages/args/versions/2.0.0), [yaml](https://pub.dev/packages/yaml/versions/3.0.0), and [grpc](https://pub.dev/packages/grpc/versions/3.0.0). If all of your dependencies are null-safe and published with stable versions (e.g. 1.0.0 instead of 1.0.0-nullsafety.123), now is the time for you to do the same!

We’ve also added a new feature to pub.dev that tags package versions as [preview releases](https://dart.dev/tools/pub/publishing#publishing-previews) when their dependent Dart SDK hasn’t yet been released to stable. Preview releases will automatically be promoted to regular stable versions once a new stable Dart SDK is released.

<DashImage src="images/0GcE_GbN_IrB_dLtq.png" alt="*pub.dev showing the args package with a 1.6.0 stable version and a 2.0.0 preview version*" caption="*pub.dev showing the args package with a 1.6.0 stable version and a 2.0.0 preview version*" />


The [null safety migration guide](https://dart.dev/null-safety/migration-guide) has the latest information on how to migrate your packages. Pay close attention to the Dart SDK constraint and versions of your dependencies in the pubspec, as well as the version of the SDK that you’re using in continuous integration (CI) testing.

The stable, null-safe version of Dart is coming soon! Thanks for helping us make it happen.