---
title: WebAssembly (Wasm) compilation
description: Learn how to compile your Dart web app to WebAssembly.
---

The Dart team is excited to add
[WebAssembly](https://webassembly.org/) as a compilation target when building
Dart and [Flutter](https://flutter.dev/wasm) applications for the web.

Development of WebAssembly support remains ongoing,
which will potentially result in frequent changes. 
Revisit this page for the latest updates.

:::note
**Support for Wasm is now in beta!**

WebAssembly support for Dart web is available on the Dart 
*beta* and *main* [channels](/get-dart#release-channels).
:::

## WebAssembly support

The current version of Dart compilation to WebAssembly has a number of
restrictions:

1. It targets WebAssembly with Garbage Collection (aka *WasmGC*), so...

1. The compiled Wasm output currently targets JavaScript environments
   (such as browsers), and thus currently doesn't support execution in standard
   Wasm run-times like wasmtime and wasmer. For details, see
   [issue #53884](https://github.com/dart-lang/sdk/issues/53884)

1. Only Dart's
   [next-gen JS interop mechanism](/interop/js-interop/)
   is supported when compiling to Wasm.

## Compiling your web app to Wasm {:#compiling-to-wasm}

We've landed support in the `dart` CLI for invoking the
`dart2wasm` compiler in the Dart and Flutter `main` channels:

```console
$ dart help compile wasm
Compile Dart to a WebAssembly/WasmGC module (EXPERIMENTAL).

Usage: dart compile wasm [arguments] <dart entry point>
-h, --help                  Print this usage information.
-o, --output                Write the output to <file name>.
                            This can be an absolute or relative path.
-v, --verbose               Print debug output during compilation
    --enable-asserts        Enable assert statements.
-D, --define=<key=value>    Define an environment declaration. To specify multiple declarations, use multiple
                            options or use commas to separate key-value pairs.
                            For example: dart compile wasm -Da=1,b=2 main.dart
```

To try Wasm today from the `main` channel:

1. Start with a web app: `dart create -t web mywebapp`

    The template creates a small web app using [`package:web`][],
    which is necessary to run Wasm.
    Make sure your web apps are [migrated][] from `dart:html` to `package:web`.

1. Compile with Wasm: `mywebapp$ dart compile wasm web/main.dart`

1. Serve the output: `dart pub global run ` [`dhttpd`]

You can also check out this small example [here](https://github.com/mit-mit/sandbox).

[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop 
[migrated]: /interop/js-interop/package-web/
[`dhttpd`]: {{site.pub-pkg}}/dhttpd