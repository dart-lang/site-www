---
title: packed_annotation_alignment
description: >-
  Details about the packed_annotation_alignment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Only packing to 1, 2, 4, 8, and 16 bytes is supported._

## Description

The analyzer produces this diagnostic when the argument to the `Packed`
annotation isn't one of the allowed values: 1, 2, 4, 8, or 16.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the argument to the
`Packed` annotation (`3`) isn't one of the allowed values:

```dart
import 'dart:ffi';

@Packed([!3!])
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

## Common fixes

Change the alignment to be one of the allowed values:

```dart
import 'dart:ffi';

@Packed(4)
final class C extends Struct {
  external Pointer<Uint8> notEmpty;
}
```

[ffi]: /interop/c-interop
