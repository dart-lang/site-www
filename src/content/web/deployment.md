---
title: Web deployment
description: >-
  Learn how to build and serve your Dart web app for production deployment.
---

Deploying a Dart web app works like deploying any other web app.
You compile your Dart code to production WebAssembly (`dart compile wasm`) or
JavaScript (`dart compile js` or `webdev build`), optimize the generated
assets, and serve them from a web server or content delivery network (CDN).

## Build your app {:#compiling-to-javascript}

For production deployments, you can compile your Dart web app to
[WebAssembly (Wasm)][wasm] (`dart2wasm`), JavaScript (`dart2js`), or both (with
JavaScript as a fallback for older browsers):

* **Compile to WebAssembly (`dart compile wasm`)**:
  Produces compact `.wasm` binary bytecode and a companion `.mjs` runtime
  loader for fast startup and consistent frame execution in modern browsers.
* **Compile to JavaScript (`webdev build` or `dart compile js`)**:
  Produces minified, tree-shaken `.dart.js` output compatible with all
  JavaScript-capable browsers.

With a few additional steps, you can make your deployable app
[smaller, faster, and more reliable](#make-your-app-smaller-faster-and-more-reliable).

### Compile to WebAssembly {:#compile-to-wasm}

Use the [`dart compile wasm`][dart-compile-wasm] command with the `-O2` flag
(or higher) to build optimized WebAssembly output:

```console
$ dart compile wasm -O2 web/main.dart -o build/web/main.wasm
```

This command generates `build/web/main.wasm`, the companion JavaScript runtime
`build/web/main.mjs`, and the source map `build/web/main.wasm.map`. Refer to
[WebAssembly compilation][wasm] for compiler optimization flags and setup
steps, and [Serve WebAssembly in production](#serving-wasm-in-production) for
server configuration.

### Compile to JavaScript with webdev {:#compile-using-webdev}

[Use the `webdev build` command][build] (or run
[`dart compile js`][dart-compile-js] directly) to create a deployable
JavaScript build of your app. The `webdev build` command compiles your code to
JavaScript and saves the result as `build/web/main.dart.js`. You can use
[any option available to `dart compile js`][dart-compile-js] with
`webdev build`.

### Make your app smaller, faster, and more reliable

The following practices help make your production web app smaller, faster, and
more secure:

* [Use deferred loading to reduce initial download size][deferred-size]
* [Follow best practices for web apps][best-practices]
* [Manage source maps and unneeded build files][manage-source-maps]

#### Use deferred loading to reduce your app's initial size

You can use Dart's support for deferred loading to split rarely used features
into separate modules loaded on demand.
For language syntax details, refer to the libraries guide on
[deferred loading][].
When compiling to WebAssembly, pass the `--enable-deferred-loading` flag and
configure a `loadDeferredModules` loader callback as shown in
[Wasm deferred loading][wasm-deferred-loading].

#### Follow best practices for web apps

General web performance practices apply to Dart web apps:

* [Profile Wasm performance and footprint][profile-wasm]
* [Fast load times][fast-load-times]
* [Web Fundamentals][web-fundamentals]
  (especially [Optimizing Content Efficiency][content-efficiency])
* [Progressive Web Apps][pwa]
* [Lighthouse][lighthouse]

#### Manage source maps and unneeded build files {:#manage-source-maps-and-unneeded-build-files}

By default, Dart web compilers (`dart compile js` and `dart compile wasm`)
generate source map files (`.js.map` and `.wasm.map`) alongside the compiled
output and embed a `sourceMappingURL` reference in the generated artifact.
While source maps are useful for debugging and symbolicating production stack
traces, serving them on public web servers can expose internal details:

* **Unminified symbols and structure**:
  Source maps let browser DevTools reconstruct original class names,
  function names, and source logic.
* **Developer file paths**:
  Source maps can include file system URIs (such as `file:///Users/...`) from
  the build machine.

:::warning
To keep your symbol names, code structure, and local build paths private,
don't deploy source map files to public web hosts.
:::

Depending on your deployment strategy, handle source maps in one of two ways:

* **Disable source maps at build time**:
  If you don't need source maps for production debugging or error reporting,
  pass the `--no-source-maps` flag to the compiler:

  ```console
  $ dart compile wasm --no-source-maps -O2 -o build/main.wasm web/main.dart
  $ dart compile js --no-source-maps -O2 -o build/main.dart.js web/main.dart
  ```

* **Upload map files to error monitoring and exclude them from public hosting**:
  If you use an error-monitoring or crash-reporting service (such as Sentry or
  Bugsnag), keep the `.js.map` or `.wasm.map` files during compilation and
  upload them directly to your monitoring service to symbolicate production
  stack traces. Then exclude or remove them from your public web server or CDN
  directory:

  ```console
  # From the root directory of your app:
  $ find build -type f \( -name "*.js.map" -o -name "*.wasm.map" \) -exec rm {} +
  ```

## Serve WebAssembly in production {:#serving-wasm-in-production}

When deploying a Dart application compiled with `dart compile wasm`, configure
your web server, CDN, and HTML bootstrap loader to maximize streaming
compilation speed and caching efficiency.

### Configure the `Content-Type: application/wasm` header {:#wasm-mime-type}

Web servers, CDNs, and object storage buckets must serve `.wasm` files with the
`application/wasm` MIME type (and `.mjs` files with `text/javascript` or
`application/javascript`):

* Browsers require `Content-Type: application/wasm` to execute
  `WebAssembly.compileStreaming()`.
* If the server returns `application/octet-stream` or omits the header,
  streaming compilation fails or falls back to waiting for the entire download
  to finish before compilation begins.

### Stream compilation and preload resources {:#streaming-compilation}

Avoid a sequential network waterfall (`index.html` → `main.mjs` → `main.wasm`).
Start fetching `main.wasm` and `main.mjs` in parallel from the HTML `<head>`
with high fetch priority, and pass the `fetch()` promise directly to
`compileStreaming()`:

```html title="index.html"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Production Dart Wasm App</title>
  <!-- Preload the .mjs runtime and .wasm module in parallel -->
  <link rel="modulepreload" href="/main.mjs">
  <link rel="preload" href="/main.wasm" as="fetch" type="application/wasm" crossorigin="anonymous" fetchpriority="high">
</head>
<body>
  <div id="app"></div>
  <script type="module">
    import { compileStreaming } from '/main.mjs';

    const wasmResponsePromise = fetch('/main.wasm', { priority: 'high' });
    const compiledApp = await compileStreaming(wasmResponsePromise);
    const instantiatedApp = await compiledApp.instantiate({});
    instantiatedApp.invokeMain();
  </script>
</body>
</html>
```

### Enable Brotli and Gzip HTTP compression {:#http-compression}

* Pre-compress `.wasm` and `.mjs` artifacts during your release build by using
  Brotli (`brotli -q 11`) and Gzip (`gzip -9`) as a fallback
  (`Content-Encoding: br` or `gzip`).
* WasmGC binaries contain structured type sections and bytecode patterns that
  compress by 35–50% with Brotli, substantially reducing payload transfer and
  download time during initial page load.

### Configure caching and atomic deployments {:#wasm-caching}

* **Content-hashed filenames**:
  Fingerprint both outputs (for example, `main.a1b2c3d4.mjs` and
  `main.a1b2c3d4.wasm`) and serve them with
  `Cache-Control: public, max-age=31536000, immutable`. Serve `index.html` with
  `Cache-Control: no-cache`.
* **Atomic deployment**:
  Always deploy `main.mjs`, `main.wasm`, and any deferred
  `<name>_module<id>.wasm` chunks from the same build together.
  The generated `.mjs` file contains numeric import and export indices bound
  to that specific `.wasm` build. Mixing a cached `.mjs` file with a newly
  deployed `.wasm` binary causes instantiation errors.
* **V8 Wasm code caching**:
  When Chrome streams a `.wasm` resource over HTTPS with valid HTTP caching
  headers, V8 automatically caches the compiled native machine code on disk.
  Repeat visits skip Wasm compilation altogether.

### Provide a JavaScript fallback (`dart2js`) {:#js-fallback}

To support older browsers that lack WasmGC, JS String Builtins, or Phase 4
Exception Handling, provide a JavaScript fallback:

1. Build both targets in your release pipeline:

   ```console
   $ dart compile wasm -O2 web/main.dart -o site/main.wasm
   $ dart compile js -O2 web/main.dart -o site/main.dart.js
   ```

1. In your bootstrap script, attempt Wasm streaming compilation and fall back
   to loading `main.dart.js` if instantiation fails or the browser doesn't
   support the required Wasm features:

   ```js
   async function bootApp() {
     let instantiatedApp;
     try {
       const wasmPromise = fetch('/main.wasm');
       const { compileStreaming } = await import('/main.mjs');
       const compiledApp = await compileStreaming(wasmPromise);
       instantiatedApp = await compiledApp.instantiate({});
     } catch (wasmError) {
       console.warn('Wasm initialization failed; falling back to JS:', wasmError);
       const fallbackScript = document.createElement('script');
       fallbackScript.src = '/main.dart.js';
       document.head.appendChild(fallbackScript);
       return;
     }
     instantiatedApp.invokeMain();
   }

   bootApp();
   ```

## Serve your app {:#serving-your-app}

You can host your compiled Dart web app on any static web host or CDN, such as
GitHub Pages or Firebase Hosting.

### GitHub Pages

If your app doesn't use server-side routing, you can serve the app by using
[GitHub Pages][gh-pages].
The [peanut][] package automatically produces a `gh-pages` branch for any Dart
web app.

The [startup_namer example][startup-namer]
is hosted on GitHub Pages.
Its files are in the `gh-pages` branch of the
[filiph/startup_namer repo][startup-namer-repo]
and were built with [peanut][].

### Firebase

{% comment %}
TODO: Give an example of how to deploy with Firebase, which originally was shown on https://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/
{% endcomment %}

To learn more about deploying with Firebase, refer to the following resources:

* The [Firebase Hosting documentation][firebase-hosting]
  describes how to deploy web apps with Firebase.
* In the Firebase Hosting documentation,
  [Configure Hosting Behavior][firebase-config]
  covers custom headers (such as `Content-Type` and `Cache-Control`),
  redirects, and rewrites.

[wasm]: /web/wasm
[profile-wasm]: /web/wasm#profile-wasm
[wasm-deferred-loading]: /web/wasm#deferred-loading
[dart-compile-wasm]: /tools/dart-compile#wasm
[dart-compile-js]: /tools/dart-compile#prod-compile-options
[deferred-size]: #use-deferred-loading-to-reduce-your-apps-initial-size
[best-practices]: #follow-best-practices-for-web-apps
[manage-source-maps]: #manage-source-maps-and-unneeded-build-files
[deferred loading]: /language/libraries#lazily-loading-a-library
[fast-load-times]: https://web.dev/fast/
[web-fundamentals]: https://developers.google.com/web/fundamentals/
[content-efficiency]: https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/
[pwa]: https://web.dev/progressive-web-apps/
[lighthouse]: https://developers.google.com/web/tools/lighthouse/
[gh-pages]: https://pages.github.com/
[startup-namer]: https://filiph.github.io/startup_namer/
[startup-namer-repo]: https://github.com/filiph/startup_namer
[firebase-hosting]: https://firebase.google.com/docs/hosting/
[firebase-config]: https://firebase.google.com/docs/hosting/full-config
[build]: /tools/webdev#build
[peanut]: {{site.pub-pkg}}/peanut
