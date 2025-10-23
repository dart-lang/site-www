---
title: "dart: The Dart command-line tool"
shortTitle: Dart CLI
description: >-
  Learn about the 'dart' CLI and its available subcommands.
---

The `dart` tool is the command-line interface to the [Dart SDK][].
The tool is available no matter how you get the Dart SDK—whether
you download the Dart SDK explicitly
or download only the [Flutter SDK][].

[Dart SDK]: /tools/sdk
[Flutter SDK]: {{site.flutter}}

## Usage example

Here's how you might use the `dart` tool
to create, analyze, test, and run an app:

```console
$ dart create -t console my_app
$ cd my_app
$ dart analyze
$ dart test
$ dart run bin/my_app.dart
```

You can also run [`pub` commands][pub] using the `dart` tool:

```console
$ dart pub get
$ dart pub outdated
$ dart pub upgrade
```

## Available commands

The following table shows which commands you can use with the `dart` tool.

| Command    | Format of command                                      | More information                                                                                         |
|------------|--------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `analyze`  | <code>dart analyze [<DIRECTORY&#124;DART_FILE>]</code> | Analyzes the project's Dart source code.<br>[Learn more.][analyze]                                       |
| `build`    | `dart build <APP_TYPE>`                                | Builds a Dart app including [code assets][].<br>[Learn more.][build]               |
| `compile`  | `dart compile <FORMAT>`                                | Compiles Dart to various formats (native executable, JavaScript, WebAssembly).<br>[Learn more.][compile] |
| `create`   | `dart create <DIRECTORY>`                              | Creates a new project.<br>[Learn more.][create]                                                          |
| `devtools` | `dart devtools`                                        | Opens Dart DevTools, a suite of debugging and performance tools for Dart.<br>[Learn more.][devtools]     |
| `doc`      | `dart doc <DIRECTORY>`                                 | Generates API reference documentation.<br>[Learn more.][doc]                                             |
| `fix`      | <code>dart fix <DIRECTORY&#124;DART_FILE></code>       | Applies automated fixes to Dart source code.<br>[Learn more.][fix]                                       |
| `format`   | <code>dart format <DIRECTORY&#124;DART_FILE></code>    | Formats Dart source code.<br>[Learn more.][format]                                                       |
| `info`     | `dart info`                                            | Outputs Dart tooling diagnostic information.<br>[Learn more.][info]                                      |
| `pub`      | `dart pub <PUB_COMMAND>`                               | Works with packages.<br>Replaces `pub`.<br>[Learn more.][pub]                                            |
| `run`      | `dart run <DART_FILE>`                                 | Runs a Dart program.<br>[Learn more.][run]                                                               |
| `test`     | <code>dart test <DIRECTORY&#124;DART_FILE></code>      | Runs tests in this package.<br>[Learn more.][test]                                                       |
| _(none)_   | `dart <DART_FILE>`                                     | Runs a Dart program.<br>Prefer [`dart run`][run].                                                        |

{:.table .table-striped .nowrap}

[code assets]: /tools/hooks#assets

[analyze]: /tools/dart-analyze
[build]: /tools/dart-build
[compile]: /tools/dart-compile
[create]: /tools/dart-create
[devtools]: /tools/dart-devtools
[doc]: /tools/dart-doc
[fix]: /tools/dart-fix
[format]: /tools/dart-format
[info]: /tools/dart-info
[pub]: /tools/pub/cmd
[run]: /tools/dart-run
[test]: /tools/dart-test

## Learn more

To get help with any of the commands, run `dart help <command>`.
You can also get details on `pub` commands.

```console
$ dart help pub outdated
```
