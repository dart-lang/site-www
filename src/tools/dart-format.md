---
title: dart format
description: Command-line tool for formatting Dart source code.
toc: false
---

Use the `dart format` command to replace the whitespace in your program
with formatting that follows
[Dart guidelines](/guides/language/effective-dart/style#formatting).
This is the same formatting that you can get
when using an IDE or editor that has Dart support.

{% include tools/dart-tool-note.md %}

Provide a list of files or directories to the `dart format` command.
For example, here's how to format all the Dart files
under the current directory's `bin`, `lib`, and `test` directories:

```terminal
$ dart format bin lib test
```

{{ site.alert.warn }}
  By default, `dart format` **overwrites** the Dart files.
{{ site.alert.end }}

If you don't want to overwrite the files,
add the `-o` flag.
Use `-o show` or `-o json` to get the contents of the formatted files,
or `-o none` to see only which files would change.

```terminal
$ dart format -o show bin/my_app.dart
```

For information on additional command-line options,
use the `dart help` command or see the documentation for the
[dart_style package.]({{site.pub-pkg}}/dart_style)

```terminal
$ dart help format
```

The `dart format` command replaces `dartfmt`.

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
