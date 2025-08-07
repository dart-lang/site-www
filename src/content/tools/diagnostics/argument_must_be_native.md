---
title: argument_must_be_native
description: >-
  Details about the argument_must_be_native
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Argument to 'Native.addressOf' must be annotated with @Native_

## Description

The analyzer produces this diagnostic when the argument passed to
`Native.addressOf` isn't annotated with the `Native` annotation.

## Examples

The following code produces this diagnostic because the argument to
`addressOf` is a string, not a field, and strings can't be annotated:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf([!'f'!]));
}
```

The following code produces this diagnostic because the function `f` is
being passed to `addressOf` but isn't annotated as being `Native`:

```dart
import 'dart:ffi';

external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>([!f!]));
}
```

## Common fixes

If the argument isn't either a field or a function, then replace the
argument with a field or function that's annotated with `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```

If the argument is either a field or a function, then annotate the field
of function with `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```
