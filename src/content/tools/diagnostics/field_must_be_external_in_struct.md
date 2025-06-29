---
title: field_must_be_external_in_struct
description: >-
  Details about the field_must_be_external_in_struct
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Fields of 'Struct' and 'Union' subclasses must be marked external._

## Description

The analyzer produces this diagnostic when a field in a subclass of either
`Struct` or `Union` isn't marked as being `external`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `a` isn't
marked as being `external`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  int [!a!];
}
```

## Common fixes

Add the required `external` modifier:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int16()
  external int a;
}
```

[ffi]: /interop/c-interop
