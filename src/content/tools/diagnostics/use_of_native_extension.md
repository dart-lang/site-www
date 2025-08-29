---
title: use_of_native_extension
description: >-
  Details about the use_of_native_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dart native extensions are deprecated and aren't available in Dart 2.15._

## Description

The analyzer produces this diagnostic when a library is imported using the
`dart-ext` scheme.

## Example

The following code produces this diagnostic because the native library `x`
is being imported using a scheme of `dart-ext`:

```dart
import [!'dart-ext:x'!];
```

## Common fixes

Rewrite the code to use `dart:ffi` as a way of invoking the contents of the
native library.
