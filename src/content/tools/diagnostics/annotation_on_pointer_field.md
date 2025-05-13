---
title: annotation_on_pointer_field
description: >-
  Details about the annotation_on_pointer_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Fields in a struct class whose type is 'Pointer' shouldn't have any
annotations._

## Description

The analyzer produces this diagnostic when a field that's declared in a
subclass of `Struct` and has the type `Pointer` also has an annotation
associated with it.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the field `p`, which
has the type `Pointer` and is declared in a subclass of `Struct`, has the
annotation `@Double()`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external Pointer<Int8> p;
}
```

## Common fixes

Remove the annotations from the field:

```dart
import 'dart:ffi';

final class C extends Struct {
  external Pointer<Int8> p;
}
```

[ffi]: /interop/c-interop
