---
title: missing_size_annotation_carray
description: >-
  Details about the missing_size_annotation_carray
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Fields of type 'Array' must have exactly one 'Array' annotation._

## Description

The analyzer produces this diagnostic when a field in a subclass of either
`Struct` or `Union` has a type of `Array` but doesn't have a single
`Array` annotation indicating the dimensions of the array.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `a0` doesn't
have an `Array` annotation:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!Array<Uint8>!] a0;
}
```

## Common fixes

Ensure that there's exactly one `Array` annotation on the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
