---
title: dart compile
description: Command-line tool for compiling Dart source code.
---

Use the `dart compile` command to compile
a Dart program to a [target platform](/platforms).
The output—which you specify using a subcommand—can 
either include a [Dart runtime][] or be a _module_
(also known as a _snapshot_).

{% include tools/dart-tool-note.md %}

Here's an example of using the `exe` subcommand
to produce a self-contained executable file (`myapp.exe`):

```terminal
$ dart compile exe bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.exe
```

The next example uses the `aot-snapshot` subcommand to
produce an ahead-of-time (AOT) compiled module (`myapp.aot`).
It then uses the [`dartaotruntime` command](/tools/dartaotruntime)
(which provides a [Dart runtime][])
to run the AOT module:

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

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
  You don't need to compile Dart programs before running them.
  Instead, you can use the [`dart run` command][dart-run],
  which uses the Dart VM's JIT (just-in-time) compiler—a 
  feature that's especially useful during development.
  For more information on AOT and JIT compilation,
  see the [platforms discussion](/overview#platform).
{{site.alert.end}}

Refer to the [native_app][] sample for a simple example of using `dart compile`
to compile a native app, 
followed by examples of running the app.

[native_app]: https://github.com/dart-lang/samples/tree/master/native_app
[dart-run]: /tools/dart-run

## Subcommands

The following table shows the subcommands of `dart compile`.

<table class="table table-striped nowrap">
  <tr>
    <th> Subcommand </th> <th> Output </th> <th> More information </th>
  </tr>
  <tr>
    <td> <code>exe</code> </td>
    <td> <span style="white-space: nowrap">Self-contained</span> executable </td>
    <td> A standalone, architecture-specific executable file containing the source code
      compiled to machine code and a small <a href="/overview#runtime">Dart runtime</a>.
      <br><em><a href="#exe">Learn more.</a></em>
    </td>
  </tr>
  <tr>
    <td style="white-space: nowrap"> <code>aot-snapshot</code> </td>
    <td style="white-space: nowrap"> AOT module </td>
    <td> An architecture-specific file containing the source code
      compiled to machine code, but <b>no Dart runtime</b>.
      <br><em><a href="#aot-snapshot">Learn more.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>jit-snapshot</code> </td>
    <td> JIT module </td>
    <td> An architecture-specific file with
      an intermediate representation of all source code,
      plus an optimized representation of the source code
      that executed during a training run of the program.
      JIT-compiled code can have faster peak performance than AOT code
      if the training data is good.
      <br><em><a href="#jit-snapshot">Learn more.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>kernel</code> </td>
    <td> Kernel module </td>
    <td> A portable,
      <a href="https://github.com/dart-lang/sdk/blob/main/pkg/kernel/binary.md">intermediate representation</a>
      of the source code.
      <br><em><a href="#kernel">Learn more.</a></em>
    </td>
  </tr>
  <tr>
    <td> <code>js</code> </td>
    <td> JavaScript </td>
    <td> A deployable JavaScript file, 
      compiled from the source code.
      <br><em><a href="#js">Learn more.</a></em>
    </td>
  </tr>
</table>


## Types of output

The following sections have details about each type of output
that `dart compile` can produce.


### Self-contained executables (exe) {#exe}

The `exe` subcommand produces a standalone executable for
Windows, macOS, or Linux.
A **standalone executable** is native machine code that's compiled from
the specified Dart file and its dependencies,
plus a small [Dart runtime][] that handles
type checking and garbage collection.

You can distribute and run the output file like you would
any other executable file:

```terminal
$ dart compile exe bin/myapp.dart -o /tmp/myapp
Generated: /tmp/myapp
$ cd /tmp
$ ./myapp
```

#### Signing

Executables created with `dart compile exe`
support signing on macOS and Windows.

For detailed documentation,
see the platform documentation for those operating systems,
such as the Windows [`SignTool.exe` documentation][],
and the [Apple Code Signing guide][].

[`SignTool.exe` documentation]: https://docs.microsoft.com/dotnet/framework/tools/signtool-exe
[Apple Code Signing guide]: https://developer.apple.com/support/code-signing/

#### Known limitations

The `exe` and `aot-snapshot` subcommands have some known limitations:

No cross-compilation support ([issue 28617][])
: The compiler supports creating machine code only for
  the operating system it’s running on.
  You need to run the compiler three times—on macOS, Windows, and Linux—to 
  create executables for all three operating systems.
  A workaround is to use a CI (continuous integration) provider
  that supports all three operating systems.

No support for `dart:mirrors` and `dart:developer`
: For a complete list of the core libraries you can use,
  see the **All** and **AOT** entries in the
  [table of core Dart libraries](/guides/libraries).

[issue 28617]: https://github.com/dart-lang/sdk/issues/28617
[issue 39106]: https://github.com/dart-lang/sdk/issues/39106

{{site.alert.tip}}
  If one of these issues is important to you,
  let the Dart team know by adding a "thumbs up" to the issue.
{{site.alert.end}}


### AOT modules (aot-snapshot) {#aot-snapshot}

Use AOT modules to reduce disk space requirements
when distributing multiple command-line apps.
The `aot-snapshot` subcommand produces an output file
that's specific to the current architecture.
For example, if you use macOS to create a `.aot` file,
then that file can run on macOS only.
AOT modules are supported on Windows, macOS, and Linux.

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

For more information, see
[Known limitations](#known-limitations) and the
[`dartaotruntime` documentation](/tools/dartaotruntime).


{% comment %}
  TODO: Get info from https://github.com/dart-lang/sdk/wiki/Snapshots
{% endcomment %}


### JIT modules (jit-snapshot) {#jit-snapshot}

JIT modules include all the parsed classes and compiled code that's
generated during a training run of a program.

```terminal
$ dart compile jit-snapshot bin/myapp.dart
Compiling bin/myapp.dart to jit-snapshot file bin/myapp.jit.
Hello world!
$ dart run bin/myapp.jit
Hello world!
```

When running from an application module,
the Dart VM doesn't need to parse or compile classes and functions that
were already used during the training run,
so the VM starts running user code sooner.

These modules are architecture specific,
unlike modules produced using the
[`kernel` subcommand](#kernel).


### Portable modules (kernel) {#kernel}

Use the `kernel` subcommand to package up an app into a
single, portable file that
can be run on all operating systems and CPU architectures.
A kernel module contains a binary form of the abstract syntax tree
([Kernel AST][]) for a Dart program.

Here's an example of creating and running a kernel module:

```terminal
$ dart compile kernel bin/myapp.dart
Compiling bin/myapp.dart to kernel file bin/myapp.dill.
$ dart run bin/myapp.dill
```

Although kernel modules have reduced startup time compared to Dart code,
they can have much slower startup than architecture-specific AOT output formats.

[Kernel AST]: https://github.com/dart-lang/sdk/blob/main/pkg/kernel/README.md


### JavaScript (js) {#js}

The `js` subcommand compiles Dart code to deployable JavaScript.

Here's an example of compiling a Dart application to JavaScript
with many optimizations enabled:

```terminal
$ dart compile js -02 -o out/main.js web/main.dart
```

For more information on configuring the compiler, 
see the [dart2js compiler options](/tools/dart2js#options).

{{site.alert.note}}
  You usually use the [`webdev` tool][webdev] instead of
  directly using a Dart-to-JavaScript compiler.
  The [`webdev build`][] command, by default,
  also produces deployable JavaScript.
  The [`webdev serve`][] command, by default,
  uses [dartdevc][] to compile web apps
  for running and debugging during development.
{{site.alert.end}}

To learn more about building and deploying JavaScript applications,
check out [Web deployment](/web/deployment).

[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve
[Dart runtime]: /overview#runtime
[dartdevc]: /tools/dartdevc
