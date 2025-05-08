---
title: must_be_a_native_function_type
description: >-
  Details about the must_be_a_native_function_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The type '{0}' given to '{1}' must be a valid 'dart:ffi' native function type._

## Description

The analyzer produces this diagnostic when an invocation of either
`Pointer.fromFunction`, `DynamicLibrary.lookupFunction`,
or a `NativeCallable` constructor, has a type
argument(whether explicit or inferred) that isn't a native function type.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the type `T` can be
any subclass of `Function` but the type argument for `fromFunction` is
required to be a native function type:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<[!T!]>(f, 0);
  }
}
```

## Common fixes

Use a native function type as the type argument to the invocation:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<Int32 Function(Int32)>(f, 0);
  }
}
```

[ffi]: /interop/c-interop
