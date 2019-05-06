---
title: "C & C++ interop using FFI"
description: "To use C or C++ code in your Dart program, use the dart:ffi library (currently in preview)."
toc: false
---

Dart mobile, command-line, and server apps running on the [Dart Native
platform](/platforms/) can use a foreign function interface
([FFI](https://en.wikipedia.org/wiki/Foreign_function_interface))
to call native C and C++ APIs.

This mechanism is currently [in active
development](https://github.com/dart-lang/sdk/issues/34452) and is not yet
complete. For a small preview example, see the [dart:ffi sqllite
sample.](https://github.com/dart-lang/sdk/blob/master/samples/ffi/sqlite/README.md)
