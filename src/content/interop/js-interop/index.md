---
title: JavaScript interoperability
shortTitle: JS interop
description: Integrate JavaScript code into your Dart web app.
nextpage:
  url: /interop/js-interop/usage
  title: Usage
---

Seamlessly integrate JavaScript libraries and APIs into your Dart web app.

## Overview {: #overview }

The [Dart web platform][] provides powerful tools to
call JavaScript from Dart and vice-versa and allows you to leverage the vast
JavaScript ecosystem without leaving your Dart code.

This page provides a central hub for learning about JavaScript interoperability
in Dart. You'll find resources to get you started, detailed usage guides, and
information on the `dart:js_interop` library. Whether you're looking to
use a specific JavaScript library, interact with browser APIs, or compile your
web app to [WebAssembly (Wasm)][wasm], this is the place to start.

Get started with JS interop:
  * [Get started with JavaScript interop]
  * [How to mock JavaScript interop objects]

Review the reference guides:
  * [Usage reference]
  * [JS types reference]

Interact with the browser:
  * [`package:web` and migration]

## WebAssembly (`dart2wasm`) support {: #wasm-support }

When compiling your Dart web app to [WebAssembly][wasm] (`dart compile wasm`),
keep these interoperability and performance practices in mind:

  * **Use `dart:js_interop` and `package:web`**:
    Legacy web and interop libraries (`dart:html`, `dart:js`, and `package:js`)
    are unsupported on Wasm targets.
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

Previous JavaScript interop libraries:
  * [Past JS interop]

Additional documentation on JavaScript interop:
  * [`dart:js_interop` API reference]
  * [`dart:js_interop_unsafe` API reference]

[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/
