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

1. By default, the compiled Wasm output targets JavaScript environments.
   Running in other runtimes like Wasmtime requires
   [additional setup](#non-web-targets).

1. Only Dart's
   [next-gen JS interop mechanism](/interop/js-interop/)
   is supported when compiling to Wasm.

1. There is currently no support in the `webdev` tool for running
   (`webdev serve`) or building (`webdev build`). The steps below
   contain a temporary workaround. For details, see
   [webdev issue 2206]({{site.repo.dart.org}}/webdev/issues/2296).

:::note
By default, compiled applications do not use [deferred loading][].
Deferred loading in Wasm is experimental. To enable it, use the
`--enable-deferred-loading` flag:

```console
$ dart compile wasm --enable-deferred-loading ...
```

Enabling deferred loading requires the app loader to supply a callback
that loads the module bytes:

```js
const app = await compileStreaming(...); // or compile(...)
const instantiatedApp = await app.instantiate({}, {
  loadDeferredModules: (modules, handleModuleByteSource) => {
    return Promise.all(
      modules.map((m) => fetch(m).then((r) => handleModuleByteSource(m, r)))
    );
  },
});
instantiatedApp.invokeMain();
```

This is available from the 3.13 Dart stable release.
:::

### Supported packages

To find Wasm-compatible packages,
use the [`wasm-ready`][] filter on [pub.dev][].

A package is "wasm-ready" if it doesn't import non-Wasm compliant libraries
like `dart:html`, `dart:js`, etc. You can find the full list of unallowed
libraries on the [JS interop page](/interop/js-interop/past-js-interop#next-generation-js-interop).

[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

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
    --[no-]source-maps      Generate a source map file.
                            (defaults to on)
-D, --define=<key=value>    Define an environment declaration. To specify multiple declarations, use multiple
                            options or use commas to separate key-value pairs.
                            For example: dart compile wasm -Da=1,b=2 main.dart
```

Wasm compilation is available in stable, but still in preview.
While we continue optimizing tooling to improve developer experience,
you can try compiling Dart to Wasm today
by following the temporary steps outlined here:

1.  Start with a web app: `dart create -t web mywebapp`

    The template creates a small web app using [`package:web`][],
    which is necessary to run Wasm.
    Make sure your web apps are [migrated][] from `dart:html` to `package:web`.

1.  Compile with Wasm to a new `site` output directory:

    ```console
    $ dart compile wasm web/main.dart -o site/main.wasm
    ```

    :::note
    By default, `dart compile wasm` generates a `.wasm.map` source map file
    alongside the `.wasm` output.
    To disable source map generation for production builds,
    pass `--no-source-maps`.
    To learn about security considerations when deploying source maps,
    see [Web deployment][manage-source-maps].
    :::

1.  Copy over the web files: `cp web/index.html web/styles.css site/`

1.  Create a JS bootstrap file to load the Wasm code:

    Add a new file `site/main.dart.js` and fill it with the contents of
    this [`main.dart.js` sample](https://gist.github.com/mit-mit/0fcb1247a9444b0cadf611aa5fc6f32e).

1.  Serve the output: `dart pub global run dhttpd` ([docs][dhttpd])

You can also try out this small example [here](https://github.com/mit-mit/sandbox).

## Non-web targets

:::note
**Support for non-web targets is experimental**

The standalone WebAssembly target is experimental and requires the host
to provide Dart-specific imports.
For details, see [issue #53884]({{site.repo.dart.sdk}}/issues/53884).
:::

By default, `dart compile wasm` generates a JavaScript helper file
that provides imports for core SDK features,
including strings, the event loop, math, and `dart:js_interop`.
You need this file to instantiate Dart Wasm modules,
so they can only run in environments with a JavaScript engine.

The `--standalone` flag enables an experimental alternative
that uses a fixed set of Dart-specific imports instead,
currently only documented [in SDK sources][standalone-embedder].
If you provide compatible imports,
you can run Dart applications on any WebAssembly 3.0 runtime.
To check which runtimes support the required features,
see the [feature support table][wasm-runtimes] on webassembly.org.

For example, consider this Dart program:

```dart title="example.dart"
void main() => print('Hello WebAssembly!');
```

After compiling it in standalone mode, you can inspect the imports
with tools like `wasm-dis` from [Binaryen][binaryen]:

```console
$ dart compile wasm --standalone example.dart
$ wasm-dis example.wasm | grep "(import"
```

The required imports might change between SDK releases,
but look something like this:

```plaintext
 (import "dart" "print" (func $fimport$0 (param externref)))
 (import "dart" "stringFromAsciiBytes" (func $fimport$1 (param (ref $2) i32 i32) (result (ref extern))))
 ...
```

This example only needs the `print` and `stringFromAsciiBytes` imports.

With the [Endive][endive] runtime for Java,
you can instantiate and run the module like this:

```java title="DartEmbedderExample.java"
import run.endive.runtime.*;
import run.endive.wasm.*;
import run.endive.wasm.types.FunctionImport;

void main() {
  var module = Parser.parse(new File("example.wasm"));
  var hostImports = new Store();
  module.importSection().stream()
      .forEach(
          imported -> {
            if (imported instanceof final FunctionImport fn) {
              var type = module.typeSection().getType(fn.typeIndex());
              var impl =
                  new WasmFunctionHandle() {
                    @Override
                    public CallResult applyWithRefs(
                        Instance instance, long[] numeric, Object[] refs) {
                      switch (fn.name()) {
                        case "stringFromAsciiBytes":
                          var asciiBytes = (WasmArray) refs[0];
                          var start = (int) numeric[1];
                          var length = (int) numeric[2];

                          var buffer = new StringBuilder(length);
                          for (int i = 0; i < length; i++) {
                            buffer.append((char) asciiBytes.get(start + i));
                          }

                          return CallResult.of(new long[0], new Object[] {buffer.toString()});
                        case "print":
                          IO.println(refs[0]);
                          return CallResult.of(new long[0], null);
                        default:
                          throw new RuntimeException("Not yet implemented: " + fn.name());
                      }
                    }

                    @Override
                    public long[] apply(Instance instance, long... args) {
                      return null;
                    }
                  };

              hostImports.addFunction(new HostFunction(fn.module(), fn.name(), type, impl));
            }
          });

  var instance = hostImports.instantiate("dart", module);
  var main = instance.export("$invokeMain");
  var args = WasmArray.builder().build();
  main.applyWithRefs(new long[0], new Object[] {args});
}
```

With the appropriate classpath, the Dart application runs in a JVM:

```console
$ java -cp "<endive jars>" DartEmbedderExample.java
Hello WebAssembly!
```

To embed the module in a native application,
you can use [Wasmtime][wasmtime] from a Rust program
that defines the host functions.

### Component model and WASI targets

The `--standalone` flag lets Dart run on any WebAssembly 3.0 runtime,
but the host must implement the Dart-specific imports.
As a result, standalone modules don't run in general-purpose tools
like `wasmtime run` (CLI programs) and `wasmtime serve` (HTTP servers).

The [component model][wasm-cm] wraps compiled WebAssembly modules
with a high-level description of their required functions and types.
[WASI][wasi] builds on it to define interfaces
for common CLI and server applications.

Dart doesn't target the component model directly,
but third-party tools can replace Dart-specific imports
with component model and WASI definitions.
With [`package:wasm_tools`], you can define any component in Dart,
and [`package:wasi`] lets you target
the `wasi:cli/command` and `wasi:http/service` worlds directly.

[WasmGC]: https://developer.chrome.com/blog/wasmgc/
[Flutter]: {{site.flutter}}/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop
[migrated]: /interop/js-interop/package-web/
[dhttpd]: {{site.pub-pkg}}/dhttpd
[deferred loading]: /language/libraries#lazily-loading-a-library
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
[standalone-embedder]: {{site.repo.dart.sdk}}/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart
[binaryen]: https://github.com/webassembly/binaryen
[endive]: https://endive.run/
[wasmtime]: https://wasmtime.dev/
[wasm-cm]: https://component-model.bytecodealliance.org/
[wasi]: https://wasi.dev/
[`package:wasm_tools`]: {{site.pub-pkg}}/wasm_tools
[`package:wasi`]: {{site.pub-pkg}}/wasi
[wasm-runtimes]: https://webassembly.org/features/
