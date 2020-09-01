---
title: The Dart VM
description: "The reference page for using 'dart' to run command-line apps."
---

You can use the _dart_ tool (`bin/dart`) to run Dart command-line apps such as
server-side scripts, programs, and servers.

{{ site.alert.version-note }}
  As of Dart 2.10, the `dart` command has more functionality
  than just running the Dart VM.
  For details, see [the `dart` tool page][dart-tool].
{{ site.alert.end }}

[dart-tool]: /tools/dart-tool


## Basic usage

Here’s an example of running a Dart file on the command line:

```terminal
$ dart --enable-asserts test.dart
```

<aside class="alert alert-info" markdown="1">
**Note:** You can't use `dart` to run mobile apps or web apps
(apps that include `dart:html`, or that depend on libraries
that use the browser environment).
</aside>

## Options

Common command-line options for dart include:

`--enable-asserts`
: Enables `assert` statements. When asserts are enabled, an
  [assert statement](/guides/language/language-tour#assert)
  checks a boolean condition, raising an exception if the condition is false.

`--packages=<path>`
: Specifies the path to the
  [package resolution configuration file.](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md)
  _This option cannot be used with `--package-root`._

`--version`
: Displays VM version information.

`-h` or `--help`
: Displays help. (Add `-v` for information about all options.)
