---
title: non_positive_array_dimension
description: >-
  Details about the non_positive_array_dimension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Array dimensions must be positive numbers._

## Description

The analyzer produces this diagnostic when a dimension given in an `Array`
annotation is less than or equal to zero (`0`).

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because an array dimension of
`-8` was provided:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array([!-8!])
  external Array<Uint8> a0;
}
```

## Common fixes

Change the dimension to be a positive integer:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

If this is a variable length inline array, change the annotation to
`Array.variable()`:

```dart
import 'dart:ffi';

final class MyStruct extends Struct {
  @Array.variable()
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
