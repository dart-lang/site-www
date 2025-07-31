---
title: Hooks
description: Run custom build scripts.
---

:::note
Support for build hooks is in **preview** and
can be used on the `main` and `beta` channels.
:::

This guide explains what hooks are and how to use them.

# Introduction

Hooks are Dart scripts placed in the `hook/` directory of your Dart package.
These scripts have predefined format for their input and output, such that the
Dart SDK can invoke them.

The Dart SDK knows about the folling hooks:

* `hook/build.dart` To may build assets to be bundled with a Dart application.
* `hook/link.dart` To shrink assets to only the required parts based on Dart
  AOT tree-shaking information.

The `hooks` package provides a Dart API for reading the input and writing the
output in these hooks.

## Build Hooks

A build hook is a Dart script that runs during your project's build process.
This is useful for tasks that need to happen before your main application code
is compiled, such as:

* Compiling C, C++, Rust, or other native code into a dynamic library.
* Downloading or generating other assets required at runtime.
* ~~Generating Dart code based on native headers (for example, using
    `ffigen`).~~ This fits in `hook/generate.dart`

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

Assets ([`CodeAsset`][]s) are the files that hooks create,
which are then used by your application or other packages.
An asset is typically a compiled piece of native code.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html

## Add a build hook

Dart _build hooks_ enable packages to contain
native code assets that are transparently built, bundled,
and made available at runtime. This package:

*   Builds native code and obtains binaries using a package's
    build hook in `hook/build.dart`.

*   Bundles the resulting assets.

*   Accesses the assets at runtime.

Follow the steps in this section to add a build hook to your
package.

### Add dependencies

Open your package in a code editor, navigate to it's
`pubspec.yaml` and then add `hooks` as
`dev_dependencies`. You will also likely need to add a
tool for your specific task, such as `native_toolchain_c`
for compiling C code.

```yaml title="pubspec.yaml"
name: native_add_library
description: Sums two numbers with native code.
version: 0.1.0
repository: https://github.com/dart-lang/native/tree/main/pkgs/hooks/example/build/native_add_library

resolution: workspace

environment:
  sdk: '>=3.8.0 <4.0.0'

dependencies:
  ...
  hooks: any
  native_toolchain_c: any

dev_dependencies:
  ffigen: ^18.0.0
 ```

### Create the build hook script

1.  Open the script that you want to contain the build hook
    (for example, `lib/build.dart`). 

1.  In the main method, add a `build` function from
    `package:hooks/hooks.dart`.

    ```dart title="hooks/build.dart"
    import 'package:hooks/hooks.dart';
    import 'package:logging/logging.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';

    void main(List<String> args) async {
      await build(args, (input, output) async {
        final packageName = input.packageName;
        final cbuilder = CBuilder.library(
          name: packageName,
          assetName: '$packageName.dart',
          sources: ['src/$packageName.c'],
        );
        await cbuilder.run(
          input: input,
          output: output,
          logger: Logger('')
            ..level = Level.ALL
            ..onRecord.listen((record) => print(record.message)),
        );
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

## Generate assets

Dart invokes the `hook/build.dart` build hook when
running the `run`, `build`, and `test` commands on your
package.

## Reference assets

Assets are the files that hooks create in the
`build/` directory. Once an asset has been created,
you can reference it in your code.

The following example illustrates how to call a native
C function `add` from `native_add_library.c`:

```dart title="my_package/lib/my_package.dart"
import 'dart:ffi' as ffi;

@ffi.Native<ffi.Int32 Function(ffi.Int32, ffi.Int32)>()
external int add(int a, int b);
```

## Example project

The [`native_add_library`][] example includes the
minimum code to build and bundle C code in a Dart package.
The example includes the following files:

| **Source file**                         | **Description**                                                                                                                                                                |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`src/native_add_library.c`][]          | The C file containing the code for `add`.                                                                                                                                      |
| [`lib/native_add_library.dart`][]       | The Dart file that invokes the C function `add` in asset `package:native_add_library/native_add_library.dart` through FFI. (Note that _asset id_ defaults to the library uri.) |
| [`test/native_add_library_test.dart`][] | A Dart test using the native code.                                                                                                                                             |
| [`hook/build.dart`][]                   | A build hook for compiling `src/native_add_library.c` and declaring the compiled asset with  id `package:native_add_library/native_add_library.dart`.                          |

{: .table .table-striped }

[`src/native_add_library.c`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library/src/native_add_library.c
[`lib/native_add_library.dart`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library/lib/native_add_library.dart
[`test/native_add_library_test.dart`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library/test/native_add_library_test.dart
[`hook/build.dart`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library/hook/build.dart
[`native_add_library`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library
[`native_add_app`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_add_app

## More information

See the following for more information about hooks:

* [Hooks package][]
* [Hooks library reference][]
* [Hooks example project][]
* [Build and bundle native code][]

[Hooks package]: https://pub.dev/packages/hooks
[Hooks library reference]: https://pub.dev/documentation/hooks/0.19.5/hooks/
[Hooks example project]: https://github.com/dart-lang/native/tree/main/pkgs/hooks/example/build
[Build and bundle native code]: https://dart.dev/interop/c-interop#build-hooks

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html
[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html
