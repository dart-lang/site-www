---
title: Native extensions for the standalone Dart VM
description: The original way for command-line Dart apps to call C/C++ functions.
---

{{site.alert.note}}
The extension mechanism which was previously discussed on this page --
native extensions -- has been deprecated in Dart 2.14 and will be removed in
Dart 2.15.

If you need to call existing code written in C or C++, see
[C & C++ interop using FFI](/server/c-interop).

This deprecation does not affect use-cases where Dart VM is embedded as library
into another application. The Dart Embedding API (as defined in
[`include/dart_api.h`] header) remains supported for such use cases. The Dart
team currently does not provide any guides on how to embed the Dart VM into your
application, however there are [examples] maintained by the community which
demonstrate the necessary glue code.
{{site.alert.end}}

[`include/dart_api.h`]:  https://github.com/dart-lang/sdk/blob/master/runtime/include/dart_api.h
[examples]: https://github.com/fuzzybinary/dart-embedding-example
