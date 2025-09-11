---
title: leaf_call_must_not_take_handle
description: >-
  Details about the leaf_call_must_not_take_handle
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_FFI leaf call can't take arguments of type 'Handle'._

## Description

The analyzer produces this diagnostic when the value of the `isLeaf`
argument in an invocation of either `Pointer.asFunction` or
`DynamicLibrary.lookupFunction` is `true` and the function that would be
returned would have a parameter of type `Handle`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the function `p` has a
parameter of type `Handle`, but the `isLeaf` argument is `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.[!asFunction!]<void Function(Object)>(isLeaf: true);
}
```

## Common fixes

If the function has at least one parameter of type `Handle`, then remove
the `isLeaf` argument:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Handle)>> p) {
  p.asFunction<void Function(Object)>();
}
```

If none of the function's parameters are `Handle`s, then correct the type
information:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Void Function(Int8)>> p) {
  p.asFunction<void Function(int)>(isLeaf: true);
}
```

[ffi]: /interop/c-interop
