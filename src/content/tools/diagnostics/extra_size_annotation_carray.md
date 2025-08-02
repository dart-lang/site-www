---
title: extra_size_annotation_carray
description: >-
  Details about the extra_size_annotation_carray
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'Array's must have exactly one 'Array' annotation._

## Description

The analyzer produces this diagnostic when a field in a subclass of
`Struct` has more than one annotation describing the size of the native
array.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `a0` has two
annotations that specify the size of the native array:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(4)
  [!@Array(8)!]
  external Array<Uint8> a0;
}
```

## Common fixes

Remove all but one of the annotations:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
