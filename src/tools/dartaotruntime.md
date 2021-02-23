---
title: dartaotruntime
description: Command-line tool for running AOT-compiled snapshots of Dart code.
toc: false
---

Use the `dartaotruntime` command to run AOT (ahead-of-time) compiled programs
called **AOT snapshots**.
This tool is supported on Windows, macOS, and Linux.
To produce AOT snapshots, use the `aot-snapshot` subcommand of the
[`dart compile` command][dart compile].

[dart compile]: /tools/dart-compile

Here's an example of creating and running an AOT snapshot:

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/simpleapp/bin/myapp.aot
$ dartaotruntime bin/simpleapp.aot
```

For information on command-line options, use the `--help` flag:

```terminal
$ dartaotruntime --help
```

