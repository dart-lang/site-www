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

:::note
To run use the `dartaotruntime` command,
add the path to your Dart `bin` directory to your `PATH` environment variable.
:::

[dart compile]: /tools/dart-compile

## Review an example

Here's an example of creating and running an AOT snapshot:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

```console
Generated: /Users/me/simpleapp/bin/myapp.aot
```

```console
$ dartaotruntime bin/simpleapp.aot
```

## Learn more options

To learn more about command-line options, use the `--help` flag:

```console
$ dartaotruntime --help
```
