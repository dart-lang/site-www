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
    width: 25%;
  }
</style>

Dart has a rich set of core libraries that provide essentials for many everyday
programming tasks such as working on collections of objects (`dart:collection`),
making calculations (`dart:math`), and encoding/decoding data (`dart:convert`).
Additional APIs can be found in [common packages](/resources/useful-packages).

## Dart major core libraries

The following guides cover how to use major features of Dart's core libraries.
They provide an overview, but aren't comprehensive.
To learn more about a library or its members,
consult the [Dart API reference][Dart API].

| Library                             | Capabilities                  |
|-------------------------------------|-------------------------------|
| [`dart:core`][dart-core-docs]       | Built-in types, collections, and other core functionality. This library is automatically imported into every Dart program. |
| [`dart:async`][dart-async-docs]     | Support for asynchronous programming, with classes such as Future and Stream. |
| [`dart:math`][dart-math-docs]       | Mathematical constants and functions, plus a random number generator. |
| [`dart:convert`][dart-convert-docs] | Encoders and decoders for converting between different data representations,  including JSON and UTF-8. |
| [`dart:io`][dart-io-docs]           | I/O for programs that can use the Dart VM, including Flutter apps, servers, and command-line scripts. |
| [`package:web`][dart-web-docs]      | DOM and other APIs for browser-based apps. |

{:.table .table-striped}

## Learn about libraries and language

These pages cover the few broad `dart:*` libraries.
They don't cover third-party libraries.

### Platform-specific libraries

To learn about all libraries that Dart supports on different platforms,
consult the following tables on this page.

* [Multi-platform libraries](#multi-platform-libraries)
* [Native platform libraries](#native-platform-libraries)
* [Web platform libraries](#web-platform-libraries)

### Third party libraries

To learn about third-party libraries, consult the following resources.

* [pub.dev site]({{site.pub}})
* [Dart web developer library guide][webdev libraries]

### API documentation

To learn about all of the libraries, consult the following resources.

* [Dart API reference][Dart API]
* [Flutter API reference][api-flutter]

### Dart language

To learn more about the Dart language,
consult the [language documentation and samples](/language).

[Dart API]: {{site.dart-api}}/{{site.sdkInfo.channel}}
[webdev libraries]: /web/libraries
[api-flutter]: {{site.flutter-api}}

## Multi-platform libraries

The following table lists the Dart core libraries that work on all
[Dart platforms](/overview#platform).

| Library                  | Capabilities                     |
|--------------------------|----------------------------------|
| [`dart:core`][dart-core] | Built-in types, collections, and other core functionality for every Dart program. |
| [`dart:async`][dart-async],<br>[`package:async`][pkg-async] | Support for asynchronous programming, with classes such as `Future` and `Stream`. `package:async` provides additional utilities around the `Future` and `Stream` types. |
| [`dart:collection`][dart-collection],<br>[`package:collection`][pkg-collection] | Classes and utilities that supplement the collection support in `dart:core`. `package:collection` provides further collection implementations and functions for working on and with collections. |
| [`dart:convert`][dart-convert],<br>[`package:convert`][pkg-convert] | Encoders and decoders for converting between different data representations, including JSON and UTF-8. `package:convert` provides additional encoders and decoders. |
| [`dart:developer`][dart-developer] | Interaction with developer tools such as the debugger and inspector.[Native JIT][jit] and the [development JavaScript compiler][] only |
| [`dart:math`][dart-math] | Mathematical constants and functions, plus a random number generator. |
| [`dart:typed_data`][dart-typed_data],<br>[`package:typed_data`][pkg-typed_data] | Lists that efficiently handle fixed sized data (for example, unsigned 8-byte integers) and SIMD numeric types. `package:typed_data` provides further classes and functions working on typed data. |

{:.table .table-striped}

## Native platform libraries

The following table lists the Dart core libraries that work on the
[Dart native platform][dart-np] (AOT- and JIT-compiled code).

| Library                        | Capabilities                  |
|--------------------------------|-------------------------------|
| [`dart:ffi`][dart-ffi]         | A foreign function interface that lets Dart code use native C APIs. |
| [`package:ffi`][pkg-ffi]       | `package:ffi` contains utilities include support for converting Dart strings and C strings. |
| [`dart:io`][dart-io]           | File, socket, HTTP, and other I/O support for non-web applications. |
| [`package:io`][pkg-io]         | `package:io` provides functionality including support for ANSI colors, file copying, and standard exit codes. |
| [`dart:isolate`][dart-isolate] | Concurrent programming using isolates: independent workers similar to threads. |
| [`dart:mirrors`][dart-mirrors] | Basic reflection with support for introspection and dynamic invocation. Experimental<br>[Native JIT][jit] only (_not_&nbsp;Flutter) |

{:.table .table-striped}

## Web platform libraries

The following table lists the Dart core libraries that work on the
[Dart web platform](/overview#web-platform) (code compiled to JavaScript).

| Library                                | Capabilities                  |
|----------------------------------------|-------------------------------|
| [`package:web`][pkg-web]               | Resources for web-based applications including HTML, structured data storage, scalable vector graphics, audio, and 3d models. Replaces [`dart:html`][dart-html],  [`dart:indexed_db`][dart-indexed_db], [`dart:svg`][dart-svg], [`dart:web_audio`][dart-web_audio], and [`dart:web_gl`][dart-web_gl] |
| [`package:js_interop`][pkg-js-interop], [`package:js_interop_unsafe`][pkg-js-interop-us] | Contains all the necessary members, including @JS, JS types, conversion functions, and various utility functions. `dart:js_interop_unsafe` contains members to look up properties dynamically. Replaces [`package:js`][pkg-js], [`dart:js`][dart-js], and [`dart:js_util`][dart-js_util] |

{:.table .table-striped}

{% comment %}
Multi-platform libraries
{% endcomment %}

[dart-core]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-core/dart-core-library.html
[dart-async]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-async/dart-async-library.html
[pkg-async]: {{site.pub-pkg}}/async
[dart-collection]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-collection/dart-collection-library.html
[pkg-collection]: {{site.pub-pkg}}/collection
[dart-convert]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-convert/dart-convert-library.html
[pkg-convert]: {{site.pub-pkg}}/convert
[dart-developer]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-developer/dart-developer-library.html
[dart-math]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-math/dart-math-library.html
[dart-typed_data]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-typed_data/dart-typed_data-library.html
[pkg-typed_data]: {{site.pub-pkg}}/typed_data

{% comment %}
Native platform libraries
{% endcomment %}

[dart-ffi]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-ffi/dart-ffi-library.html
[pkg-ffi]: {{site.pub-pkg}}/ffi
[dart-io]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-io/dart-io-library.html
[pkg-io]: {{site.pub-pkg}}/io
[dart-isolate]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-isolate/dart-isolate-library.html
[dart-mirrors]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-mirrors/dart-mirrors-library.html

{% comment %}
Web platform libraries
{% endcomment %}

[pkg-web]: {{site.pub-pkg}}/web
[dart-html]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-html/dart-html-library.html
[dart-indexed_db]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-indexed_db/dart-indexed_db-library.html
[dart-js]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js/dart-js-library.html
[pkg-js]: {{site.pub-pkg}}/js
[dart-js_util]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_util/dart-js_util-library.html
[dart-svg]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-svg/dart-svg-library.html
[dart-web_audio]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-web_audio/dart-web_audio-library.html
[dart-web_gl]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-web_gl/dart-web_gl-library.html
[pkg-js-interop]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/dart-js_interop-library.html
[pkg-js-interop-us]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html

{% comment %}
Miscellaneous
{% endcomment %}

[dart-np]: /overview#native-platform
[development JavaScript compiler]: /tools/webdev#serve
[jit]: /overview#native-platform

{% comment %}
Core libraries
{% endcomment %}

[dart-core-docs]: /libraries/dart-core
[dart-async-docs]: /libraries/dart-async
[dart-math-docs]: /libraries/dart-math
[dart-convert-docs]: /libraries/dart-convert
[dart-io-docs]: /libraries/dart-io
[dart-web-docs]: /interop/js-interop/package-web
