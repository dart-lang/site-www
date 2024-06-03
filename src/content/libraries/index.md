---
title: Dart's core libraries
description: Learn about Dart's core libraries and APIs.
short-title: Core libraries
nextpage:
  url: /libraries/dart-core
  title: dart:core
---

<style>
  th:first-child {
    width: 80%;
  }
</style>

Dart has a rich set of core libraries that provide essentials for many everyday
programming tasks such as 
working on collections of objects (`dart:collection`), 
making calculations (`dart:math`), 
and encoding/decoding data (`dart:convert`). 
Additional APIs are available in
[commonly used packages](/resources/useful-packages).

## Library tour

The following guides cover how to use major features of Dart's core libraries.
They provide just an overview, and are by no means comprehensive.
Whenever you need more details about a library or its members,
consult the [Dart API reference.][Dart API]

[dart:core](/libraries/dart-core)
: Built-in types, collections, and other core functionality.
  This library is automatically imported into every Dart program.

[dart:async](/libraries/dart-async)
: Support for asynchronous programming, with classes such as Future and Stream.

[dart:math](/libraries/dart-math)
: Mathematical constants and functions, plus a random number generator.

[dart:convert](/libraries/dart-convert)
: Encoders and decoders for converting between different data representations,
  including JSON and UTF-8.

[dart:io](/libraries/dart-io)
: I/O for programs that can use the Dart VM,
  including Flutter apps, servers, and command-line scripts.

[dart:html](/libraries/dart-html)
: DOM and other APIs for browser-based apps.
  We now recommend using `package:web` over `dart:html`.


As mentioned, these pages are just an overview;
they cover only a few dart:* libraries
and no third-party libraries.

For an overview of all libraries that Dart supports on different platforms,
check out the [Multi-platform libraries](#multi-platform-libraries),
[Native platform libraries](#native-platform-libraries), and
[Web platform libraries](#web-platform-libraries) lists below.

Other places to find library information are the
[pub.dev site]({{site.pub}}) and the
[Dart web developer library guide][webdev libraries].
You can find API documentation for all dart:* libraries in the
[Dart API reference][Dart API] or, if you're using Flutter,
the [Flutter API reference][api-flutter].

To learn more about the Dart language,
check out the [language documentation and samples](/language).

[Dart API]: {{site.dart-api}}/{{site.sdkInfo.channel}}
[webdev libraries]: /web/libraries
[api-flutter]: {{site.flutter-api}}

## Multi-platform libraries

The following table lists the Dart core libraries that work on all
[Dart platforms](/overview#platform).

| Library                                       | Notes                         |
|-----------------------------------------------|-------------------------------|
| [`dart:core`][dart-core]<br>Built-in types, collections, and other core functionality for every Dart program. | |
| [`dart:async`][dart-async], [`package:async`][package-async]<br>Support for asynchronous programming, with classes such as `Future` and `Stream`.<br>`package:async` provides additional utilities around the `Future` and `Stream` types. | |
| [`dart:collection`][dart-collection], [`package:collection`][package-collection]<br>Classes and utilities that supplement the collection support in `dart:core`.<br>`package:collection` provides further collection implementations and functions for working on and with collections. | |
| [`dart:convert`][dart-convert], [`package:convert`][package-convert]<br>Encoders and decoders for converting between different data representations, including JSON and UTF-8.<br>`package:convert` provides additional encoders and decoders. ||
| [`dart:developer`][dart-developer]<br>Interaction with developer tools such as the debugger and inspector. | [Native JIT][jit] and the [development JavaScript compiler][] only |
| [`dart:math`][dart-math]<br>Mathematical constants and functions, plus a random number generator. | |
| [`dart:typed_data`][dart-typed_data], [`package:typed_data`][package-typed_data]<br>Lists that efficiently handle fixed sized data (for example, unsigned 8-byte integers) and SIMD numeric types.<br>`package:typed_data` provides further classes and functions working on typed data. | |

{:.table .table-striped}

## Native platform libraries

The following table lists the Dart core libraries that work on the
[Dart native platform](/overview#native-platform) (AOT- and JIT-compiled code).

| Library                                       | Notes                         |
|-----------------------------------------------|-------------------------------|
| [`dart:ffi`][dart-ffi], [`package:ffi`][package-ffi]<br>A foreign function interface that lets Dart code use native C APIs.<br>`package:ffi` contains utilities incl. support for converting Dart strings and C strings. | |
| [`dart:io`][dart-io], [`package:io`][package-io]<br>File, socket, HTTP, and other I/O support for non-web applications.<br>`package:io` provides functionality including support for ANSI colors, file copying, and standard exit codes. | |
| [`dart:isolate`][dart-isolate]<br> Concurrent programming using isolates: independent workers similar to threads. | |
| [`dart:mirrors`][dart-mirrors]<br> Basic reflection with support for introspection and dynamic invocation. | Experimental<br>[Native JIT][jit] only (_not_&nbsp;Flutter) |

{:.table .table-striped}

## Web platform libraries

The following table lists the Dart core libraries that work on the
[Dart web platform](/overview#web-platform) (code compiled to JavaScript).
The latest, recommended tools are **bolded**, and legacy tools are *italicized*
(visit [Javascript interoperability][] for more information).

| Library                                       | Notes                         |
|-----------------------------------------------|-------------------------------|
| [**`package:web`**][pkg-web] <br>Lightweight browser API bindings built around JS interop | Replaces all `dart:*` web libraries. Read the [migration guide][html-web]. |
| [**`dart:js_interop`**][js-interop] <br>Interop with JavaScript and browser APIs. | Replaces `package:js`. |
| [**`dart:js_interop_unsafe`**][js-interop-unsafe] <br>Utility methods to manipulate JavaScript objects dynamically. | Replaces `dart:js_util`. |
| [*`dart:html`*][dart-html] *(legacy)* <br>HTML elements and other resources for web-based applications. | Use `package:web` instead. |
| [*`dart:indexed_db`*][dart-indexed_db] *(legacy)* <br>Client-side key-value store with support for indexes.  | Use `package:web` instead. |
| [*`dart:js`*][dart-js], [*`dart:js_util`*][dart-js_util], [*`package:js`*][package-js] *(legacy)* <br>Low-level primitives and higher-level annotations for JS interop. | Use `dart:js_interop` or `dart:js_interop_unsafe` instead. |
| [*`dart:svg`*][dart-svg] *(legacy)* <br>Scalable Vector Graphics.  | Use `package:web` instead. |
| [*`dart:web_audio`*][dart-web_audio] *(legacy)* <br>High-fidelity audio programming in the browser. | Use `package:web` instead. |
| [*`dart:web_gl`*][dart-web_gl] *(legacy)* <br>3D programming in the browser. | Use `package:web` instead. |

{:.table .table-striped}


<!---
Multi-platform libraries
-->
[dart-core]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/dart-core-library.html
[dart-async]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/dart-async-library.html
[package-async]: {{site.pub-pkg}}/async
[dart-collection]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-collection/dart-collection-library.html
[package-collection]: {{site.pub-pkg}}/collection
[dart-convert]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-convert/dart-convert-library.html
[package-convert]: {{site.pub-pkg}}/convert
[dart-developer]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-developer/dart-developer-library.html
[dart-math]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-math/dart-math-library.html
[dart-typed_data]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-typed_data/dart-typed_data-library.html
[package-typed_data]: {{site.pub-pkg}}/typed_data

<!---
Native platform libraries
-->
[dart-ffi]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-ffi/dart-ffi-library.html
[package-ffi]: {{site.pub-pkg}}/ffi
[dart-io]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-io/dart-io-library.html
[package-io]: {{site.pub-pkg}}/io
[dart-isolate]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-isolate/dart-isolate-library.html
[dart-mirrors]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-mirrors/dart-mirrors-library.html

<!---
Web platform libraries
-->
[pkg-web]: {{site.pub-pkg}}/web
[js-interop]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/dart-js_interop-library.html
[js-interop-unsafe]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[dart-html]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-html/dart-html-library.html
[dart-indexed_db]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-indexed_db/dart-indexed_db-library.html
[dart-js]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js/dart-js-library.html
[package-js]: {{site.pub-pkg}}/js
[dart-js_util]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_util/dart-js_util-library.html
[dart-svg]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-svg/dart-svg-library.html
[dart-web_audio]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-web_audio/dart-web_audio-library.html
[dart-web_gl]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-web_gl/dart-web_gl-library.html

<!---
Misc
-->
[development JavaScript compiler]: /tools/webdev#serve
[jit]: /overview#native-platform
[JavaScript interoperability]: /interop/js-interop
[html-web]: /interop/js-interop/package-web