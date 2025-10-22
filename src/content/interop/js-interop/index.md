---
title: JavaScript interoperability
shortTitle: JS interop
description: Integrate JavaScript code into your Dart web app.
nextpage:
  url: /interop/js-interop/usage
  title: Usage
---

The [Dart web platform](/overview#web-platform) supports communication with
JavaScript apps and libraries, as well as browser APIs, using `dart:js_interop`.

Web developers can benefit from using external JS libraries in their Dart code,
without having to rewrite anything in Dart.

## Contents

For information on how to write and use JavaScript interop:
  * [Usage reference]
  * [JS types reference]

For information on interacting with web APIs:
  * [`package:web` and migration]

For tutorials and help:
  * [Getting started with Javascript interop]
  * [How to mock JavaScript interop objects]

For information on previous JavaScript interop libraries:
  * [Past JS interop]

For additional documentation on JavaScript interop:
  * [`dart:js_interop` API reference]
  * [`dart:js_interop_unsafe` API reference]

[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[Getting started with Javascript interop]: /interop/js-interop/start
[How to mock JavaScript interop objects]: /interop/js-interop/mock
[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/

## The evolution of JavaScript interop

In [Dart 3.3][] (Febrary 2024), the collection of features and APIs that 
allow developers access to JavaScript and browser bindings in their Dart code.
This next generation of web interop not only improves user experience,
but also enables [Wasm][] support, aligning Dart with the future of the Web.

The following table maps Dart's new JS and web interop solutions to
their past counterparts:

| New interop libraries        | Previous libraries                       |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}

Check out the [Past JS interop][] page for details of our the deprecated
features if you maintain legacy code.

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
[Past JS interop]: /interop/js-interop/past-js-interop/
