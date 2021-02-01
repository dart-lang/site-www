---
title: dart2native
description: Command-line tool for AOT-compiling Dart source code.
---

Use the `dart2native` command to AOT (ahead-of-time) compile
a Dart program to [native x64 machine code](/overview#native-platform).
The `dart2native` command is supported on Windows, macOS, and Linux.

{{site.alert.note}}
  To execute Dart code without AOT compiling it,
  use [`dart`, the standalone Dart VM](/tools/dart-vm).
{{site.alert.end}}

The output of `dart2native` is either
a standalone executable (the default)
or an AOT snapshot that you can run with the [`dartaotruntime` command][].
A **standalone executable** is native machine code that's compiled from
the specified Dart file and its dependencies,
plus a small Dart runtime that handles
type checking and garbage collection.

An **AOT snapshot** doesn't include the Dart runtime.
Consider using snapshots if you're distributing multiple programs
and disk space is limited.


## Creating standalone executables

Here's an example of using `dart2native` to create a standalone executable:

```terminal
$ dart2native bin/main.dart -o bin/my_app
```

You can distribute and run that executable like you would
any other executable file:

```terminal
$ cp bin/my_app .
$ ./my_app
```


## Creating AOT snapshots

To create an AOT snapshot, add `-k aot` to the command:

```terminal
$ dart2native bin/main.dart -k aot
```

You can then run the app using the [`dartaotruntime` command][]:

```terminal
$ dartaotruntime bin/main.aot
```

## Known limitations

The initial (Dart 2.6) version of `dart2native` has some known limitations:

No cross-compilation support ([issue 28617][])
: The compiler supports creating machine code only for
  the operating system it’s running on.
  You need to run the compiler three times —
  on macOS, Windows, and Linux —
  to create executables for all three operating systems.
  A workaround is to use a CI (continuous integration) provider
  that supports all three operating systems.

No signing support ([issue 39106][])
: The format of the executables isn’t compatible with
  standard signing tools such as codesign and SignTool.

No support for dart:mirrors and dart:developer
: The code compiled by `dart2native` can use all of the other libraries
  that the Dart VM supports.
  For a complete list of the core libraries you can use,
  see the **All** and **AOT** entries in the
  [table of core Dart libraries](/guides/libraries).

[issue 28617]: https://github.com/dart-lang/sdk/issues/28617
[issue 39106]: https://github.com/dart-lang/sdk/issues/39106

{{site.alert.tip}}
  If one of these issues is important to you,
  let the Dart team know by adding a "thumbs up" to the issue.
{{site.alert.end}}


## Options

The first argument to `dart2native` is the path to the main Dart file:

```none
dart2native <main-dart-file> [<options>]
```

You can use the following options:

`-D <key>=<value>` or `--define=<key>=<value>`
: Defines an environment declaration,
  which can be read using the [`String.fromEnvironment()` constructor][].
  To specify multiple declarations, use multiple options or
  use commas to separate key-value pairs.

`--enable-asserts`
: Enables [assert statements][].

`-h` or `--help`
: Displays help for all options.

`-k (aot|exe)` or `--output-kind=(aot|exe)`
: Specifies the output type, where `exe` is the default
  (a standalone executable). To generate an AOT snapshot,
  use `-k aot`.

`-o <path>` or `--output=<path>`
: Generates the output into `<path>`. If you don't use this option,
  the output goes into a file next to the main Dart file.
  Standalone executables have the suffix `.exe`, by default;
  the AOT snapshot suffix is `.aot`.

`-p <path>` or `--packages=<path>`
: Specifies the path to the package resolution configuration file.
  For more information, see
  [Package Resolution Configuration File.](https://github.com/lrhn/dep-pkgspec/blob/master/DEP-pkgspec.md)

`-v` or `--verbose`
: Displays more information.

## dart2aot

Releases before Dart 2.6 contained
a tool named `dart2aot` that produced AOT snapshots.
The `dart2native` command replaces `dart2aot` and
has a superset of the `dart2aot` functionality.


[assert statements]: /guides/language/language-tour#assert
[`dartaotruntime` command]: /tools/dartaotruntime
[static analysis]: /guides/language/analysis-options
[`String.fromEnvironment()` constructor]: https://api.dart.dev/stable/dart-core/String/String.fromEnvironment.html
