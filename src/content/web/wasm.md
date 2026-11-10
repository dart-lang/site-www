---
title: WebAssembly (Wasm) compilation
shortTitle: Wasm compilation
description: >-
  Compile Dart web applications to WebAssembly (WasmGC) to reduce load times,
  eliminate main-thread JIT pauses, and improve rendering responsiveness.
---

You can compile Dart and [Flutter][] web applications to
[WebAssembly][wasm-org] (`dart2wasm`) as a high-performance production
alternative to JavaScript (`dart2js`). Compiling to WebAssembly reduces initial
page load times, eliminates main-thread JavaScript just-in-time (JIT)
compilation pauses, and delivers consistent frame rendering in modern browsers.

## Compile your web app to Wasm {:#compiling-to-wasm}

Use the [`dart compile wasm`][dart-compile-wasm] command to compile a Dart web
app to a WebAssembly module. For a full list of compiler flags, refer to
[Compiler optimization levels and flags](#optimization-levels-and-flags) or run
`dart compile wasm --help`.

:::note
If you are building a Flutter web app, run `flutter build web --wasm`
instead of invoking `dart compile wasm` directly. Refer to the
[Flutter Wasm documentation][Flutter] for Flutter-specific build instructions.
:::

To compile and run a Dart web app with Wasm, follow these steps:

1. Create a web app and switch to its directory:

   ```console
   $ dart create -t web mywebapp
   $ cd mywebapp
   ```

   The template creates a small web app that uses [`package:web`][], which is
   required to run Wasm. Existing web apps must [migrate][migrated] from
   `dart:html` to `package:web`.

1. Compile the app to Wasm into a `site` output directory:

   ```console
   $ dart compile wasm -O2 web/main.dart -o site/main.wasm
   ```

   This command produces `site/main.wasm`, the companion JavaScript runtime
   `site/main.mjs`, and `site/main.wasm.map`.

   :::note
   By default, `dart compile wasm` generates a `.wasm.map` source map file
   alongside the `.wasm` output. To disable source map generation for
   production builds, pass `--no-source-maps`. To learn about security
   considerations when deploying source maps, refer to
   [Web deployment][manage-source-maps].
   :::

1. Copy over the static web files:

   ```console
   $ cp web/index.html web/styles.css site/
   ```

1. Because `index.html` loads `main.dart.js`, create `site/main.dart.js` to
   fetch `site/main.wasm` and import the generated `site/main.mjs` runtime in
   parallel:

   ```js title="site/main.dart.js"
   (async function () {
     const wasmPromise = fetch('main.wasm');
     const { compileStreaming } = await import('./main.mjs');
     const app = await compileStreaming(wasmPromise);
     const instantiatedApp = await app.instantiate({});
     instantiatedApp.invokeMain();
   })();
   ```

1. Serve the `site` directory by using a local HTTP server such as [`dhttpd`][]:

   ```console
   $ dart run dhttpd@ --path site
   ```

You can also explore this small [sandbox example][sandbox].

## WebAssembly support and requirements {:#webassembly-support}

When compiling Dart to WebAssembly, keep the following browser, interop, and
platform requirements in mind:

* **WebAssembly standards and browser compatibility**:
  The `dart2wasm` compiler targets three standardized WebAssembly proposals:
  WebAssembly Garbage Collection (WasmGC), JS String Builtins
  (`wasm:js-string`), and Phase 4 Exception Handling (the `try_table` and
  `exnref` instructions). Running compiled modules in a browser requires one
  of the following minimum browser versions:

  * Chrome or Edge 137+
  * Safari 26.2+ (macOS and iOS)
  * Firefox 134+ (or 147+ for Flutter web)

  For additional browser compatibility details, refer to the
  [Flutter Wasm documentation][Flutter].

* **Target environments and standalone mode**:
  By default, compiled Wasm output targets JavaScript environments (such as
  browsers) and generates a companion `<name>.mjs` runtime file. To compile a
  standalone WebAssembly module for non-web runtimes such as Wasmtime 39+
  (with the `-W gc,exceptions,function-references=y` flag), pass the
  `--standalone` flag to `dart compile wasm`. Standalone mode disallows the
  [`dart:js_interop`][] library and the `--enable-deferred-loading` flag.

* **JavaScript interop**:
  Compiling to Wasm supports only Dart's
  [next-generation JS interop mechanism][js-interop]
  ([`dart:js_interop`][] and [`package:web`][]).

* **Build tooling**:
  The `webdev` tool doesn't support Wasm compilation (`webdev serve` or
  `webdev build`). Instead, follow the steps in
  [Compile your web app to Wasm](#compiling-to-wasm).

### Supported packages {:#supported-packages}

To find Wasm-compatible packages, use the [`wasm-ready`][] filter on
[pub.dev][].

A package is *wasm-ready* when it doesn't import legacy web or interop
libraries such as `dart:html`, `dart:js`, or `package:js`. Refer to the
[past JS interop page][past-js-interop] for the full list of disallowed
libraries.

### Conditional imports and SIMD support {:#conditional-imports-and-simd-support}

* **Conditional imports (`dart.library.isolate`)**:
  When compiling with `dart2wasm`, `dart.library.isolate` evaluates to `false`
  in conditional imports (`if (dart.library.isolate)`), matching the behavior
  of `dart2js` and `ddc`.
* **128-bit Wasm SIMD (`v128`)**:
  In `dart2wasm`, `dart:typed_data` SIMD types (`Int32x4`, `Float32x4`,
  `Float64x2`, `Int32x4List`, `Float32x4List`, and `Float64x2List`) are backed
  by native WebAssembly 128-bit `v128` SIMD instructions.

## Compiler optimization levels and flags {:#optimization-levels-and-flags}

Tune `dart compile wasm` flags to balance compilation speed during development
against smaller binary size and faster execution in production builds:

```console
$ dart compile wasm -O2 web/main.dart -o site/main.wasm
```

### Optimization levels reference {:#optimization-levels}

The `-O0` through `-O4` optimization levels enable progressively more
aggressive compiler passes:

| Flag | Binaryen (`wasm-opt`) | Function inlining | Minify runtime names (`--minify`) and omit error details | Omit implicit type checks | Omit index bounds checks |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `-O0` | Disabled | Disabled | Disabled | Disabled | Disabled |
| `-O1` (default) | Enabled | Enabled | Disabled | Disabled | Disabled |
| `-O2` | Enabled | Enabled | Enabled | Disabled | Disabled |
| `-O3` | Enabled | Enabled | Enabled | Enabled | Disabled |
| `-O4` | Enabled | Enabled | Enabled | Enabled | Enabled |

{:.table .table-striped}

For most production builds, use the `-O2` flag. This level enables full size
and speed optimizations (including `wasm-opt`, function inlining, and
minification) while preserving standard Dart runtime semantics, type checks,
and bounds checks.

:::warning
The `-O3` level omits implicit type checks, and the `-O4` level additionally
omits index bounds checks (explicit `as` type checks are still enforced at
`-O3` and `-O4`). Omitting runtime checks can cause your app to trap or behave
unexpectedly if a runtime type error or out-of-bounds access occurs. Before
deploying with `-O3` or `-O4`, test thoroughly with the `-O2` flag to verify
that your app never throws a subtype of `Error` (such as `TypeError` or
`RangeError`).
:::

### Additional production CLI flags {:#production-cli-flags}

Use the following flags with [`dart compile wasm`][dart-compile-wasm] to
customize output symbols, source maps, module splitting, and compile-time
configuration:

| Flag | Default | Description |
| :--- | :--- | :--- |
| `--minify` | `-O2` and higher | Minifies runtime names (such as `runtimeType.toString()`). |
| `--[no-]strip-wasm` | Enabled | Strips static symbol names from the `.wasm` binary to reduce download size. Pass `--no-strip-wasm` when [profiling in Chrome DevTools](#profile-wasm). |
| `--[no-]source-maps` | Enabled | Generates `<output>.wasm.map` to map Wasm instruction offsets back to Dart source files and line numbers. |
| `--[no-]enable-deferred-loading` | Disabled | Splits `deferred as` imports into separate `<name>_module<id>.wasm` modules loaded on demand. |
| `--standalone` | Disabled | Emits a standalone Wasm module without JavaScript interop for non-web runtimes such as Wasmtime (disallows [`dart:js_interop`][] and `--enable-deferred-loading`). |
| `-D<key>=<value>` or `--define` | None | Defines compile-time environment declarations read by `String.fromEnvironment`, `int.fromEnvironment`, or `bool.fromEnvironment`. |

{:.table .table-striped}

### Detect Wasm compilation in Dart code {:#detecting-wasm-compilation}

When compiling with `dart2wasm`, the compiler automatically defines
`dart.tool.dart2wasm` as `true` in the compile-time environment:

<?code-excerpt "misc/lib/development/environment_declarations.dart (wasm-check)"?>
```dart
const bool isRunningAsWasm = bool.fromEnvironment('dart.tool.dart2wasm');
```

### Deferred loading {:#deferred-loading}

By default, compiled applications load as a single `.wasm` module. For large
applications, pass `--enable-deferred-loading` to split
[deferred libraries][deferred loading] into separate `<name>_module<id>.wasm`
files:

```console
$ dart compile wasm -O2 --enable-deferred-loading web/main.dart -o site/main.wasm
```

When you enable deferred loading, your application loader must provide a
`loadDeferredModules` callback to `app.instantiate()` that fetches and loads
the deferred module bytes:

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

## How `dart2wasm` works {:#architecture-and-wasmgc}

The `dart2wasm` ahead-of-time (AOT) compiler translates Dart source code into
compact WebAssembly bytecode that integrates directly with the browser's native
garbage collector and string runtime.

### The `dart2wasm` AOT compilation pipeline {:#compilation-pipeline}

When you run `dart compile wasm`, the `dart2wasm` compiler executes four
sequential phases:

1. **`cfe` (Common Front End)**:
   Parses Dart source code, enforces sound null safety, and applies modular
   kernel transformations into a `.dill` kernel abstract syntax tree (AST).
1. **`tfa` (Type Flow Analysis)**:
   Performs closed-world whole-program analysis, tree-shaking unreachable code,
   devirtualizing method calls, and inferring concrete types and unboxing
   opportunities.
1. **`codegen` (Wasm code generation)**:
   Translates the optimized Dart kernel into WebAssembly instructions and
   WasmGC struct and array type definitions, emitting `<name>.wasm`, the
   `<name>.mjs` JavaScript runtime loader, and `<name>.wasm.map`.
1. **`opt` (Binaryen optimization)**:
   Runs `wasm-opt` (at `-O1` and higher) to optimize Wasm instruction sequences
   and shrink binary size.

### WebAssembly standards used by Dart {:#wasm-standards}

The `dart2wasm` compiler targets standardized WebAssembly proposals to
minimize binary size and runtime overhead:

* **WebAssembly Garbage Collection (WasmGC)**:
  Maps Dart objects, classes, and collections directly to native
  garbage-collected heap structures managed by the browser engine (such as V8
  in Chrome). Because `dart2wasm` doesn't ship a custom linear-memory allocator
  or duplicate garbage collector alongside the browser's garbage collector,
  modules are smaller and avoid cross-heap memory cycles.
* **JS String Builtins (`wasm:js-string`)**:
  Lets Wasm modules use native JavaScript string operations and pass
  strings across the JavaScript and Wasm boundary without expensive UTF-8 or
  UTF-16 transcoding copies.
* **Exception Handling (Phase 4)**:
  Uses native WebAssembly exception tags (`try_table` and `exnref`) for
  low-overhead `try` and `catch` handling and stack trace generation.

### Performance benefits over JavaScript {:#why-wasm-improves-performance}

Compiling to WebAssembly improves startup latency and frame consistency
compared to compiling to JavaScript (`dart2js`):

* **Eliminates JS parse and JIT evaluation bottlenecks**:
  Large JavaScript bundles require the browser to download text, parse source
  tokens into an AST, and run multi-tier JIT compilation on the main thread
  before interactive rendering stabilizes.
* **Streaming background compilation**:
  Browsers compile compact binary `.wasm` bytecode across background threads
  while the network response streams (`WebAssembly.compileStreaming`).
* **Predictable execution from the first frame**:
  Closed-world AOT compilation and static dispatch tables deliver consistent
  execution times without waiting for JIT warm-up or suffering deoptimization
  bailouts.

## Profile Wasm performance and footprint {:#profile-wasm}

Before deploying,
profile your compiled app in [Chrome DevTools][]
to verify [Core Web Vitals][]
and inspect your `.wasm` download and memory footprint.

### Measure Core Web Vitals (LCP, INP, and CLS) {:#measure-core-web-vitals}

By default, `dart compile wasm` strips the WebAssembly `name` custom section,
so functions appear as numeric indices in CPU traces.
To keep readable Dart function and class names
without disabling production optimizations,
compile with the `-O2` and `--no-strip-wasm` flags:

```console
$ dart compile wasm -O2 --no-strip-wasm web/main.dart -o site/main.wasm
```

:::note
Use `--no-strip-wasm` only for local or staging profiling builds.
Retaining symbol names increases `.wasm` file size,
so omit `--no-strip-wasm` for your final release build
and when measuring network transfer size.
:::

Record a trace in the [Chrome DevTools Performance panel][]
to evaluate [Core Web Vitals][] and verify that `main.mjs` and `main.wasm`
fetch in parallel without main-thread long tasks or frequent Wasm-to-JS
interop calls. For general browser debugging setup, refer to
[Debugging Dart web apps][].

### Inspect Wasm module size and memory {:#inspect-wasm-footprint}

Use the Chrome DevTools **Network** and **Memory** panels to check wire size
and runtime heap usage:

* **Network transfer size**:
  Compile a stripped production build (`dart compile wasm -O2`, without the
  `--no-strip-wasm` flag) and use the [Chrome DevTools Network panel][]
  to compare compressed transfer size (`br` or `gzip`) against uncompressed
  size and confirm the `Content-Type: application/wasm` response header. If
  initial `.wasm` size delays load, split routes with the
  `--enable-deferred-loading` flag (refer to
  [Deferred loading](#deferred-loading)).
* **Runtime WasmGC heap**:
  Because `dart2wasm` compiles Dart objects to native WasmGC structs and
  arrays managed by V8's garbage collector (rather than an opaque
  linear-memory `ArrayBuffer`), live Dart instances appear directly in
  JavaScript heap profiles. Compile with the `--no-strip-wasm` flag so WasmGC
  type and field names remain readable when [recording heap snapshots][].

## Deploy Wasm in production {:#production-deployment}

To get the full startup and runtime benefits of WebAssembly in production,
configure your web server and release pipeline to stream, compress, and cache
`.wasm` modules and provide a JavaScript fallback for older browsers. Refer to
[Serve WebAssembly in production][serving-wasm] in the web deployment guide
for complete instructions on the following tasks:

* Serving `.wasm` files with the `Content-Type: application/wasm` header.
* Preloading `.mjs` and `.wasm` assets in parallel for streaming compilation.
* Pre-compressing `.wasm` binaries with Brotli (`brotli -q 11`) and Gzip.
* Configuring content-hashed immutable caching, atomic `.mjs` and `.wasm`
  deployments, and V8 Wasm code caching.
* Providing a `dart2js` fallback pathway for older browsers.

[wasm-org]: https://webassembly.org/
[Flutter]: {{site.flutter}}/wasm
[js-interop]: /interop/js-interop/
[past-js-interop]: /interop/js-interop/past-js-interop#next-generation-js-interop
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[migrated]: /interop/js-interop/package-web/
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
[dart-compile-wasm]: /tools/dart-compile#wasm
[`dhttpd`]: {{site.pub-pkg}}/dhttpd
[deferred loading]: /language/libraries#lazily-loading-a-library
[serving-wasm]: /web/deployment#serving-wasm-in-production
[manage-source-maps]: /web/deployment#manage-source-maps-and-unneeded-build-files
[sandbox]: https://github.com/mit-mit/sandbox
[Chrome DevTools]: https://developer.chrome.com/docs/devtools/
[Chrome DevTools Performance panel]: https://developer.chrome.com/docs/devtools/performance/
[Chrome DevTools Network panel]: https://developer.chrome.com/docs/devtools/network/
[recording heap snapshots]: https://developer.chrome.com/docs/devtools/memory-problems/heap-snapshots
[Debugging Dart web apps]: /web/debugging
[Core Web Vitals]: https://web.dev/articles/vitals
