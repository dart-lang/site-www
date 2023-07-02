---
title: dart analyze
description: Command-line tool for static analysis
toc: false
---

The `dart analyze` command
performs the same [static analysis][]
that you get when you use an IDE or editor that has Dart support.

{% include tools/dart-tool-note.md %}

Here's an example of performing static analysis over all the Dart files
under the current directory:

```terminal
$ dart analyze
```

You can customize how the analyzer treats warnings and info-level issues.
Normally the analyzer reports failure when it finds any errors or warnings,
but not when it finds info-level issues.
You can customize this behavior using the
`--fatal-infos` and `--no-fatal-warnings` flags.
For example, to make the analyzer fail when any issue is 
the `--fatal-infos` flag:

```terminal
$ dart analyze --fatal-infos
```

You can add a directory or a single file argument:

```terminal
$ dart analyze [<DIRECTORY> | <DART_FILE>]
```

For example, here's the command to analyze the `bin` directory:

```terminal
$ dart analyze bin
```

{{site.alert.version-note}}
  Before Dart 2.13, `dart analyze` supported only directory arguments.
{{site.alert.end}}

To customize the analysis, use an analysis options file
or special comments in Dart source code,
as described in [Customizing static analysis][static analysis].

For information on command-line options, use the `--help` flag:

```terminal
$ dart analyze --help
```

[static analysis]: /tools/analysis

{% comment %}
```
Usage: dart analyze [arguments] [<directory>]
-h, --help                   Print this usage information.
    --fatal-infos            Treat info level issues as fatal.
    --[no-]fatal-warnings    Treat warning level issues as fatal.
                             (defaults to on)
```
{% endcomment %}
