---
title: invalid_exception_value
description: >-
  Details about the invalid_exception_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The method {0} can't have an exceptional return value (the second argument)
when the return type of the function is either 'void', 'Handle' or 'Pointer'._

## Description

The analyzer produces this diagnostic when an invocation of the method
`Pointer.fromFunction` or `NativeCallable.isolateLocal`
has a second argument (the exceptional return
value) and the type to be returned from the invocation is either `void`,
`Handle` or `Pointer`.

For more information about FFI, see [C interop using dart:ffi][ffi].

## Example

The following code produces this diagnostic because a second argument is
provided when the return type of `f` is `void`:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f, [!42!]);
}
```

## Common fixes

Remove the exception value:

```dart
import 'dart:ffi';

typedef T = Void Function(Int8);

void f(int i) {}

void g() {
  Pointer.fromFunction<T>(f);
}
```

[ffi]: /interop/c-interop
