---
title: dart compile
description: Command-line tool for AOT-compiling Dart source code.
---

Use the `dart compile` command to AOT (ahead-of-time) compile
a Dart program to a [target platform](/platforms).
The output — which you specify using a subcommand —
can either include a Dart runtime or be a _snapshot_.

Here's an example of using the `exe` subcommand
to produce a self-contained executable file (`myapp.exe`):

```terminal
$ dart compile exe bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.exe
```

The next example uses the `aot-snapshot` subcommand to
produce a snapshot (`myapp.aot`).
It then uses the [`dartaotruntime` command][] (which provides a Dart runtime)
to run the snapshot:

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

[`dartaotruntime` command]: /tools/dartaotruntime

To specify the path to the output file,
use the `-o` or `--output` option:

```terminal
$ dart compile exe bin/myapp.dart -o bin/runme
```

For more options and usage information,
run `dart compile [<subcommand>] --help`:

```terminal
$ dart compile exe --help
```

The `dart compile` command replaces the
`dart2native`, `dart2aot`, and `dart2js` commands.

{{site.alert.note}}
  You don't need to AOT compile Dart programs before running them.
  The Dart VM has a JIT (just-in-time) compiler
  that's especially useful during development.
  For more information on AOT and JIT compilation,
  see the [Platforms page](/platforms).
{{site.alert.end}}


## Types of output

The following table shows the subcommands of `dart compile`.

<table class="table table-striped nowrap">
  <tr>
    <th> Subcommand </th> <th> Output </th> <th> More information </th>
  </tr>
  <tr>
    <td style="white-space: nowrap"> <code>aot-snapshot</code> </td>
    <td style="white-space: nowrap"> AOT snapshot </td>
    <td> An architecture-specific file with <b>no Dart runtime</b>.
      <a href="#aot-snapshot">Learn more.</a>
    </td>
  </tr>
  <tr>
    <td> <code>exe</code> </td>
    <td> <span style="white-space: nowrap">Self-contained</span> executable </td>
    <td> A standalone, architecture-specific executable file.
      <a href="#exe">Learn more.</a>
    </td>
  </tr>
  <tr>
    <td> <code>jit-snapshot</code> </td>
    <td> JIT snapshot </td>
    <td> An architecture-specific file with
      parsed classes and compiled code that's generated during
      a training run of the program.
      <a href="#jit-snapshot">Learn more.</a>
    </td>
  </tr>
  <tr>
    <td> <code>js</code> </td>
    <td> JavaScript </td>
    <td> A deployable JavaScript file. ***[PENDING: check]***
      <a href="#js">Learn more.</a>
    </td>
  </tr>
  <tr>
    <td> <code>kernel</code> </td>
    <td> Kernel snapshot </td>
    <td> A portable
      <a href="https://github.com/dart-lang/sdk/blob/master/pkg/kernel/binary.md">binary snapshot</a>.
      <a href="#kernel">Learn more.</a>
    </td>
  </tr>
</table>


## AOT snapshots (aot-snapshot) {#aot-snapshot}

Use AOT snapshots to reduce disk space requirements
when distributing multiple command-line apps.
The `aot-snapshot` subcommand produces an output file
that's specific to the current architecture.
For example, if you use macOS to create a `.aot` file,
then that file can run on macOS only.
AOT snapshots are supported on Windows, macOS, and Linux.

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

For more information, see
[`dartaotruntime`](/tools/dartaotruntime).


## Standalone executables (exe) {#exe}

The `exe` subcommand produces a standalone executable for
Windows, macOS, or Linux.
A **standalone executable** is native machine code that's compiled from
the specified Dart file and its dependencies,
plus a small Dart runtime that handles
type checking and garbage collection.

You can distribute and run the output file like you would
any other executable file:

```terminal
$ dart compile exe bin/myapp.dart -o /tmp/myapp
Generated: /tmp/myapp
$ cd /tmp
$ ./myapp
```

{{ site.alert.tip }}
  If you’re distributing multiple programs and disk space is limited,
  consider using [`aot-snapshot`](#aot-snapshot) instead of `exe`.
{{ site.alert.end }}


### Known limitations

The `exe` subcommand has some known limitations:

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
: For a complete list of the core libraries you can use,
  see the **All** and **AOT** entries in the
  [table of core Dart libraries](/guides/libraries).

[issue 28617]: https://github.com/dart-lang/sdk/issues/28617
[issue 39106]: https://github.com/dart-lang/sdk/issues/39106

{{site.alert.tip}}
  If one of these issues is important to you,
  let the Dart team know by adding a "thumbs up" to the issue.
{{site.alert.end}}

{% comment %}
  TODO: Get info from https://github.com/dart-lang/sdk/wiki/Snapshots

  kernel: 
      Use to package up an app into a single file and
      reduce startup time.

  jit:
      To run the program, use `dart run myapp.jit`.
{% endcomment %}


## JIT snapshots (jit-snapshot) {#jit-snapshot}

JIT snapshots include all the parsed classes and compiled code that's
generated during a training run of a program.

```terminal
$ dart compile jit-snapshot bin/myapp.dart
Compiling bin/myapp.dart to jit-snapshot file bin/myapp.jit.
Hello world!
$ dart run bin/myapp.jit
Hello world!
$
```

When running from an application snapshot,
the Dart VM doesn't need to parse or compile classes and functions that
were already used during the training run,
so the VM starts running user code sooner.

These snapshots are architecture specific,
unlike snapshots produced using the
[`kernel` subcommand](#kernel).

## JavaScript (js) {#js}

The `js` subcommand compiles Dart code to deployable JavaScript.
Another Dart-to-JavaScript compiler, [`dartdevc`][],
is for development use only.

You usually use the [`webdev` tool][webdev] instead of
directly using a Dart-to-JavaScript compiler.
The [`webdev build`][] command, by default,
produces the same output as `dart compile js`.
The [`webdev serve`][] command uses `dartdevc` by default, but you can switch
to it to `dart compile js` by using the `--release` flag.

The `js` subcommand replaces the `dart2js` command.
For more information, see the [`dart2js` documentation](/tools/dart2js).

[`dartdevc`]: /tools/dartdevc
[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve


## Portable snapshots (kernel) {#kernel}

Use the `kernel` subcommand to package up an app into a
single, portable file.
A kernel snapshot contains a binary form of the abstract syntax tree
([Kernel AST][]) for a Dart program.

Here's an example of creating and running a kernel snapshot:

```terminal
$ dart compile kernel bin/myapp.dart
Compiling bin/myapp.dart to kernel file bin/myapp.dill.
$ dart run bin/myapp.dill
```

Although kernel snapshots have reduced startup time compared to Dart code,
they can have much slower startup than architecture-specific AOT output formats.


[Kernel AST]: https://github.com/dart-lang/sdk/blob/master/pkg/kernel/README.md

[assert statements]: /guides/language/language-tour#assert
[static analysis]: /guides/language/analysis-options
[`String.fromEnvironment()` constructor]: https://api.dart.dev/stable/dart-core/String/String.fromEnvironment.html
