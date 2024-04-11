---
title: Native extensions for the standalone Dart VM
description: The original way for command-line Dart apps to call C/C++ functions.
toc: false
---

:::note
The extension mechanism that was previously discussed
on this page—_native extensions_—was removed in Dart 2.15.

If you need to call existing code written in C or C++, see the
[FFI documentation](/server/c-interop).

A mechanism that's similar to 
native extensions—the [Dart Embedding API][`include/dart_api.h`]—is
supported when the Dart VM is
embedded as a library into another application. 
For examples of how to use the Dart Embedding API, see
[these examples maintained by the community][examples].
:::

[`include/dart_api.h`]: {{site.repo.dart.sdk}}/blob/main/runtime/include/dart_api.h
[examples]: https://github.com/fuzzybinary/dart_shared_libray
