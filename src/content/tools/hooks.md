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

You can currently use hooks to do things
such as compile or download native assets (code written in
other languages that are compiled into machine code), and
then call these assets from the Dart code of a package.

Hooks are Dart scripts placed in the `hook/` directory of
your Dart package. They have a predefined format for their
input and output, which allows the Dart SDK to:

1. Discover the hooks.
1. Execute the hooks with the necessary input.
1. Consume the output produced by the hooks.

Example project with a build hook:

```plaintext
📁  example_project                   // Project with hooks.
    📁  hook                          // Add hook scripts here.
        📄 build.dart
    📁  lib                           // Use your assets here.
        📄 example.dart
    📁  src                           // Add native sources here.
        📄 example_native_library.c
        📄 example_native_library.h
    📁  test                          // Test your assets here.
        📄 example_test.dart
```

## Hooks

Currently, the build hook is available, but more are
planned. To learn more, see the following.

### Build hooks {:.no_toc}

With build hooks, a package can do things such as
compile or download native assets such as C or Rust libraries.
Afterwards, these assets can be called from the Dart code of
a package.

A package's build hook is automatically invoked by the
Dart SDK at an appropriate time during the build process.
Build hooks are run in parallel with Dart compilation and
might do longer running operations such as downloading or
calling a native compiler.

Use the [`build`][] function to parse the hook
input with [`BuildInput`] and then write the hook output
with [`BuildOutputBuilder`]. The hook should place
downloaded and generated assets in
[`BuildInput.sharedOutputDirectory`][].

The assets produced for your package might depend on
[`assets`][] or [`metadata`][] produced by the build hooks
from the packages in the direct dependencies in the pubspec. Therefore,
build hooks are run in the order of dependencies in the pubspec, and cyclic
dependencies between packages are not supported when using hooks.

[`assets`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/assets.html
[`build`]: {{site.pub-api}}/hooks/latest/hooks/build.html
[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html
[`BuildInput.sharedOutputDirectory`]: {{site.pub-api}}/hooks/latest/hooks/HookInput/outputDirectoryShared.html
[`metadata`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/metadata.html

## Assets

Assets are the files that are produced by a hook and then
bundled in a Dart application. Assets can be accessed
at run time from the Dart code. Currently, the Dart SDK can
use the `CodeAsset` type, but more asset types are planned.
To learn more, see the following.

### CodeAsset type {:.no_toc}

A [`CodeAsset`][] represents a code asset. A code asset is a dynamic library
compiled from a language other than Dart, such as C, C++, Rust, or Go.
`CodeAsset` is part of the `code_asset` package. APIs provided by code assets
are accessed at run time through corresponding external Dart members annotated
with the [`@Native`][] annotation from `dart:ffi`.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html
[`@Native`]: {{site.dart-api}}/dart-ffi/Native-class.html

## Use a hook {: #use-hooks-assets }

To add assets to your project, use a hook. For details,
see the following sections.

### Add dependencies {: #add-dependencies-hooks-assets }

To use a hook, you must first add the helper packages
`hooks` and `code_assets` to your `pubspec.yaml`
dependencies:

1. `dart pub add hooks code_assets`.

If you need to compile C sources, you'll also need package `native_toolchain_c`:

2. `dart pub add native_toolchain_c`.

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
  sdk: '^3.9.0'

dependencies:
  # ... 
  code_assets: any
  hooks: any
  native_toolchain_c: any

dev_dependencies:
  # ...
  ffigen: ^18.0.0
 ```

### Create a build hook to generate native assets {: #create-hook }

If you want to use a build hook to transparently compile
native assets (such as C or Rust libraries), which are then
made available to be called from the Dart code of a package,
create a `build.dart` script similar to the following:

1.  In your Dart project, create or open `hooks/build.dart`. 

1.  In the `main` method, call the `build` function from
    `package:hooks/hooks.dart` and use the appropriate
    toolchain to compile the native library. For example:

    ```dart title="hooks/build.dart" highlightLines=6
    import 'package:hooks/hooks.dart';
    import 'package:logging/logging.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';

    void main(List<String> args) async {
      await build(args, (input, output) async {
        final packageName = input.packageName;
        final cBuilder = CBuilder.library(
          name: packageName,
          assetName: '$packageName.dart',
          sources: ['src/$packageName.c'],
        );
        await cBuilder.run(
          input: input,
          output: output,
          logger: Logger('')
            ..level = Level.ALL
            ..onRecord.listen((record) => print(record.message)),
        );
      });
    }
    ```

    The second parameter of `build` expects a function that it will pass two
    arguments to:

    * `input`: The read-only input for the hook.
      Includes information for the hook
      to produce the right asset type (for example,
      target OS, target architecture, output directory, and
      more). For details, see the [`BuildInput`][] class.

    * `output`: The write-only builder for the hook output. After the
      build hook reads the input, it produces an asset and
      then provides what it produced as the output.
      For details, see the [`BuildOutputBuilder`][] class.

[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html

### Automatically bundled assets {: #generate-assets }

The hooks are run automatically when invoking the `run`, `build`, or `test`
commands. The resulting assets are stored in the output directory specified in
the hook input. The Dart SDK then automatically bundles those assets with
your Dart app so that that they can be accessed at run time.

### Use assets {: #reference-assets }

Assets are the files that hooks create. Once an asset is
created, you can reference it in your code and at run time
with its asset ID ([`assetId`][]). Asset IDs are structured
as `package:<package-name>/<asset-name>`. Build hooks can
only output assets in their own package. `CBuilder` in
the build hook in the previous example outputs the asset ID
`package:native_add_library/native_add_library.dart`, and is
based on the `packageName` and `assetName`.

The following example illustrates how to bind to the native
C function `add` from `native_add_library.c` and call it:

```dart title="my_package/lib/my_package.dart"
import 'dart:ffi';

@Native<Int32 Function(Int32, Int32)>()
external int add(int a, int b);
```

```dart title="my_package/bin/my_package.dart"
import 'package:my_package/my_package.dart';

void main() {
  print(add(24, 18));
}
```

The asset ID in `@Native` is optional and defaults to the
library URI. In the previous example, this is
`package:native_add_library/native_add_library.dart`, which
is the same asset ID as output from the build hook. This
enables Dart to connect an asset referenced at run time to
the one provided by the hook during the build process.

[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html

### Test assets {: #test-assets }

After you've written a hook that generates an asset and
you've used that asset in your Dart code, consider writing
a test to verify that the hook and the generated asset works
as expected.

In the following example, a test is created for
`native_add_library.dart`, a script that references a
native C function called `add`: 

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

See the following links for more information:

* [Hooks package][]
* [Hooks library reference][]
* [C interop][]

[Hooks package]: {{site.pub-pkg}}/hooks
[Hooks library reference]: {{site.pub-api}}/hooks/latest/hooks/
[C interop]: /interop/c-interop
