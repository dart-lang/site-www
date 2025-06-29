---
title: invalid_field_type_in_struct
description: >-
  Details about the invalid_field_type_in_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Fields in struct classes can't have the type '{0}'. They can only be declared
as 'int', 'double', 'Array', 'Pointer', or subtype of 'Struct' or 'Union'._

## Description

The analyzer produces this diagnostic when a field in a subclass of
`Struct` has a type other than `int`, `double`, `Array`, `Pointer`, or
subtype of `Struct` or `Union`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `str` has
the type `String`, which isn't one of the allowed types for fields in a
subclass of `Struct`:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!String!] s;

  @Int32()
  external int i;
}
```

## Common fixes

Use one of the allowed types for the field:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  external Pointer<Utf8> s;

  @Int32()
  external int i;
}
```

[ffi]: /interop/c-interop
