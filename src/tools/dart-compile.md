---
title: dart compile
description: Command-line tool for compiling Dart source code.
---

Use the `dart compile` command to compile
a Dart program to a [target platform](/overview#platform).
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

[native_app]: https://github.com/dart-lang/samples/tree/main/native_app
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
any other executable file.

Compile your app and set the output file.

```terminal
$ dart compile exe bin/myapp.dart -o /tmp/myapp
```

When successful, this command returns the following.
```terminal
Generated: /tmp/myapp
```

Run your compiled app from the `/tmp` directory.
```terminal
$ ./tmp/myapp
```

#### Signing

Executables created with `dart compile exe`
support signing on macOS and Windows.

To learn more about platform-specific code signing,
see the platform documentation for those operating systems:

* Windows [`SignTool.exe` documentation][]
* [Apple Code Signing guide][]

[`SignTool.exe` documentation]: https://docs.microsoft.com/dotnet/framework/tools/signtool-exe
[Apple Code Signing guide]: https://developer.apple.com/support/code-signing/

#### Known limitations

The `exe` subcommand has some known limitations:

{% include known-issues/compile-ki.md %}

### AOT modules (aot-snapshot) {#aot-snapshot}

Use AOT modules to reduce disk space requirements when distributing
multiple command-line apps. The `aot-snapshot` subcommand produces an
output file specific to the current architecture on which you compile
your app.

For example, if you use macOS to create a `.aot` file,
then that file can run on macOS only.
Dart supports AOT modules on Windows, macOS, and Linux.

```terminal
$ dart compile aot-snapshot bin/myapp.dart
Generated: /Users/me/myapp/bin/myapp.aot
$ dartaotruntime bin/myapp.aot
```

The `aot-snapshot` subcommand has some known limitations.

{% include known-issues/compile-ki.md %}

To learn more, see the
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

{{site.alert.note}}
  Use the [`webdev` tool][webdev] rather than running the 
  Dart-to-JavaScript compiler.

  * The [`webdev build`][] command, by default, produces minified, deployable JavaScript.

  * The [`webdev serve`][] command, by default, produces JavaScript
    modules for running and debugging during development.
{{site.alert.end}}

{% include tools/dart-compile-js-options.md %}

#### Compiling web app example

For example, to compile a Dart application to optimized JavaScript, run
the following command:

```terminal
$ dart compile js -O2 -o out/main.js web/main.dart
```


#### Improving production web compiliation {#helping-generate-efficient-code}

Follow these practices to improve type inference, reduce file size, and
improve JavaScript performance:

* Don't use `Function.apply()`.
* Don't override `noSuchMethod()`.
* Avoid setting variables to `null`.
* Be consistent with the types of arguments
  you pass into each function or method.

{{site.alert.tip}}
  Don't worry about the size of your app's included libraries. 
  The production compiler performs tree shaking to omit
  unused classes, functions, methods, and so on.
  Import the libraries you think you'll need, 
  and let the compiler get rid of what it doesn't need.
{{site.alert.end}}

To learn more about building and deploying JavaScript applications,
check out [Web deployment](/web/deployment).

[webdev]: /tools/webdev
[`webdev build`]: /tools/webdev#build
[`webdev serve`]: /tools/webdev#serve
[Dart runtime]: /overview#runtime
