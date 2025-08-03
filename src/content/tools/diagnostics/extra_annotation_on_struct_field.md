---
title: extra_annotation_on_struct_field
description: >-
  Details about the extra_annotation_on_struct_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Fields in a struct class must have exactly one annotation indicating the native
type._

## Description

The analyzer produces this diagnostic when a field in a subclass of
`Struct` has more than one annotation describing the native type of the
field.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `x` has two
annotations describing the native type of the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  [!@Int16()!]
  external int x;
}
```

## Common fixes

Remove all but one of the annotations:

```dart
import 'dart:ffi';
final class C extends Struct {
  @Int32()
  external int x;
}
```

[ffi]: /interop/c-interop
