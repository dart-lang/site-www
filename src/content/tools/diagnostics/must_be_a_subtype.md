---
title: must_be_a_subtype
description: >-
  Details about the must_be_a_subtype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The type '{0}' must be a subtype of '{1}' for '{2}'._

## Description

The analyzer produces this diagnostic in two cases:
- In an invocation of `Pointer.fromFunction`, or a
  `NativeCallable` constructor where the type argument
  (whether explicit or inferred) isn't a supertype of the type of the
  function passed as the first argument to the method.
- In an invocation of `DynamicLibrary.lookupFunction` where the first type
  argument isn't a supertype of the second type argument.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because the type of the
function `f` (`String Function(int)`) isn't a subtype of the type
argument `T` (`Int8 Function(Int8)`):

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>([!f!], 5.0);
}
```

## Common fixes

If the function is correct, then change the type argument to match:

```dart
import 'dart:ffi';

typedef T = Float Function(Float);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5.0);
}
```

If the type argument is correct, then change the function to match:

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

int f(int i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5);
}
```

[ffi]: /interop/c-interop
