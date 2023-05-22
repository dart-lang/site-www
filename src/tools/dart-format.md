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

{% include tools/dart-tool-note.md %}

Provide a list of files or directories to the `dart format` command.
For example, here's how to format all the Dart files
in or under the current directory:

```terminal
$ dart format .
```

To specify multiple files or directories,
use a space-delimited list.
The following command formats all Dart files under the `lib` directory,
plus one Dart file under the `bin` directory:

```terminal
$ dart format lib bin/updater.dart 
```

{{site.alert.warn}}
  By default, `dart format` **overwrites** the Dart files.
{{site.alert.end}}

If you don't want to overwrite the files,
add the `--output` or `-o` flag.
Use `-o show` or `-o json` to get the contents of the formatted files,
or `-o none` to see only which files would change.

```terminal
$ dart format -o show bin/my_app.dart
```

To make the command have an exit code of `1`
if any formatting changes occur,
add the `--set-exit-if-changed` flag.
This exit code is often used with continuous integration (CI)
to indicate that a check should fail.

```terminal
$ dart format -o none --set-exit-if-changed bin/my_app.dart
```

For information on additional command-line options,
use the `dart help` command or see the documentation for the
[dart_style package.]({{site.pub-pkg}}/dart_style)

```terminal
$ dart help format
```

{% comment %}
[PENDING: Add info on commonly used options.]

[PENDING: Advocate using this! Perhaps steal the first paragraph from
dart_style's readme:

The dart_style package defines an automatic, opinionated formatter
for Dart code. It replaces the whitespace in your program with what
it deems to be the best formatting for it. Resulting code should
follow the Dart style guide and, more importantly, should look nice
to most human readers, most of the time.]
{% endcomment %}
