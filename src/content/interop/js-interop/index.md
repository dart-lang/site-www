---
title: JavaScript interoperability
shortTitle: JS interop
description: Integrate JavaScript code into your Dart web app.
nextpage:
  url: /interop/js-interop/usage
  title: Usage
---

Integrate JavaScript libraries and APIs into Dart web apps.

## Overview {: #overview }

The [Dart web platform][] provides tools to call JavaScript from Dart and Dart
from JavaScript, bringing the JavaScript ecosystem directly to Dart code.

Find getting-started resources, usage guides, and `dart:js_interop` library
documentation for calling JavaScript libraries, interacting with browser APIs,
and compiling web apps to [WebAssembly (Wasm)][wasm].

Get started with JS interop:
  * [Get started with JavaScript interop]
  * [How to mock JavaScript interop objects]

Review the reference guides:
  * [Usage reference]
  * [JS types reference]

Interact with the browser:
  * [`package:web` and migration]

## WebAssembly (`dart2wasm`) support {: #wasm-support }

When compiling Dart web apps to [WebAssembly][wasm] (`dart compile wasm`),
keep these interoperability and performance practices in mind:

  * **Use `dart:js_interop` and `package:web`**:
    Deprecated legacy web and interop libraries (`dart:html`, `dart:js`,
    `dart:js_util`, and `package:js`) are unsupported on Wasm targets.
  * **Minimize high-frequency calls across the Wasm and JS boundary**:
    In performance-critical code or tight loops, keep computation in Dart or
    batch values rather than making repeated interop calls per iteration.
  * **Find Wasm-compatible packages**:
    Use the [`wasm-ready`][] filter on [pub.dev][] to verify that packages use
    `dart:js_interop` and `package:web`.

[Dart web platform]: /web
[wasm]: /web/wasm
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}
[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[Get started with JavaScript interop]: /interop/js-interop/start
[How to mock JavaScript interop objects]: /interop/js-interop/mock

<a id="next-generation-js-interop" aria-hidden="true"></a>
<a id="deprecated-features" aria-hidden="true"></a>

## Additional resources {: #additional-resources }

Explore previous JavaScript interop libraries:
  * [Past JS interop]

Explore the API reference documentation:
  * [`dart:js_interop` API reference]
  * [`dart:js_interop_unsafe` API reference]

[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/
