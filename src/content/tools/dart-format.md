---
title: dart format
description: Command-line tool for formatting Dart source code.
toc: false
---

Use the `dart format` command to replace the whitespace in your program
with formatting that follows
[Dart guidelines](/effective-dart/style#formatting).
This is the same formatting that you can get
when using an IDE or editor that has Dart support.

{% render 'tools/dart-tool-note.md' %}

Provide a list of files or directories to the `dart format` command.
For example, here's how to format all the Dart files
in or under the current directory:

```console
$ dart format .
```

To specify multiple files or directories,
use a space-delimited list.
The following command formats all Dart files under the `lib` directory,
plus one Dart file under the `bin` directory:

```console
$ dart format lib bin/updater.dart 
```

:::warning Notice
By default, `dart format` **overwrites** the Dart files.
:::

If you don't want to overwrite the files,
add the `--output` or `-o` flag.
Use `-o show` or `-o json` to get the contents of the formatted files,
or `-o none` to see only which files would change.

```console
$ dart format -o show bin/my_app.dart
```

To make the command have an exit code of `1`
if any formatting changes occur,
add the `--set-exit-if-changed` flag.
This exit code is often used with continuous integration (CI)
to indicate that a check should fail.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

For information on additional command-line options,
use the `dart help` command or see the documentation for the
[dart_style package.]({{site.pub-pkg}}/dart_style)

```console
$ dart help format
```

:::tip
To avoid making changes that might be unsafe,
`dart format` only affects whitespace.

There's a lot more to writing readable and
consistent code than just whitespace, though.
To learn more about best practices for writing and styling Dart code,
check out the [Dart style guide][].
:::

[Dart style guide]: /effective-dart/style
