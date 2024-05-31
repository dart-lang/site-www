---
title: WebAssembly (Wasm) compilation
description: Learn how to compile your Dart web app to WebAssembly.
---

The Dart team is excited to add
[WebAssembly](https://webassembly.org/) as a compilation target when building
Dart and [Flutter][] applications for the web.

Development of WebAssembly support remains ongoing,
which will potentially result in frequent changes. 
Revisit this page for the latest updates.

:::note
**Support for Wasm is now in stable!**

WebAssembly support for Dart web is available on the Dart 
*stable* [channel](/get-dart#release-channels).
:::

## WebAssembly support

The current version of Dart compilation to WebAssembly has a number of
restrictions:

1. It targets WebAssembly with Garbage Collection ([WasmGC][]),
   so not all browsers are currently supported.
   The current list of browsers is available in the [Flutter documentation][Flutter].

1. The compiled Wasm output currently targets JavaScript environments
   (such as browsers), and thus currently doesn't support execution in standard
   Wasm run-times like wasmtime and wasmer. For details, see
   [issue #53884]({{site.repo.dart.sdk}}/issues/53884)

1. Only Dart's
   [next-gen JS interop mechanism](/interop/js-interop/)
   is supported when compiling to Wasm.

1. There is currently no support in the `webdev` tool for running
   (`webdev serve`) or building (`webdev build`). The steps below
   contain a temporary workaround. For details, see
   [webdev issue 2206]({{site.repo.dart.org}}/webdev/issues/2296).

## Compiling your web app to Wasm {:#compiling-to-wasm}

We've landed support in the `dart` CLI for invoking the
Wasm compiler in Dart and [Flutter][]:

```console
$ dart help compile wasm
Compile Dart to a WebAssembly/WasmGC module.

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

Wasm compilation is available in stable, but still in preview.
While we continue optimizing tooling to improve developer experience,
you can try compiling Dart to Wasm today
by following the temporary steps outlined here:

1. Start with a web app: `dart create -t web mywebapp`

    The template creates a small web app using [`package:web`][],
    which is necessary to run Wasm.
    Make sure your web apps are [migrated][] from `dart:html` to `package:web`.

1. Compile with Wasm to a new `site` output directory: `mywebapp$ dart compile wasm web/main.dart -o site/main.wasm`

1. Copy over the web files: `cp web/index.html web/styles.css site/`

1. Create a JS bootstrap file to load the Wasm code:
   
   Add a new file `site/main.dart.js` and fill it with the contents of
   this [`main.dart.js` sample](https://gist.github.com/mit-mit/0fcb1247a9444b0cadf611aa5fc6f32e).

1. Serve the output: `dart pub global run dhttpd` ([docs][dhttpd])

You can also try out this small example [here](https://github.com/mit-mit/sandbox).

[WasmGC]: https://developer.chrome.com/blog/wasmgc/
[Flutter]: {{site.flutter}}/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop 
[migrated]: /interop/js-interop/package-web/
[dhttpd]: {{site.pub-pkg}}/dhttpd
