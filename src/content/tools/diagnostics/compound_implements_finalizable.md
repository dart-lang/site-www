---
title: compound_implements_finalizable
description: >-
  Details about the compound_implements_finalizable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The class '{0}' can't implement Finalizable._

## Description

The analyzer produces this diagnostic when a subclass of either `Struct`
or `Union` implements `Finalizable`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the class `S`
implements `Finalizable`:

```dart
import 'dart:ffi';

final class [!S!] extends Struct implements Finalizable {
  external Pointer notEmpty;
}
```

## Common fixes

Try removing the implements clause from the class:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer notEmpty;
}
```

[ffi]: /interop/c-interop
