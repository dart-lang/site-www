---
title: generic_struct_subclass
description: >-
  Details about the generic_struct_subclass
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't extend 'Struct' or 'Union' because '{0}' is generic._

## Description

The analyzer produces this diagnostic when a subclass of either `Struct`
or `Union` has a type parameter.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the class `S` defines
the type parameter `T`:

```dart
import 'dart:ffi';

final class [!S!]<T> extends Struct {
  external Pointer notEmpty;
}
```

## Common fixes

Remove the type parameters from the class:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

[ffi]: /interop/c-interop
