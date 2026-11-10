---
title: Web platform
shortTitle: Web
description: Resources for developing Dart web apps.
showToc: false
---

Dart supports the web as one of its core [platforms][].
For development, the Dart development JavaScript compiler (`ddc`) provides a
quick edit-refresh cycle.
For production [deployment][], you can compile Dart to
[WebAssembly (Wasm)][wasm] (`dart2wasm`) for fast startup and consistent frame
execution in modern browsers, or to minified JavaScript (`dart2js`).

In addition to compilers,
the Dart web platform provides [core libraries][],
access to the [Document Object Model (DOM)][DOM] through [`package:web`][],
and [interoperability for calling JavaScript][interop] from Dart.

You can also pair Dart web with a higher-level framework.
You can build multi-platform apps for web, mobile, and desktop
by using [Flutter][] and [Flutter web][],
or use [Jaspr][] to build HTML-based websites.
The Dart web platform powers Flutter web, Jaspr,
and other Dart web frameworks.

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
    alt="Flutter Gallery app running in a web browser">
  <figcaption>Flutter Gallery, running in a web browser</figcaption>
</figure>
</div>
</div>

[platforms]: /overview#platform
[deployment]: /web/deployment
[wasm]: /web/wasm
[core libraries]: /libraries#web-platform-libraries
[DOM]: /web/get-started
[`package:web`]: /interop/js-interop/package-web
[Flutter]: {{site.flutter}}
[Flutter web]: {{site.flutter}}/web
[Jaspr]: https://jaspr.site
[interop]: /interop/js-interop
