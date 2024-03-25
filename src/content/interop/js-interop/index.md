---
title: JavaScript interoperability
short-title: JS interop
description: Integrate JavaScript code into your Dart web app.
---

The [Dart web platform](/overview#web-platform) supports communication with
JavaScript apps and libraries, as well as browser APIs, using `dart:js_interop`.

Web developers can benefit from using external JS libraries in their Dart code,
without having to rewrite anything in Dart.

## Next-generation JS interop

The Dart team [recently][] overhauled the collection of features and APIs that allow
developers access to JavaScript and browser bindings in their Dart code.
This next generation of web interop not only improves user experience,
but also enables [Wasm][] support, aligning Dart with the future of the Web.

The following table maps Dart's new JS and web interop solutions to
their past counterparts:

<div class="table-wrapper" markdown="1">

| New interop libraries        | Previous libraries                       |
|------------------------------|------------------------------------------|
| [`package:web`][] | [`dart:html`][] <br> [`dart:indexed_db`][] <br> [`dart:svg`][] <br> [`dart:web_audio`][] <br> [`dart:web_gl`][] |
| [`dart:js_interop`][] <br> [`dart:js_interop_unsafe`][] | [`package:js`][] <br> [`dart:js`][] <br> [`dart:js_util`][] |

{:.table .table-striped}
</div>

The Dart interop story has been under heavy development for some time now;
check out the [Past JS interop][] page for a more in depth summary on past
iterations.

[recently]: https://medium.com/dartlang/dart-3-3-325bf2bf6c13
[Wasm]: {{site.flutter-docs}}/platform-integration/web/wasm
[`package:web`]: {{site.pub-pkg}}/web
[`dart:html`]: {{site.dart-api}}/dart-html/dart-html-library.html
[`dart:svg`]: {{site.dart-api}}/dart-svg/dart-svg-library.html
[`dart:indexed_db`]: {{site.dart-api}}/dart-indexed_db/dart-indexed_db-library.html
[`dart:web_audio`]: {{site.dart-api}}/dart-web_audio/dart-web_audio-library.html
[`dart:web_gl`]: {{site.dart-api}}/dart-web_gl/dart-web_gl-library.html
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[`package:js`]: {{site.pub-api}}/js
[`dart:js`]: {{site.dart-api}}/dart-js/dart-js-library.html
[`dart:js_util`]: {{site.dart-api}}/dart-js_util/dart-js_util-library.html
[Past JS interop]: /interop/js-interop/past-js-interop/

## Overview

For information on how to write and use JavaScript interop:
  * [Usage reference]
  * [JS types reference]

For information on interacting with web APIs:
  * [`package:web` and migration]

For tutorials and help:
  * [How to mock JavaScript interop objects]

For information on previous JavaScript interop libraries:
  * [Past JS interop]

For additional documentation on JavaScript interop:
  * [`dart:js_interop` API reference]
  * [`dart:js_interop_unsafe` API reference]

[Usage reference]: /interop/js-interop/usage
[JS types reference]: /interop/js-interop/js-types
[`package:web` and migration]: /interop/js-interop/package-web
[How to mock JavaScript interop objects]: /interop/js-interop/mock
[Past JS interop]: /interop/js-interop/past-js-interop
[`dart:js_interop` API reference]: {{site.dart-api}}/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe` API reference]: {{site.dart-api}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
