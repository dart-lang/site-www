---
title: dart2native
description: Command-line tool for AOT-compiling Dart source code.
---

Use the `dart2native` command to AOT (ahead-of-time) compile
a Dart program to native x64 machine code.
The output of `dart2native` is either
a **standalone executable** (the default)
or an **AOT snapshot** that you can run with the [`dartaotruntime` command][].
The `dart2native` command is supported on Windows, macOS, and Linux.

Here's an example of using `dart2native` to create a standalone executable:

```terminal
$ dart2native bin/main.dart -o bin/my_app
```

You can distribute and run that executable like you would
any other executable file:

```terminal
$ cp bin/my_app ~/bin
$ my_app
```

Each standalone executable has its own copy of the Dart VM.
If space is an issue and you need to distribute multiple AOT-compiled apps,
consider creating AOT snapshots instead.

{{site.alert.note}}
  To execute Dart code without AOT compiling it,
  use [`dart`, the standalone Dart VM](/tools/dart-vm).
{{site.alert.end}}


## Creating AOT snapshots

To create an AOT snapshot, add `-k aot` to the command:

```terminal
$ dart2native bin/main.dart -k aot
```

You can then run the app using the [`dartaotruntime` command][]:

```terminal
$ dartaotruntime bin/main.aot
```

For more information, see [Dart platforms](/platforms).


## Options

The first argument to `dart2native` is the path to the main Dart file:

```none
dart2native <main-dart-file> [<options>]
```

You can use the following options:

`-D <key>=<value>` or `--define=<key>=<value>`
: Defines an environment variable.
  To specify multiple variables, use multiple options or
  use commas to separate key-value pairs.

`--enable-asserts`
: Enables [assert statements][].

`-h` or `--help`
: Displays help for all options.

`-o <path>` or `--output=<path>`
: Generates the output into `<path>`. If you don't use this option,
  the output goes into a file next to the main Dart file.
  Standalone executables have an `.exe` suffix by default;
  AOT snapshots have `.aot`.

`-p <path>` or `--packages=<path>`
: Specifies the path to the package resolution configuration file.
  For more information, see
  [Package Resolution Configuration File.](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md)

`-v` or `--verbose`
: Displays more information.

[assert statements]: /guides/language/language-tour#assert
[`dartaotruntime` command]: /tools/dartaotruntime
[static analysis]: /guides/language/analysis-options