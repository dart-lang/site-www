---
title: WebAssembly (Wasm) compilation
description: Learn how to compile your Dart web app to WebAssembly.
---

You can compile Dart and [Flutter][] web applications to
[WebAssembly][wasm-org] (`dart2wasm`) as an alternative to JavaScript
for production builds.
WebAssembly support for Dart web is available on the Dart
*stable* [channel][release-channels].

<a id="webassembly-support" aria-hidden="true"></a>

## Requirements and considerations

When compiling Dart to WebAssembly, keep the following requirements
and platform behaviors in mind:

1. In Dart 3.14, `dart2wasm` targets three standardized
   WebAssembly proposals:

   1. **WasmGC** ([Garbage Collection][WasmGC])
   1. **JS String Builtins (`wasm:js-string`)**
      (the `jsStringPolyfill` fallback was removed in Dart 3.14)
   1. **Phase 4 Exception Handling (`try_table` and `exnref`)**

   Running compiled modules in a browser requires the following
   minimum browser versions that support all three proposals:

   * **Chrome or Edge 137+**
   * **Safari 26.2+** (macOS and iOS)
   * **Firefox 134+** (**Firefox 155+** recommended for
     [performance fixes][firefox-1996818])
   * More browser compatibility details are available in the
     [Flutter documentation][Flutter].

1. By default, the compiled Wasm output targets JavaScript environments
   (such as browsers) and generates a companion `<name>.mjs` runtime file.
   To compile a standalone WASI-targeted WebAssembly module for non-web
   runtimes such as Wasmtime 39+
   (using `-W gc,exceptions,function-references=y`),
   pass `--standalone` to `dart compile wasm`.
   When `--standalone` is set, `dart:js_interop` is disallowed.
   For details, see [issue #53884][sdk-53884].

1. Only Dart's
   [next-gen JS interop mechanism][js-interop]
   is supported when compiling to Wasm.

1. There is currently no support in the `webdev` tool for running
   (`webdev serve`) or building (`webdev build`). The steps in
   [Compiling your web app to Wasm](#compiling-to-wasm)
   provide a workaround. For details, see
   [webdev issue 2296][webdev-2296].

### Deferred loading

By default, compiled applications do not use [deferred loading][].
Deferred loading in Wasm is experimental (available starting in Dart 3.13).
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

1.  Compile the app to Wasm into a `site` output directory
    (pass `-O2` to enable production optimizations and minification):

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

1.  Load the generated `site/main.mjs` runtime to instantiate and invoke
    `site/main.wasm`:

    Because the template's `web/index.html` includes
    `<script defer src="main.dart.js"></script>`,
    create `site/main.dart.js` with the following bootstrap code
    (or include it directly in `site/index.html` inside a
    `<script type="module">` tag):

    ```js title="site/main.dart.js"
    (async function () {
      const { compileStreaming } = await import('./main.mjs');
      const app = await compileStreaming(fetch('main.wasm'));
      const instantiatedApp = await app.instantiate({});
      instantiatedApp.invokeMain();
    })();
    ```

1.  Serve the `site` directory using an HTTP server such as [`dhttpd`][]:

    ```console
    $ dart pub global run dhttpd --path site
    ```

    :::tip
    When deploying to a production web server, ensure your server serves
    `.wasm` files with the `application/wasm` MIME type so that
    `compileStreaming` succeeds.
    :::

You can also try out this small [sandbox example][sandbox].

[wasm-org]: https://webassembly.org/
[release-channels]: /get-dart#release-channels
[WasmGC]: https://developer.chrome.com/blog/wasmgc/
[firefox-1996818]: https://bugzilla.mozilla.org/show_bug.cgi?id=1996818
[Flutter]: {{site.flutter}}/wasm
[sdk-53884]: {{site.repo.dart.sdk}}/issues/53884
[js-interop]: /interop/js-interop/
[webdev-2296]: {{site.repo.dart.org}}/webdev/issues/2296
[past-js-interop]: /interop/js-interop/past-js-interop#next-generation-js-interop
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop
[migrated]: /interop/js-interop/package-web/
[`dhttpd`]: {{site.pub-pkg}}/dhttpd
[deferred loading]: /language/libraries#lazily-loading-a-library
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
[sandbox]: https://github.com/mit-mit/sandbox

