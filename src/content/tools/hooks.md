---
title: Hooks
description: Run custom build scripts.
---

:::note
Hooks are currently in preview.
:::

This guide explains how to use the `hooks` and
`hooks_runner` packages to run custom build scripts for your
Dart projects.

## Introduction

The hooks package provides a framework for creating hooks.
Currently, build hooks are supported. A build hook is a Dart
script that runs during your project's build process. This
is useful for tasks that need to happen before your
main application code is compiled, such as:

  * Compiling C, C++, Rust, or other native code into a
    dynamic library.

  * Generating Dart code based on native headers
    (for example, using `ffigen`).

  * Downloading or generating other assets required at
    runtime.

### Hooks

The `hooks` package defines the API and data structures for
your build scripts. For example, the build function and
BuildConfig.

### Hooks runner

While the `hooks` package provides the API and structure for
writing a hook, `hooks_runner` is the command-line tool
that:

1. Discovers your hooks.
2. Executes them.
3. Provides them with necessary configurations.

### Assets

Assets are the files that hooks create, which are then used
by your application or other packages. An asset is typically
a compiled piece of native code.

## Add a build hook to your package

Follow the steps in this section to add a build hook to your
package.

### Add dependencies

First, add `hooks` and `hooks_runner` as a `dev_dependencies`
in your `pubspec.yaml` file. You will also likely need a
tool for your specific task, such as `native_toolchain_c`
for compiling C code.

```yaml title="pubspec.yaml"
name: my_awesome_package
description: A package that uses build hooks.
version: 1.0.0

environment:
  sdk: '>=3.9.0-0 <4.0.0'

dev_dependencies:
  hooks: ^0.20.0
  hooks_runner: ^0.1.0 # Replace with the latest version
  native_toolchain_c: ^0.1.0 # Example for C compilation
 ```

### Configure the hooks runner

Next, you need to tell `hooks_runner` where your
build script is. Create a top-level `hooks_runner` key in
your `pubspec.yaml` and point to your hook script(s).
This configuration tells the runner to execute the
`lib/build.dart` script when the build hook is triggered.

```yaml title="pubspec.yaml"
# ... (previous sections)

hooks_runner:
  hooks:
    - build: lib/build.dart
```

### Create the build hook script

Create the Dart file you referenced in `pubspec.yaml`
(for example, `lib/build.dart`).

Your script must have a main method that calls the
`build` function from `package:hooks/hooks.dart`.
This function handles all the boilerplate of parsing
arguments and setting up the build environment.

The `build` function requires a callback that contains your
custom logic: 

```dart title="lib/build.dart"
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
// Import a helper for your specific task.
import 'package:native_toolchain_c/native_toolchain_c.dart';

Future<void> main(List<String> args) async {
  await build(input, output) async {
    // Your build logic goes here.
  });
}
```

* `input`: The input for `lib/build.dart`. This can include
  assets, configurations, a hash code, the output file to
  write, the runtime type, and more. For details, see
  the [`BuildInput` class][].

* `output`: The output for `lib/build.dart`. This can
  include assets, the hash code from the input, the
  runtime type, and more. For details, see the
  [`BuildOutputBuilder` class][].

### Example: Compiling a C Library

This example shows how to use `CBuilder` from
`package:native_toolchain_c` to compile a C file
and report the resulting library as an asset.

```dart title="lib/build.dart"
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

Future<void> main(List<String> args) async {
  await build(args, (config, output) async {
    final log = Logger(config.packageName);
    final dylibName = 'my_native_library';
    final cbuilder = CBuilder.library(
      name: dylibName,
      assetName: 'path/to/$dylibName.dart',
      sources: [
        config.packageRoot.resolve('src/$dylibName.c').toFilePath(),
      ],
    );
    await cbuilder.run(
      buildConfig: config,
      buildOutput: output,
      logger: log,
    );
  });
}
```

### Execute your build hook

To execute your build hook, run `hooks_runner` from your
terminal. The runner invokes your script, which
compiles your code and place the assets in the
`build/` directory, ready to be used by your application.

```console
$ dart run hooks_runner
```

You can also specify the target configuration if you need
to cross-compile:

```console
# Example: Build for 64-bit Windows
$ dart run hooks_runner --target=windows_x64
```

### Use a generated asset in your project

Assets are the files that hooks create in the
`build/` directory. Once an asset has been created,
you can reference it in your code.

The following example illustrates how to call a native
C function `sum` from an asset called
`my_package_bindings_generated.dart` in a Dart file called
`my_package/lib/my_package.dart`:

```dart title="my_package/lib/my_package.dart"
import 'dart:async';
import 'dart:islolate';
import 'my_package_bindings_generated.dart' as bindings

int sum(int a, int b) => bindings.sum(a:a, b:b);
```
