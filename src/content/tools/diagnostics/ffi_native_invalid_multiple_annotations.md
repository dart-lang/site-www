---
title: ffi_native_invalid_multiple_annotations
description: >-
  Details about the ffi_native_invalid_multiple_annotations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Native functions and fields must have exactly one `@Native` annotation._

## Description

The analyzer produces this diagnostic when there is more than one `Native`
annotation on a single declaration.

## Example

The following code produces this diagnostic because the function `f` has
two `Native` annotations associated with it:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>()
@[!Native!]<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```

## Common fixes

Remove all but one of the annotations:

```dart
import 'dart:ffi';

@Native<Int32 Function(Int32)>(isLeaf: true)
external int f(int v);
```
