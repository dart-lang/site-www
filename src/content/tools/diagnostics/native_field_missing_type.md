---
title: native_field_missing_type
description: >-
  Details about the native_field_missing_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The native type of this field could not be inferred and must be specified in
the annotation._

## Description

The analyzer produces this diagnostic when an `@Native`-annotated field
requires a type hint on the annotation to infer the native type.

Dart types like `int` and `double` have multiple possible native
representations. Since the native type needs to be known at compile time
to generate the correct load and stores when accessing the field, an
explicit type must be given.

## Example

The following code produces this diagnostic because the field `f` has
the type `int` (for which multiple native representations exist), but no
explicit type parameter on the `Native` annotation:

```dart
import 'dart:ffi';

@Native()
external int [!f!];
```

## Common fixes

To fix this diagnostic, find out the correct native representation from
the native declaration of the field. Then, add the corresponding type to
the annotation. For instance, if `f` was declared as an `uint8_t` in C,
the Dart field should be declared as:

```dart
import 'dart:ffi';

@Native<Uint8>()
external int f;
```

For more information about FFI, see [C interop using dart:ffi][ffi].

[ffi]: /interop/c-interop
