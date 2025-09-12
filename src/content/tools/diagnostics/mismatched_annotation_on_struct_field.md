---
title: mismatched_annotation_on_struct_field
description: >-
  Details about the mismatched_annotation_on_struct_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation doesn't match the declared type of the field._

## Description

The analyzer produces this diagnostic when the annotation on a field in a
subclass of `Struct` or `Union` doesn't match the Dart type of the field.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the annotation
`Double` doesn't match the Dart type `int`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external int x;
}
```

## Common fixes

If the type of the field is correct, then change the annotation to match:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

If the annotation is correct, then change the type of the field to match:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Double()
  external double x;
}
```

[ffi]: /interop/c-interop
