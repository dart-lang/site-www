---
title: must_return_void
description: >-
  Details about the must_return_void
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The return type of the function passed to 'NativeCallable.listener' must be 'void' rather than '{0}'._

## Description

The analyzer produces this diagnostic when you pass a function
that doesn't return `void` to the `NativeCallable.listener` constructor.

`NativeCallable.listener` creates a native callable that can be invoked
from any thread. The native code that invokes the callable sends a message
back to the isolate that created the callable, and doesn't wait for a
response. So it isn't possible to return a result from the callable.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the function
`f` returns `int` rather than `void`.

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  NativeCallable<Int32 Function(Int32)>.listener([!f!]);
}
```

## Common fixes

Change the return type of the function to `void`.

```dart
import 'dart:ffi';

void f(int i) => print(i * 2);

void g() {
  NativeCallable<Void Function(Int32)>.listener(f);
}
```

[ffi]: /interop/c-interop
