---
title: dart analyze
description: Command-line tool for static analysis
toc: false
---

The `dart analyze` command (previously called `dartanalyzer`)
performs the same [static analysis][]
that you get when you use an IDE or editor that has Dart support.

Here's an example of performing static analysis over all the Dart files
under the current directory:

```terminal
$ dart analyze
```

You can add a directory argument:

```terminal
$ dart analyze bin
```

To customize the analysis, use an analysis options file
or special comments in Dart source code,
as described in [Customizing static analysis][static analysis].

For information on command-line options, use the `--help` flag:

```terminal
$ dart analyze --help
```

[static analysis]: /guides/language/analysis-options

{% comment %}
```
Usage: dart analyze [arguments] [<directory>]
-h, --help                   Print this usage information.
    --fatal-infos            Treat info level issues as fatal.
    --[no-]fatal-warnings    Treat warning level issues as fatal.
                             (defaults to on)
```
{% endcomment %}
