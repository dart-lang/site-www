---
title: WebAssembly (Wasm) compilation
description: Learn how to compile your Dart web app to WebAssembly.
---

You can compile Dart and [Flutter][] web applications to
[WebAssembly][wasm-org] (`dart2wasm`) as an alternative to JavaScript
for production builds.

## WebAssembly support

When compiling Dart to WebAssembly, keep the following requirements
and platform behaviors in mind:

1. `dart2wasm` targets three standardized WebAssembly proposals:
   **WasmGC** (Garbage Collection),
   **JS String Builtins** (`wasm:js-string`), and
   **Phase 4 Exception Handling** (`try_table` and `exnref`).
   Running compiled modules in a browser requires at least:

   * **Chrome or Edge 137+**
   * **Safari 26.2+** (macOS and iOS)
   * **Firefox 134+** (**Firefox 155+** recommended for
     [performance fixes][firefox-1996818])

   For more browser compatibility details, see the
   [Flutter Wasm documentation][Flutter].

1. By default, compiled Wasm output targets JavaScript environments
   (such as browsers) and generates a companion `<name>.mjs` runtime file.
   To compile a standalone WASI-targeted WebAssembly module for non-web
   runtimes such as Wasmtime 39+
   (using `-W gc,exceptions,function-references=y`),
   pass `--standalone` to `dart compile wasm`.
   When `--standalone` is set, [`dart:js_interop`][] is disallowed.

1. Only Dart's
   [next-gen JS interop mechanism][js-interop]
   is supported when compiling to Wasm.

1. The `webdev` tool doesn't currently support Wasm compilation
   (`webdev serve` or `webdev build`).
   Instead, follow the steps in
   [Compiling your web app to Wasm](#compiling-to-wasm).

### Deferred loading

By default, compiled applications do not use [deferred loading][].
Deferred loading in Wasm is experimental.
To enable it, pass the `--enable-deferred-loading` flag:

```console
$ dart compile wasm --enable-deferred-loading ...
```

Enabling deferred loading requires your app loader to supply a callback
that loads the deferred module bytes:

```js
import { compileStreaming } from './main.mjs';

const app = await compileStreaming(fetch('main.wasm')); // or compile(...)
const instantiatedApp = await app.instantiate({}, {
  loadDeferredModules: (modules, handleModuleByteSource) => {
    return Promise.all(
      modules.map((m) => fetch(m).then((r) => handleModuleByteSource(m, r)))
    );
  },
});
instantiatedApp.invokeMain();
```

### Conditional imports and SIMD support

* **Conditional imports (`dart.library.isolate`)**:
  When compiling with `dart2wasm`, `dart.library.isolate` evaluates to `false`
  in conditional imports (`if (dart.library.isolate)`),
  matching the behavior of `dart2js` and `ddc`.
* **128-bit Wasm SIMD (`v128`)**:
  In `dart2wasm`, `dart:typed_data` SIMD types
  (`Int32x4`, `Float32x4`, `Float64x2`, `Int32x4List`,
  `Float32x4List`, and `Float64x2List`)
  are backed by native WebAssembly 128-bit `v128` SIMD instructions.

### Supported packages

To find Wasm-compatible packages,
use the [`wasm-ready`][] filter on [pub.dev][].

A package is "wasm-ready" if it doesn't import non-Wasm compliant libraries
such as `dart:html` or `dart:js`. You can find the full list of disallowed
libraries on the [JS interop page][past-js-interop].

[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

## Compiling your web app to Wasm {:#compiling-to-wasm}

Use the `dart compile wasm` command in the `dart` CLI
to invoke the Wasm compiler in Dart and [Flutter][]:

```console
$ dart help compile wasm
Compile Dart to a WebAssembly/WasmGC module.

Usage: dart compile wasm [arguments] <dart entry point>
-h, --help                              Print this usage information.
-o, --output                            Write the output to <file name>.
                                        This can be an absolute or relative path.
-v, --verbose                           Print debug output during compilation
    --enable-asserts                    Enable assert statements.
-O, --optimization-level=<level>        Controls optimizations that can help reduce
                                        code-size and improve performance of the
                                        generated code.
                                        [0, 1 (default), 2, 3, 4]
    --[no-]minify                       Minify names that are needed at runtime (such
                                        as class names). Affects e.g.
                                        `<obj>.runtimeType.toString()`). If passed,
                                        this takes precedence over the
                                        optimization-level option.
    --[no-]strip-wasm                   Whether to strip the resulting wasm file of
                                        static symbol names.
                                        (defaults to on)
    --[no-]source-maps                  Generate a source map file.
                                        (defaults to on)
    --[no-]enable-deferred-loading      Emit multiple modules based on the Dart
                                        program's deferred import graph.
    --standalone                        Compile to a WebAssembly module without
                                        JavaScript interop. Dart-specific host
                                        imports are necessary to load these modules.
    --[no-]deprecated-js-interop        Enable support for deprecated JS interop
                                        libraries.
-D, --define=<key=value>                Define an environment declaration. To specify
                                        multiple declarations, use multiple options
                                        or use commas to separate key-value pairs.
                                        For example: dart compile wasm -Da=1,b=2
                                        main.dart
```

To compile and run a Dart web app with Wasm, follow these steps:

1.  Create a web app and switch to its directory:

    ```console
    $ dart create -t web mywebapp
    $ cd mywebapp
    ```

    The template creates a small web app using [`package:web`][],
    which is necessary to run Wasm.
    Make sure your web apps are [migrated][] from `dart:html` to `package:web`.

1.  Compile the app to Wasm into a `site` output directory:

    ```console
    $ dart compile wasm -O2 web/main.dart -o site/main.wasm
    ```

    This produces `site/main.wasm`, the companion JavaScript runtime
    `site/main.mjs`, and `site/main.wasm.map`.

    :::note
    By default, `dart compile wasm` generates a `.wasm.map` source map file
    alongside the `.wasm` output.
    To disable source map generation for production builds,
    pass `--no-source-maps`.
    To learn about security considerations when deploying source maps,
    see [Web deployment][manage-source-maps].
    :::

1.  Copy over the static web files:

    ```console
    $ cp web/index.html web/styles.css site/
    ```

1.  Because `index.html` loads `main.dart.js`, create `site/main.dart.js`
    to import the generated `site/main.mjs` runtime and instantiate
    `site/main.wasm`:

    ```js title="site/main.dart.js"
    (async function () {
      const { compileStreaming } = await import('./main.mjs');
      const app = await compileStreaming(fetch('main.wasm'));
      const instantiatedApp = await app.instantiate({});
      instantiatedApp.invokeMain();
    })();
    ```

1.  Serve the `site` directory using [`dhttpd`][]:

    ```console
    $ dart pub global run dhttpd --path site
    ```

You can also try out this small [sandbox example][sandbox].

[wasm-org]: https://webassembly.org/
[firefox-1996818]: https://bugzilla.mozilla.org/show_bug.cgi?id=1996818
[Flutter]: {{site.flutter}}/wasm
[js-interop]: /interop/js-interop/
[past-js-interop]: /interop/js-interop/past-js-interop#next-generation-js-interop
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop
[migrated]: /interop/js-interop/package-web/
[`dhttpd`]: {{site.pub-pkg}}/dhttpd
[deferred loading]: /language/libraries#lazily-loading-a-library
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
[sandbox]: https://github.com/mit-mit/sandbox

