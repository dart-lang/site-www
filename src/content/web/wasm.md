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

[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop 

## WebAssembly support

The current version of Dart compilation to WebAssembly has a number of
restrictions:

1. It targets WebAssembly with Garbage Collection (aka *WasmGC*), so 

1. The compiled Wasm output currently targets JavaScript environments
   (such as browsers), and thus currently doesn't support execution in standard
   Wasm run-times like wasmtime and wasmer. For details, see
   [issue #53884](https://github.com/dart-lang/sdk/issues/53884)

1. Only Dart's
   [next-gen JS interop mechanism](/js-interop#next-generation-js-interop)
   is supported when compiling to Wasm.

## Compiling your web app to Wasm {:#compiling-to-wasm}

TODO describe how to compile a web app to wasm:

1. `dart create -t web mywebapp`

1. `dart compile wasm`

1. TODO edit some of the files to wire up wasm, see https://github.com/dart-lang/sdk/issues/32894#issuecomment-1855633728

1. Serve the output: `dart pub global run dhttpd`