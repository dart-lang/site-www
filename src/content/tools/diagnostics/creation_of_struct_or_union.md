---
title: creation_of_struct_or_union
description: >-
  Details about the creation_of_struct_or_union
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Subclasses of 'Struct' and 'Union' are backed by native memory, and can't be instantiated by a generative constructor._

## Description

The analyzer produces this diagnostic when a subclass of either `Struct`
or `Union` is instantiated using a generative constructor.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the class `C` is being
instantiated using a generative constructor:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  [!C!]();
}
```

## Common fixes

If you need to allocate the structure described by the class, then use the
`ffi` package to do so:

```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class C extends Struct {
  @Int32()
  external int a;
}

void f() {
  final pointer = calloc.allocate<C>(4);
  final c = pointer.ref;
  print(c);
  calloc.free(pointer);
}
```

[ffi]: /interop/c-interop
