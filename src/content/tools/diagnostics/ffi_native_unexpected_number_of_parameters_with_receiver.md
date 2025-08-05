---
title: ffi_native_unexpected_number_of_parameters_with_receiver
description: >-
  Details about the ffi_native_unexpected_number_of_parameters_with_receiver
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Unexpected number of Native annotation parameters. Expected {0} but has {1}. Native instance method annotation must have receiver as first argument._

## Description

The analyzer produces this diagnostic when the type argument used on the
`@Native` annotation of a native method doesn't include a type for the
receiver of the method.

## Example

The following code produces this diagnostic because the type argument on
the `@Native` annotation (`Void Function(Double)`) doesn't include a type
for the receiver of the method:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(Double)>()
  external void [!f!](double x);
}
```

## Common fixes

Add an initial parameter whose type is the same as the class in which the
native method is being declared:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(C, Double)>()
  external void f(double x);
}
```
