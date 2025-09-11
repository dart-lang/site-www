---
title: missing_annotation_on_struct_field
description: >-
  Details about the missing_annotation_on_struct_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Fields of type '{0}' in a subclass of '{1}' must have an annotation indicating the native type._

## Description

The analyzer produces this diagnostic when a field in a subclass of
`Struct` or `Union` whose type requires an annotation doesn't have one.
The Dart types `int`, `double`, and `Array` are used to represent multiple
C types, and the annotation specifies which of the compatible C types the
field represents.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `x` doesn't
have an annotation indicating the underlying width of the integer value:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!int!] x;
}
```

## Common fixes

Add an appropriate annotation to the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int64()
  external int x;
}
```

[ffi]: /interop/c-interop
