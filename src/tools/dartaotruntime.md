---
title: dartaotruntime
description: Command-line tool for running AOT-compiled snapshots of Dart code.
toc: false
---

With Dart, you can create pre-compiled Dart applications called *AOT snapshots*.

## Create AOT snapshot app

To produce AOT snapshots, use the `aot-snapshot` subcommand of the
[`dart compile` command][dart compile].

## Run AOT snapshot app

To run AOT programs, use the `dartaotruntime` command.
This tool supports Windows, macOS, and Linux.

{{site.alert.note}}
  To run use the `dartaotruntime` command,
  add the path to your Dart `bin` directory to your `PATH` environment variable.
{{site.alert.end}}

[dart compile]: /tools/dart-compile

## Review an example

Here's an example of creating and running an AOT snapshot:

```terminal
$ dart compile aot-snapshot bin/myapp.dart
```

```terminal
Generated: /Users/me/simpleapp/bin/myapp.aot
```

```terminal
$ dartaotruntime bin/simpleapp.aot
```

## Learn more options

To learn more about command-line options, use the `--help` flag:

```terminal
$ dartaotruntime --help
```
