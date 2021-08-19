---
title: Core libraries
description: Learn about Dart's core libraries and APIs.
---

Dart has a rich set of core libraries that provide essentials for many everyday
programming tasks such as working on collections of objects
(`dart:collection`), making calculations (`dart:math`), and encoding/decoding
data (`dart:convert`). Additional APIs are available in
[community contributed packages](/guides/libraries/useful-libraries).

<style>
  th:first-child {
    width: 80%;
  }
</style>

## Multi-platform libraries

The following table lists the Dart core libraries that work on all
[Dart platforms](/overview#platform).

<div class="table-wrapper" markdown="1">
|-----------------------------------------------+-------------------------------|
| Library                                       | Notes   |
|-----------------------------------------------|-------------------------------|
| [`dart:async`][dart-async]              <br> Support for asynchronous programming, with classes such as Future and Stream. | |
| [`dart:collection`][dart-collection]    <br> Classes and utilities that supplement the collection support in `dart:core`. | |
| [`dart:convert`][dart-convert]          <br> Encoders and decoders for converting between different data representations, including JSON and UTF-8. | |
| [`dart:core`][dart-core]                <br> Built-in types, collections, and other core functionality for every Dart program. | |
| [`dart:developer`][dart-developer]      <br> Interaction with developer tools such as the debugger and inspector. | JIT and dartdevc only |
| [`dart:math`][dart-math]                <br> Mathematical constants and functions, plus a random number generator. | |
| [`dart:typed_data`][dart-typed_data]    <br> Lists that efficiently handle fixed sized data (for example, unsigned 8-byte integers) and SIMD numeric types. | |
{:.table .table-striped}
</div>

## Native platform libraries

The following table lists the Dart core libraries that work on the
[Dart native platform](/overview#platform) (AOT- and JIT-compiled code).

<div class="table-wrapper" markdown="1">
|-----------------------------------------------+-------------------------------|
| Library                                       | Notes   |
|-----------------------------------------------|-------------------------------|
| [`dart:ffi`][dart-ffi]                  <br> A foreign function interface that lets Dart code use native C APIs. | |
| [`dart:io`][dart-io]                    <br> File, socket, HTTP, and other I/O support for non-web applications. | |
| [`dart:isolate`][dart-isolate]          <br> Concurrent programming using isolates: independent workers similar to threads. | |
| [`dart:mirrors`][dart-mirrors]          <br> Basic reflection with support for introspection and dynamic invocation. | Experimental<br>JIT only (_not_&nbsp;Flutter) |
{:.table .table-striped}
</div>

## Web platform libraries

The following table lists the Dart core libraries that work on the
[Dart web platform](/overview#platform) (code compiled to JavaScript).

<div class="table-wrapper" markdown="1">
|-----------------------------------------------+-------------------------------|
| Library                                       | Notes   |
|-----------------------------------------------|-------------------------------|
| [`dart:html`][dart-html]                <br> HTML elements and other resources for web-based applications. | |
| [`dart:indexed_db`][dart-indexed_db]    <br> Client-side key-value store with support for indexes. | |
| [`dart:js`][dart-js]                    <br> _Don't use._ Instead, use the `js` package, as described in [JavaScript interoperability][]. | *DEPRECATED* |
| [`dart:js_util`][dart-js_util]          <br> APIs to supplement missing functionality in `dart:html` or the `js` package. | |
| [`dart:svg`][dart-svg]                  <br> Scalable Vector Graphics. | |
| [`dart:web_audio`][dart-web_audio]      <br> High-fidelity audio programming in the browser. | |
| [`dart:web_gl`][dart-web_gl]            <br> 3D programming in the browser. | |
{:.table .table-striped}

</div>

[dart-async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart-collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart-convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart-core]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart-developer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-developer/dart-developer-library.html
[dart-ffi]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/dart-ffi-library.html
[dart-math]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart-collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart-typed_data]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[dart-cli]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-cli/dart-cli-library.html
[dart-io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html
[dart-isolate]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/dart-isolate-library.html
[dart-mirrors]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/dart-mirrors-library.html
[dart-html]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html
[dart-indexed_db]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[dart-js]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-js/dart-js-library.html
[dart-js_util]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-js_util/dart-js_util-library.html
[dart-svg]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-svg/dart-svg-library.html
[dart-web_audio]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[dart-web_gl]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_gl/dart-web_gl-library.html
[JavaScript interoperability]: /web/js-interop
