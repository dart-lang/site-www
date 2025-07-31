---
title: Hooks
description: Run custom build scripts.
---

:::note
Support for build hooks is in **preview** and
can be used on the `main` and `beta` channels.
:::

This guide explains what hooks are and how to use them.

## Introduction

Hooks are Dart scripts placed in the `hook/` directory of
your Dart package. These scripts have a predefined format
for their input and output. With hooks, the Dart SDK can:

1. Discover your hooks.
1. Execute your hooks with the necessary input.
1. Consume the output.

Currently, the build hook and link hook are available,
but more are planned. For details, see the
[Dart hooks project][] on Github.

### Build hooks

A build hook (`hook/build.dart`) builds assets that you want
to run during your project's build process. This is useful
for tasks that need to happen before your main
application code is compiled, such as:

* Compiling C, C++, Rust, or other native code into a
  dynamic library.
* Downloading or generating other assets required at
  runtime.

Build hooks create `CodeAsset`-typed assets.

### Link hooks

A link hook (`hook/link.dart`) shrinks assets to only the
required parts based on Dart AOT tree-shaking information.

Link hooks create `CodeAsset`-typed assets.

### Assets

Assets are the files output from a hook that needs to be
bundled in a Dart application. These assets can be accessed
at runtime from the Dart code.

Currently, the Dart SDK can use the following asset type,
but more are planned:

* ([`CodeAsset`][]s). Code assets that represent
  dynamic libraries compiled from a language other than
  Dart, such as C, C++, Rust, or Go. They can be used with
  build and link hooks.
  
  Code assets are part of the `code_asset`s package and are
  called with `dart:ffi` from the Dart code at runtime using
  the `@Native` annotation.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html

## Use a hook

To use a hook with your Dart project, you must include a
hook from the  the `hooks` package, which provides a
Dart API for reading input and writing output.

### Add dependencies

Open your package in a code editor, navigate to its
`pubspec.yaml`, and then add `hooks` amd `code_assets` as
`dependencies`. You will also likely need to add a
tool for your specific task, such as `native_toolchain_c`
for compiling C code.

:::note
You need to add the dependencies under `dependencies`, not
`dev_dependencies`. The hooks will be run by packages and
applications depending on your package, so the
Dart code needs to be part of the resolution in those
packages.
:::

Example dependencies for a build hook:

```yaml title="pubspec.yaml"
name: native_add_library
description: Sums two numbers with native code.
version: 0.1.0

environment:
  sdk: '>=3.8.0 <4.0.0'

dependencies:
  ... 
  code_assets: any
  hooks: any
  native_toolchain_c: any

dev_dependencies:
  ...
  ffigen: ^18.0.0
 ```

### Create a build hook script

If you want to use a build hook, first create the native
library that you want to use, and then follow these steps to
connect a build hook to that library in a Dart script: 

1.  Open the script that you want to contain the build hook
    (for example, `hooks/build.dart`). 

1.  In the main method, add a `build` function from
    `package:hooks/hooks.dart`. For example:

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

    * `input`: The input for `hook/build.dart`. This
      includes the target OS, target architecture,
      output directory, etc. For details, see
      the [`BuildInput` class][].

    * `output`: The output for `hook/build.dart`. This
      includes the assets to be bundled, and dependencies.
      For details, see the [`BuildOutputBuilder` class][].

### Create a link hook script

If you want to use a link hook, follow these steps to
add one to a Dart script: 

1.  Open the script that you want to contain the build hook
    (for example, `hooks/link.dart`). 

1.  In the main method, add a `build` function from
    `package:hooks/hooks.dart`. For example:

    ```dart title="hooks/link.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:data_assets/data_assets.dart';
    import 'package:hooks/hooks.dart';
    import 'package:record_use/record_use.dart';

    const multiplyIdentifier = Identifier(
      importUri: 'package:package_with_assets/package_with_assets.dart',
      name: 'AssetUsed',
    );

    void main(List<String> args) async {
      await link(args, (input, output) async {
        final usages = input.usages;

        final usedAssets = (usages.instancesOf(multiplyIdentifier) ?? []).map(
          (e) => (e.instanceConstant.fields.values.first as StringConstant).value,
        );

        output.assets.data.addAll(
          input.assets.data.where(
            (dataAsset) => usedAssets.contains(dataAsset.name),
          ),
        );
      });
    }

    extension on LinkInput {
      RecordedUsages get usages {
        final usagesFile = recordedUsagesFile;
        final usagesContent = File.fromUri(usagesFile!).readAsStringSync();
        final usagesJson = jsonDecode(usagesContent) as Map<String, Object?>;
        final usages = RecordedUsages.fromJson(usagesJson);
        return usages;
      }
    }
    ```

    * `input`: The input for `hook/link.dart`. This
      includes the target OS, target architecture,
      output directory, etc. For details, see
      the [`BuildInput` class][].

    * `output`: The output for `hook/link.dart`. This
      includes the assets to be bundled, and dependencies.
      For details, see the [`BuildOutputBuilder` class][].

### Generate assets

Dart invokes the hooks in the `hook/` directory when running
the `run`, `build`, and `test` commands on your package.

## Reference assets

Assets are the files that hooks create in the
`build/` directory. Once an asset has been created,
you can reference it in your code and at runtime with it's
asset ID.

An asset that is output from a hook and accessed
at runtime has an _asset ID_ (`assetId`). The asset ID
is constructed in the build hook as
`package:$packageName/$packageName.dart` (which is
`package:native_add_library/native_add_library.dart`).
The asset ID in `@Native` is optional and defaults to the
library uri (for example,
`package:native_add_library/native_add_library.dart`).

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

For more example projects, see [Hooks example projects][].

[Hooks example projects]: https://github.com/dart-lang/native/tree/main/pkgs/hooks/example/build

## More information

See the following for more information about hooks:

* [Hooks package][]
* [Hooks library reference][]
* [Build and bundle native code][]

[Hooks package]: https://pub.dev/packages/hooks
[Hooks library reference]: https://pub.dev/documentation/hooks/0.19.5/hooks/
[Build and bundle native code]: https://dart.dev/interop/c-interop#build-hooks
[Dart hooks project]: https://github.com/dart-lang/native/tree/main/pkgs/hooks

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html
[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html
