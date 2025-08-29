---
title: field_in_struct_with_initializer
description: >-
  Details about the field_in_struct_with_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Fields in subclasses of 'Struct' and 'Union' can't have initializers._

## Description

The analyzer produces this diagnostic when a field in a subclass of
`Struct` has an initializer.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `p` has an
initializer:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer [!p!] = nullptr;
}
```

## Common fixes

Remove the initializer:

```dart
// @dart = 2.9
import 'dart:ffi';

final class C extends Struct {
  Pointer p;
}
```

[ffi]: /interop/c-interop
