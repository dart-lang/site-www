---
title: ffi_native_must_be_external
description: >-
  Details about the ffi_native_must_be_external
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Native functions must be declared external._

## Description

The analyzer produces this diagnostic when a function annotated as being
`@Native` isn't marked as `external`.

## Example

The following code produces this diagnostic because the function `free` is
annotated as being `@Native`, but the function isn't marked as `external`:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
void [!free!](Pointer<Void> ptr) {}
```

## Common fixes

If the function is a native function, then add the modifier `external`
before the return type:

```dart
import 'dart:ffi';

@Native<Void Function(Pointer<Void>)>()
external void free(Pointer<Void> ptr);
```
