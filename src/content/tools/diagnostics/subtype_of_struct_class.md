---
title: subtype_of_struct_class
description: >-
  Details about the subtype_of_struct_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't extend '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._
_The class '{0}' can't implement '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._
_The class '{0}' can't mix in '{1}' because '{1}' is a subtype of 'Struct', 'Union', or 'AbiSpecificInteger'._

## Description

The analyzer produces this diagnostic when a class extends, implements, or
mixes in a class that extends either `Struct` or `Union`. Classes can only
extend either `Struct` or `Union` directly.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the class `C` extends
`S`, and `S` extends `Struct`:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends [!S!] {
  external Pointer g;
}
```

## Common fixes

If you're trying to define a struct or union that shares some fields
declared by a different struct or union, then extend `Struct` or `Union`
directly and copy the shared fields:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends Struct {
  external Pointer f;

  external Pointer g;
}
```

[ffi]: /interop/c-interop
