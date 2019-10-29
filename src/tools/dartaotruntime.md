---
title: dartaotruntime
description: Command-line tool for running AOT-compiled snapshots of Dart code.
toc: false
---

Use the `dartaotruntime` command to run AOT (ahead-of-time) compiled programs,
called **AOT snapshots**.
This tool is supported on Windows, macOS, and Linux.

To produce AOT snapshots, use the [`dart2native` command](/tools/dart2native).

Here's an example of using `dartaotruntime`
to run an AOT snapshot named `main.aot`:

```terminal
$ dartaotruntime main.aot
Hello from Dart.
```

For information on command-line options, use the `--help` flag:

```terminal
$ dartaotruntime --help
```
