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
information on the latest `dart:js_interop` library. Whether you're looking to
use a specific JavaScript library, or interact with browser APIs, this is the
place to start.

Get started wtih JS interop:
  * [Getting started with Javascript interop]
  * [How to mock JavaScript interop objects]

Review the reference guides:
  * [Usage reference]
  * [JS types reference]

Interact with the browser:
  * [`package:web` and migration]

[Dart web platform]: /web
[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[Getting started with Javascript interop]: /interop/js-interop/start
[How to mock JavaScript interop objects]: /interop/js-interop/mock

## The evolution of JavaScript interop {: #next-generation-js-interop }

[Dart 3.3][] introduces a new generation of JS interop that offers
a unified set of features and APIs to access JavaScript and browser
functionalities within your Dart code. This modern approach enhances the
developer experience and enables WebAssembly ([Wasm][]) support, aligning
Dart with the future of the web.

The following table maps Dart's new JS and web interop solutions to
their past counterparts:

| New interop libraries        | Previous libraries                       |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}

[Dart 3.3]: https://blog.dart.dev/dart-3-3-325bf2bf6c13
[Wasm]: /web/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/
[`dart:svg`]: {{site.dart-api}}/dart-svg/
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`package:js`]: {{site.pub-api}}/js
[`dart:js`]: {{site.dart-api}}/dart-js/
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/

## Work with deprecated features {: #deprecated-features }

If you maintain legacy code, you can continue to work with some deprecated features.
To learn more about JS interop deprecated features, see the [Past JS interop][] guide.

## Additional resources {: #additional-resources }

Previous JavaScript interop libraries:
  * [Past JS interop]

Additional documentation on JavaScript interop:
  * [`dart:js_interop` API reference]
  * [`dart:js_interop_unsafe` API reference]

[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/
