---
title: not_enough_positional_arguments
description: >-
  Details about the not_enough_positional_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_1 positional argument expected by '{0}', but 0 found._

_1 positional argument expected, but 0 found._

_{0} positional arguments expected by '{2}', but {1} found._

_{0} positional arguments expected, but {1} found._

## Description

The analyzer produces this diagnostic when a method or function invocation
has fewer positional arguments than the number of required positional
parameters.

## Example

The following code produces this diagnostic because `f` declares two
required parameters, but only one argument is provided:

```dart
void f(int a, int b) {}
void g() {
  f(0[!)!];
}
```

## Common fixes

Add arguments corresponding to the remaining parameters:

```dart
void f(int a, int b) {}
void g() {
  f(0, 1);
}
```
