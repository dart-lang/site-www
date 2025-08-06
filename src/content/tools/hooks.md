---
title: Hooks
description: Run custom build scripts.
---

:::note
Support for build hooks is in **preview** and
can be used on the `main` and `beta` channels.
:::

This guide explains what hooks are and how to use them
with a package.

## Introduction

Hooks are Dart scripts placed in the `hook/` directory of
your Dart package. These scripts have a predefined format
for their input and output. With hooks, the Dart SDK can:

1. Discover your hooks.
1. Execute your hooks with the necessary input.
1. Consume the output produced by the hooks.

Example project:

```plaintext
📁  example_project                   // project with hooks
    📁  hook                          // add hook scripts here
        📄 build.dart
    📁  lib                           // reference your assets here
        📄 example.dart
    📁  src                           // add native sources here
        📄 example_native_library.c
        📄 example_native_library.h
    📁  test                          // test your assets here
        📄 example_test.dart
```

## Hooks

Currently, the build hook is available, but more are
planned. To learn more, see the following.

### Build hooks {:.no_toc}

A build hook builds assets that you want
to run during your project's build process. This is useful
for tasks that need to happen before your main
application code is compiled, such as:

* Compiling C, C++, Rust, or other native code into a
  dynamic library.
* Downloading or generating other assets required at
  runtime.

A package's build hook is placed in the `hook/build.dart`
directory. Use the [`build`][] function to parse the hook
input with [`BuildInput`] and write the hook output with
[`BuildOutputBuilder`]. The hook should place downloaded and
generated assets in [`BuildInput.sharedOutputDirectory`][].

The build hooks are run in parallel with Dart compilation and may do longer
running operations such as downloading or calling a native compiler. The assets
produced in a build hook of a package may depend on [`assets`][] or
[`metadata`][] produced by build hooks of direct dependencies of the package.
Therefore, build hooks are run in the order of dependencies.

[`assets`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/assets.html
[`build`]: {{site.pub-api}}/hooks/latest/hooks/build.html
[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html
[`BuildInput.sharedOutputDirectory`]: {{site.pub-api}}/hooks/latest/hooks/HookInput/outputDirectoryShared.html
[`metadata`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/metadata.html

## Assets

Assets are the files output from a hook that need to be
bundled in a Dart application. Assets can be accessed
at runtime from the Dart code. Currently, the Dart SDK can
use the `CodeAsset` type, but more are planned.
To learn more, see the following.

### CodeAsset type {:.no_toc}

A [`CodeAsset`][] represents a code asset. A code asset is
a dynamic library compiled from a language other than
Dart, such as C, C++, Rust, or Go. `CodeAsset` is part of
the `code_asset` package and are called with `dart:ffi` from
the Dart code at runtime using the `@Native` annotation.
A code asset can be used with build and link hooks.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html

## Use a hook {: #use-hooks-assets }

To add assets to your project, use a hook. For details,
see the following sections.

### Add dependencies {: #add-dependencies-hooks-assets }

Open your package in a code editor, navigate to its
`pubspec.yaml`, and then add the following dependencies as
needed under `dependencies`:

* `hooks`
* `code_assets`

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
  sdk: '>=3.9.0 <4.0.0'

dependencies:
  ... 
  code_assets: any
  hooks: any
  native_toolchain_c: any

dev_dependencies:
  ...
  ffigen: ^18.0.0
 ```

### Create a build hook script {: #create-hook }

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

### Generate or download assets {: #generate-assets }

Assets are generated and/or downloaded when you invoke your
Dart hooks. Your Dart hooks are invoked when you use the
`run`, `build`, or `test` command on your package.
The resulting assets are stored in the directory that you
specified with [`BuildInput.sharedOutputDirectory`][]. 

[`BuildInput.sharedOutputDirectory`]: {{site.pub-api}}/hooks/latest/hooks/HookInput/outputDirectoryShared.html

### Reference assets {: #reference-assets }

Assets are the files that hooks create. Once an asset has been created,
you can reference it in your code and at runtime with it's
asset ID ([`assetId`][]).

The following example illustrates how to call a native
C function `add` from `native_add_library.c`:

```dart title="my_package/lib/my_package.dart"
import 'dart:ffi' as ffi;

@ffi.Native<ffi.Int32 Function(ffi.Int32, ffi.Int32)>()
external int add(int a, int b);
```

:::note
*   The asset ID is constructed in the build hook in the example above as
    `package:$packageName/$packageName.dart` (which is
    `package:native_add_library/native_add_library.dart`).
*   The asset ID in `@Native` is optional and defaults to
    the library uri (which also is
    `package:native_add_library/native_add_library.dart` in the example above).
:::

[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html

### Test assets {: #test-assets }

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

## Example projects

There are several example projects to help you get started
with hooks:

| **Project**                  | **Description**                                                                   |
| ---------------------------- | --------------------------------------------------------------------------------- |
| [`native_add_library`][]     | Native code that should be bundled with Dart and Flutter applications.            |
| [`native_add_app`][]         | Invocation of native code bundled with the native assets feature.                 |
| [`download_asset`][]         | Library depending on prebuilt assets which are downloaded in the build hook.      |
| [`native_dynamic_linking`][] | Builds three native libraries, two of which are dynamically linked to each other. |
| [`system_library`][]         | A Dart library using a native system library.                                     |
| [`use_dart_api`][]           | Project that uses the C API of the Dart VM.                                       |
 
{: .table .table-striped }

[`native_add_library`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library
[`native_add_app`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_add_app
[`download_asset`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/download_asset
[`native_dynamic_linking`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_dynamic_linking
[`system_library`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/system_library
[`use_dart_api`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/use_dart_api

## More information

See the following for more information about hooks:

* [Hooks package][]
* [Hooks library reference][]
* [Build and bundle native code][]

[Hooks package]: {{site.pub-pkg}}/hooks
[Hooks library reference]: {{site.pub-api}}/hooks/latest/hooks/
[Build and bundle native code]: https://dart.dev/interop/c-interop#build-hooks
