---
title: "Introducing Realm for Dart & Flutter"
description: "A case study in using Dart platform primitives to build a rich multi-platform library for Dart and Flutter apps."
publishDate: 2023-02-09
author: "mit-mit"
image: images/1cAi4WO4IfN5Sp6WE6Ex8Ig.png
category: other
tags:
  - dart
  - realm
---


We’re excited to see MongoDB announce the general availability (GA) of Realm for Dart and Flutter today! Realm is a reactive, object-oriented, cross-platform database, popular among app developers. In other words, perfect for Dart and Flutter. So, over the past year we’ve collaborated with MongoDB to bring Realm to Dart and Flutter. Checkout the [blog post](https://www.mongodb.com/developer/products/realm/announcing-realm-flutter-sdk/) by MongoDB for details on what Realm offers, how it’s improved from their earlier previews, and what they have planned for the future. We think Realm will be a great match for Dart & Flutter developers.

<DashImage src="images/1cAi4WO4IfN5Sp6WE6Ex8Ig.png" alt="Writing books to a Realm data store using Dart" caption="Writing books to a Realm data store using Dart" />


In this companion post, we’ll take a peek behind the scenes to learn how Realm for Dart & Flutter is built, as a practical example of how to build new Dart-based developer SDKs.

## Realm example

Before we dig into the implementation of the Realm SDK, let’s start with a quick tour of how to use the SDK as a developer working on a Dart [terminal app](https://dart.dev/tutorials/server/cmdline) (*note*: the steps for a Flutter app are slightly different; see [the documentation](https://www.mongodb.com/docs/realm/sdk/flutter/install/) for details).

First, you define a data model. This is done using regular Dart classes with some added Realm annotations. Here’s a sample data class for a book:


With the model defined, and the data model fully generated (see below), you can go ahead and write some books to a Realm data store:



## How Realm for Dart and Flutter was built

Now that we’ve covered the basics, let’s see how the MongoDB team built Realm for Dart and Flutter utilizing a number of Dart libraries and tools. We’ll take a look at what happens when the Realm SDK is initialized, how the Realm SDK is built on top of a shared native C++ library, how the Realm terminal tool was built, and how Realm models are generated.

## Initializing the Realm SDK

Dart and Flutter developers will start by adding Realm to their existing app, and then running the installer:

```shell
dart pub add realm_dart
dart run realm_dart install
```


The first step simply adds the Realm SDK to `pubspec.yaml` to [register it as a dependency](https://dart.dev/tools/pub/dependencies) of the app. The second step runs the Realm terminal tool, asking it to install the SDK. If we look inside the [source code for the install command](https://github.com/realm/realm-dart/blob/main/lib/src/cli/install/install_command.dart), we can see `install` determines what operating system we are developing on, and then downloads the Realm SDK binaries for that operating system.

But why is the install command downloading a binary? The Realm SDK is a very comprehensive offering, available across a large range of operating systems and developer frameworks. To avoid having to build a large number of instantiations of the Realm SDK, the Realm team decided to implement the core Realm SDK as a shared [realm-core C++ library](https://github.com/realm/realm-core). So, what the install command really does is download compiled versions of this core library for all platforms the app supports.

## Calling into the realm-core SDK

Users of the Realm SDK writing Dart or Flutter apps get nice, strongly typed Dart APIs, as illustrated in the beginning of this post. How do those APIs correspond to the [`realm-core`](https://github.com/realm/realm-core) C++ library?

If we peek inside the `lib` directory of the Realm SDK we find [`realm_bindings.dart`](https://github.com/realm/realm-dart/blob/main/lib/src/native/realm_bindings.dart), which starts with:


Mystery solved: The Realm SDK uses Dart’s support for interoperability with native APIs via the `dart:ffi` library to call into realm-core. To avoid having to write FFI bindings manually for the very large set of available Realm APIs, the bindings are auto generated using Dart’s [`ffigen`](https://pub.dev/packages/ffigen)tool. This is a pattern we’re seeing rapid growth of across the Dart team.

## The Realm terminal tool

Let’s turn to the Realm terminal tool itself. Above, we ran the install command, but we can also run the tool without specifying a command:

```shell
$ dart run realm_dart
Realm commands for working with Realm Flutter & Dart SDKs.

Usage: dart run realm|realm_dart <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  generate   Generate Realm objects from data model classes
  install    Download & install Realm native binaries into a Flutter or Dart project
  metrics    Report anonymized builder metrics to Realm

Run "dart run realm|realm_dart help <command>" for more information about a command.
```


You may notice that this output looks a lot like the output from the core dart and flutter tool. This is no coincidence; all three tools are built using the same Dart foundation libraries for terminal tools from [`package:args`](https://pub.dev/packages/args):

* The [`args`](https://pub.dev/documentation/args/latest/args/args-library.html) library has rich support for parsing raw command line arguments into options and flags

* The [`command_runner`](https://pub.dev/documentation/args/latest/command_runner/command_runner-library.html) libraryprovides a structure for commands supported by the tool (e.g. install)

## Generating the Realm model

The `generate` command is especially interesting because it generates the full Realm model from the annotated Dart model classes that we defined in the “Realm example” section:

```shell
dart run realm_dart generate
```


How does the generate command work? It relies on the Realm [generator](https://github.com/realm/realm-dart/blob/main/generator/README.md), which is built on top of Dart’s [`build_runner`](https://pub.dev/packages/build_runner), a framework for generators that takes a set of input files and then creates new output files. Typically — as in the Realm case — the inputs are Dart source code files with annotations, and the output files are additional generated Dart source code.

## Closing thoughts

We hope you enjoyed this peek behind the curtain of how a large developer framework can be built from a set of reusable Dart libraries. If you are a framework developer, hopefully this can give you some inspiration for your next Dart-based framework.

For Dart and Flutter app developers, Realm is a great new offering from the MongoDB team. We invite you to check out the [Realm SDK documentation](https://www.mongodb.com/docs/realm/sdk/flutter/), and today’s [Realm blog post](https://www.mongodb.com/developer/products/realm/announcing-realm-flutter-sdk/).