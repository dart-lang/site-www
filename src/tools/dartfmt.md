---
title: dartfmt
description: Command-line tool for formatting Dart source code.
toc: false
---

Use the `dartfmt` command to replace the whitespace in your program
with formatting that follows
[Dart guidelines](/guides/language/effective-dart/style#formatting).
This is the same formatting that you can get
when using an IDE or editor that has Dart support.

Provide a list of files or directories to the `dartfmt` command.
For example, here's how to format all the Dart files
under the current directory's `bin`, `lib`, and `test` directories:

```terminal
$ dartfmt -w bin lib test
```

If you don't want to overwrite the files,
omit the `-w` option.
The resulting source code is displayed to standard output.

```terminal
$ dartfmt bin/main.dart
import 'package:my_app/my_app.dart' as my_app;

main(List<String> arguments) {
  print('Hello world: ${my_app.calculate()}!');
}
$
```

For information on additional command-line options,
use the `--help` flag or see the documentation for the
[dart_style package.]({{site.pub-pkg}}/dart_style)

```terminal
$ dartfmt --help
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
