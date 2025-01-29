---
title: dart format
description: Command-line tool for formatting Dart source code.
---

To update your code to follow the
[Dart formatting guidelines][dart-guidelines],
use the `dart format` command.
This formatting follows what you get
when using an IDE or editor with Dart support.

{% render 'tools/dart-tool-note.md' %}

## Specify files to format

To reformat one or more Dart files,
provide a list of paths to the desired files or directories.

### Specify one path

Provide the path to one file or directory.
If you pass a directory path,
`dart format` recurses into its subdirectories as well.

**Example:** To format all the Dart files in or under the current directory:

```console
$ dart format .
```

### Specify multiple paths

To specify multiple files or directories, use a space-delimited list.

**Example:** To format all Dart files under the `lib` directory,
plus one Dart file under the `bin` directory:

```console
$ dart format lib bin/updater.dart 
```

### Prevent overwriting Dart files

By default, `dart format` **overwrites** the Dart files.

* To not overwrite the files, add the `--output` or `-o` flag.
* To get the contents of the formatted files, add `-o show` or `-o json`.
* To see only which files _would_ change, add `-o none`.

```console
$ dart format -o show bin/my_app.dart
```

## Notify when changes occur

To make `dart format` return an exit code when formatting changes occur,
add the `--set-exit-if-changed` flag.

* If changes occur, the `dart format` command returns an exit code of `1`.
* If changes don't occur, the `dart format` command returns an exit code of `0`.

Use exit codes with continuous integration (CI) systems
so they can trigger another action in response to the exit code.

```console
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

## What changes?

`dart format` removes whitespace,
wraps every line to 80 characters long or shorter,
adds trailing commas to any argument or parameter list
that splits across multiple lines and removes them from ones that don't, 
and might move comments before or after a comma. 

To learn more about best practices for writing and styling Dart code,
check out the [Dart style guide][].

## Learn more

To learn about additional command-line options,
use the `dart help` command or see the documentation for the
[dart_style package][dart_style]

```console
$ dart help format
```

Check out the [formatter FAQ][] for more context behind formatting decisions.

[Dart style guide]: /effective-dart/style
[dart_style]: {{site.pub-pkg}}/dart_style
[dart-guidelines]: /effective-dart/style#formatting
[formatter FAQ]: {{site.repo.dart.org}}/dart_style/wiki/FAQ
