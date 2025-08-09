---
title: argument_must_be_a_constant
description: >-
  Details about the argument_must_be_a_constant
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Argument '{0}' must be a constant._

## Description

The analyzer produces this diagnostic when an invocation of either
`Pointer.asFunction` or `DynamicLibrary.lookupFunction` has an `isLeaf`
argument whose value isn't a constant expression.

The analyzer also produces this diagnostic when an invocation of either
`Pointer.fromFunction` or `NativeCallable.isolateLocal` has an
`exceptionalReturn` argument whose value isn't a constant expression.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the value of the
`isLeaf` argument is a parameter, and hence isn't a constant:

```dart
import 'dart:ffi';

int Function(int) fromPointer(
    Pointer<NativeFunction<Int8 Function(Int8)>> p, bool isLeaf) {
  return p.asFunction(isLeaf: [!isLeaf!]);
}
```

## Common fixes

If there's a suitable constant that can be used, then replace the argument
with a constant:

```dart
import 'dart:ffi';

const isLeaf = false;

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: isLeaf);
}
```

If there isn't a suitable constant, then replace the argument with a
boolean literal:

```dart
import 'dart:ffi';

int Function(int) fromPointer(Pointer<NativeFunction<Int8 Function(Int8)>> p) {
  return p.asFunction(isLeaf: true);
}
```

[ffi]: /interop/c-interop
