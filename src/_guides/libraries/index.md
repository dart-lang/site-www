---
title: Core libraries
description: Learn about Dart's core libraries and APIs.
toc: false
---

Dart has a rich set of core libraries that provide essentials for many everyday
programming tasks such as working on collections of objects
(`dart:collection`), making calculations (`dart:math`), and encoding/decoding
data (`dart:convert`). Additional APIs are available in
[community contributed packages](/guides/libraries/useful-libraries).

The following table lists all of the Dart core libraries.
Each library works on at least one [platform](/platforms).

<div class="table-wrapper" markdown="1">
|-----------------------------------------------+-------------------------------|
| Library                                       | Supported platforms   |
|-----------------------------------------------|-------------------------------|
| [`dart:async`][dart-async]              <br> Support for asynchronous programming, with classes such as Future and Stream. | All |
| [`dart:collection`][dart-collection]    <br> Classes and utilities that supplement the collection support in `dart:core`. | All |
| [`dart:convert`][dart-convert]          <br> Encoders and decoders for converting between different data representations, including JSON and UTF-8. | All |
| [`dart:core`][dart-core]                <br> Built-in types, collections, and other core functionality for every Dart program. | All |
| [`dart:developer`][dart-developer]      <br> Interaction with developer tools such as the debugger and inspector. | JIT<br>Web (experimental, dartdevc&nbsp;only) |
| [`dart:html`][dart-html]                <br> HTML elements and other resources for web-based applications. | Web |
| [`dart:indexed_db`][dart-indexed_db]    <br> Client-side key-value store with support for indexes. | Web |
| [`dart:io`][dart-io]                    <br> File, socket, HTTP, and other I/O support for non-web applications. | JIT<br>AOT |
| [`dart:isolate`][dart-isolate]          <br> Concurrent programming using isolates: independent workers similar to threads. | JIT<br>AOT |
| [`dart:js`][dart-js]                    <br> Interoperability with JavaScript. [PENDING: obsolete? use package:js instead?] | Web |
| [`dart:js_util`][dart-js_util]          <br> Utility methods to efficiently manipulate typed JSInterop objects. | Web |
| [`dart:math`][dart-math]                <br> Mathematical constants and functions, plus a random number generator. | All
| [`dart:mirrors`][dart-mirrors]          <br> Basic reflection with support for introspection and dynamic invocation. | JIT (experimental, _not_&nbsp;Flutter) |
| [`dart:typed_data`][dart-typed_data]    <br> Lists that efficiently handle fixed sized data (for example, unsigned 8-byte integers) and SIMD numeric types. | All |
| [`dart:web_audio`][dart-web_audio]      <br> High-fidelity audio programming in the browser. | Web |
| [`dart:web_gl`][dart-web_gl]            <br> 3D programming in the browser. | Web 
| [`dart:web_sql`][dart-web_sql]          <br> API for storing data in the browser that can be queried with SQL. | Web (obsolete) |
{:.table .table-striped}
</div>

[dart-async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart-collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart-convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart-core]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart-developer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-developer/dart-developer-library.html
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
[dart-web_sql]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_sql/dart-web_sql-library.html
