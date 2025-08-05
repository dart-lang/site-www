---
title: missing_exception_value
description: >-
  Details about the missing_exception_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The method {0} must have an exceptional return value (the second argument) when the return type of the function is neither 'void', 'Handle', nor 'Pointer'._

## Description

The analyzer produces this diagnostic when an invocation of the method
`Pointer.fromFunction` or `NativeCallable.isolateLocal`
doesn't have a second argument (the exceptional
return value) when the type to be returned from the invocation is neither
`void`, `Handle`, nor `Pointer`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the type returned by
`f` is expected to be an 8-bit integer but the call to `fromFunction`
doesn't include an exceptional return argument:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.[!fromFunction!]<Int8 Function(Int8)>(f);
}
```

## Common fixes

Add an exceptional return type:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  Pointer.fromFunction<Int8 Function(Int8)>(f, 0);
}
```

[ffi]: /interop/c-interop
