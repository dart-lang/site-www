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
1. Consume the output produced by the hooks.

Example project:

```plaintext
📁  example_project                   // project with the hooks
    📁  build                         // assets are generated here
        📄 asset
        📄 asset
        ...
    📁  hook                          // add hook scripts here
        📄 build.dart
        📄 link.dart
    📁  lib                           // reference your assets here
        📄 example.dart
    📁  src                           // add native assets here (build hooks)
        📄 example_native_library.c
        📄 example_native_library.h
    📁  test                          // test your assets here
        📄 example_test.dart
```

## Hooks

Currently, the build hook and link hook are available,
but more are planned. To learn more about these hooks,
see the following sections.

### Build hooks

A build hook builds assets that you want
to run during your project's build process. This is useful
for tasks that need to happen before your main
application code is compiled, such as:

* Compiling C, C++, Rust, or other native code into a
  dynamic library.
* Downloading or generating other assets required at
  runtime.

Use the [`build`][] function to create a build hook.
Build hooks are stored in the `hook/build.dart` directory
and create code assets in the `build/` directory.

[`build`]: {{site.pub-api}}/hooks/0.19.5/hooks/build.html

### Link hooks

A link hook shrinks assets to only the
required parts based on Dart AOT tree-shaking information.

Use the [`link`][] function to create a build hook.
Link hooks are stored in the `hook/link.dart` directory
and create code assets and data assets in the
`build/` directory.

[`link`]: {{site.pub-api}}/hooks/0.19.5/hooks/link.html

## Assets

Assets are the files output from a hook that need to be
bundled in a Dart application. Assets can be accessed
at runtime from the Dart code. Currently, the Dart SDK can
use the `CodeAsset` and `DataAsset` asset types.

### CodeAsset type

A [`CodeAsset`][] represents a code asset. A code asset is
a dynamic library compiled from a language other than
Dart, such as C, C++, Rust, or Go. `CodeAsset` is part of
the `code_asset` package and are called with `dart:ffi` from
the Dart code at runtime using the `@Native` annotation.
A code asset can be used with build and link hooks.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html

### DataAsset type

A [`DataAsset`][] represents a data asset in bytes format.
It can be accessed by Dart at runtime and used in
Dart standalone packages. `DataAsset` is part of the
`data_asset` package and can be used with link hooks.

[`DataAsset`]: {{site.pub-api}}/data_assets/latest/data_assets/DataAsset-class.html

## Use a hook

To setup a hook, use a hook to generate assets, and use
those assets in your Dart project, see the steps in the
following sections.

### Add dependencies

Open your package in a code editor, navigate to its
`pubspec.yaml`, and then add the following dependencies as
needed under `dependencies`:

* `hooks`
* `code_assets` (for build hooks and link hooks)
* `data_assets` (for link hooks)

You will also likely need to add a tool for your specific
task, such as `native_toolchain_c` for compiling C code.

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

 Example dependencies for a link hook:

 ```yaml title="pubspec.yaml"
name: package_with_assets
description: An example of using a package with assets.
version: 0.1.0

environment:
  sdk: '>=3.8.0 <4.0.0'

dependencies:
  ...
  data_assets: any
  hooks: any

dev_dependencies:
  ...
 ```

### Create a build hook script

If you want to use a build hook, first create the native
library that you want to use, and then follow these steps to
connect a build hook to that library in a Dart script: 

1.  In your Dart project, create or open `hooks/build.dart`. 

1.  In the main method, add a `build` function from
    `package:hooks/hooks.dart` and link to the native
    library. For example:

    ```dart title="hooks/build.dart" highlightLines=6
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
      the [`BuildInput`][] class.

    * `output`: The output for `hook/build.dart`. This
      includes the assets to be bundled, and dependencies.
      For details, see the [`BuildOutputBuilder`][] class.

[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html

### Create a link hook script

If you want to use a link hook, follow these steps to
add one to a Dart script: 

1.  In your Dart project, create or open `hooks/link.dart`. 

1.  In the main method, add a `link` function from
    `package:hooks/hooks.dart` and construct a data asset.
    For example:

    ```dart title="hooks/link.dart" highlightLines=14
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
      the [`LinkInput`][] class.

    * `output`: The output for `hook/link.dart`. This
      includes the assets to be bundled, and dependencies.
      For details, see the [`LinkOutputBuilder`][] class.

[`LinkInput`]: {{site.pub-api}}/hooks/latest/hooks/LinkInput-class.html
[`LinkOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/LinkOutputBuilder-class.html

### Generate assets

Assets are generated when you invoke the Dart hooks in
the `hook/` directory. Your Dart hooks are invoked when when
you use the `run`, `build`, or `test` command on your
package.

### Reference assets

Assets are the files that hooks create in the
`build/` directory. Once an asset has been created,
you can reference it in your code and at runtime with it's
asset ID (`assetId`).

The following example illustrates how to call a native
C function `add` from `native_add_library.c`:

```dart title="my_package/lib/my_package.dart"
import 'dart:ffi' as ffi;

@ffi.Native<ffi.Int32 Function(ffi.Int32, ffi.Int32)>()
external int add(int a, int b);
```

:::note
*   The asset ID is constructed in the build hook as
    `package:$packageName/$packageName.dart` (for example,
    `package:native_add_library/native_add_library.dart`).
*   The asset ID in `@Native` is optional and defaults to the
    library uri (for example,
    `package:native_add_library/native_add_library.dart`).
:::

### Test assets

After you've generated an asset and referenced it in
your Dart code, consider creating a test for the generated
asset. In the following example, a test is created for
`native_add_library.dart`, a script that references a
code asset called  

```dart title="test/native_add_library_test.dart"
import 'package:native_add_library/native_add_library.dart';
import 'package:test/test.dart';

void main() {
  test('invoke native function', () {
    expect(add(24, 18), 42);
  });
}
```

## Example project

There are several example projects to help you get started
with hooks:

| **Project** | **Description** |
| ------------| --------------- |
| [`download_asset`][] | Library depending on prebuilt assets which are downloaded in the build hook. |
| [`local_asset`][] | Library bundling all files in a directory as data assets. |
| [`native_add_app`][] | Invocation of native code bundled with the native assets feature. |
| [`native_add_library`][] | Native code that should be bundled with Dart and Flutter applications. |
| [`native_dynamic_linking`][] | Builds three native libraries, two of which are dynamically linked to each other. |
| [`system_library`][] | A Dart library using a native system library. |
| [`use_dart_api`][] | Project that uses the C API of the Dart VM. |
| [`app_with_asset_treeshaking`][] | Calls some methods from `package_with_assets`, which declares assets and treeshakes them. |
 
{: .table .table-striped }

[`download_asset`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/download_asset
[`local_asset`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/local_asset
[`native_add_app`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_add_app
[`native_add_library`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library
[`native_dynamic_linking`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_dynamic_linking
[`system_library`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/system_library
[`use_dart_api`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/use_dart_api
[`app_with_asset_treeshaking`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/link/app_with_asset_treeshaking

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
