---
title: leaf_call_must_not_return_handle
description: >-
  Details about the leaf_call_must_not_return_handle
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_FFI leaf call can't return a 'Handle'._

## Description

The analyzer produces this diagnostic when the value of the `isLeaf`
argument in an invocation of either `Pointer.asFunction` or
`DynamicLibrary.lookupFunction` is `true` and the function that would be
returned would have a return type of `Handle`.

The analyzer also produces this diagnostic when the value of the `isLeaf`
argument in an `Native` annotation is `true` and the type argument on
the annotation is a function type whose return type is `Handle`.

In all of these cases, leaf calls are only supported for the types `bool`,
`int`, `float`, `double`, and, as a return type `void`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the function `p`
returns a `Handle`, but the `isLeaf` argument is `true`:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.[!asFunction!]<Object Function()>(isLeaf: true);
}
```

## Common fixes

If the function returns a handle, then remove the `isLeaf` argument:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Handle Function()>> p) {
  p.asFunction<Object Function()>();
}
```

If the function returns one of the supported types, then correct the type
information:

```dart
import 'dart:ffi';

void f(Pointer<NativeFunction<Int32 Function()>> p) {
  p.asFunction<int Function()>(isLeaf: true);
}
```

[ffi]: /interop/c-interop
