---
title: Tools for Server-Side Development
description: The tools that you get when you download the Dart SDK.
toc: false
---

When you install the [Dart SDK](/tools/sdk), you get all the command-line tools
that you need to write Dart servers and command-line scripts.

The following tools have special support for running scripts and servers.

[Standalone Dart VM: `dart`](/server/tools/dart-vm)
: Executes Dart code.
  IDEs that support Dart,
  and some of the `pub` commands, use this
  command behind-the-scenes to execute Dart scripts.
  Note that you must configure your IDE with the location of
  the `dart` binary.

[Pub package manager: `pub`](/tools/pub)
: Simplifies downloading and running scripts,
  with commands such as `pub get`, `pub global activate`, `pub global run`,
  and `pub run`.

Other SDK tools that are handy for script and server development include:

* [`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer):
  Statically analyzes code, helping you catch errors early.
* [`dartfmt`](https://github.com/dart-lang/dart_style#readme):
  Applies style guidelines to Dart code.
* [`dartdoc`](https://github.com/dart-lang/dartdoc#dartdoc):
  Generates API reference documentation.

For more information, including tools outside the Dart SDK, see
[Dart Tools](/tools).
