---
title: "C/C++ interop"
short-title: C-interop
description: "Dart supports C/C++ interop via a FFI mechanism"
toc: false
---

For Dart mobile, command-line, and server apps running on the [Dart Native
platform](/platforms/), you can call native C and C++ APIs from Dart using a
Foreign Function Interface
([FFI](https://en.wikipedia.org/wiki/Foreign_function_interface)) mechanism.

This mechanism is currently [in active
development](https://github.com/dart-lang/sdk/issues/34452), and is not yet
complete. For a small preview example, see [the `dart:ffi` sqllite
sample](https://github.com/dart-lang/sdk/blob/master/samples/ffi/sqlite/README.md).
