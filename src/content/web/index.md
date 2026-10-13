---
title: Web platform
shortTitle: Web
description: Resources for developing Dart web apps.
showToc: false
---

Dart supports the web as one of its core [platforms][].
Dart-to-JavaScript compilers are available for both development
(with a quick edit-refresh cycle)
and production
(with a focus on code size and speed).
For production builds, you can also compile Dart to
[WebAssembly][wasm] (`dart compile wasm`).

In addition to compilers,
the Dart web platform provides [core libraries][],
access to the [DOM (Document Object Model)][DOM] through [`package:web`][],
and [interoperability for calling JavaScript][interop] (`dart:js_interop`)
from Dart.

You have the option of using Dart web with a higher-level framework.
Many apps that support web plus mobile or desktop are built
using [Flutter][] and [Flutter web][] support.
You can also use [Jaspr][] to build fast and dynamic HTML-based websites.
Flutter web support, Jaspr,
and other web frameworks for Dart are powered by the Dart web platform.

<div class="side-by-side">
<div class="centered-rows">
<p class="">
  <a href="/web/get-started" class="filled-button large-button">Build a web app with Dart</a>
</p>
</div>
<div class="centered-rows">
<figure>
  <img 
    src="/assets/img/flutter-gallery.jpg"
    alt="screenshot of Flutter Gallery">
  <figcaption>Flutter Gallery, running in a web browser</figcaption>
</figure>
</div>
</div>

[platforms]: /overview#platform
[wasm]: /web/wasm
[core libraries]: /libraries#web-platform-libraries
[DOM]: /web/get-started
[`package:web`]: /interop/js-interop/package-web
[Flutter]: {{site.flutter}}
[Flutter web]: {{site.flutter}}/web
[Jaspr]: https://jaspr.site
[interop]: /interop/js-interop
