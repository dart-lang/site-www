---
title: dart2aot
description: Command-line tool for AOT-compiling Dart source code.
toc: false
---

Use the `dart2aot` command to AOT (ahead-of-time) compile a Dart program to
native x86 machine code. The tool is supported on Windows, macOSm, and Linux.

Provide the file name of the main entrypoint of the program (typically
`main.dart`) and the file name where the tool should should write the compiled
code, for example:

```terminal
$ dart2aot main.dart main.dart.aot
```

After compilation, the compiled program can be run with the `dartaotruntime`
command (see [Dart platforms](/platforms) for details):

```terminal
$ dartaotruntime main.dart.aot
Hello from Dart.
```