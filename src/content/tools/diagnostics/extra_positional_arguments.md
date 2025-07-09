---
title: extra_positional_arguments
description: >-
  Details about the extra_positional_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Too many positional arguments: {0} expected, but {1} found._

## Description

The analyzer produces this diagnostic when a method or function invocation
has more positional arguments than the method or function allows.

## Example

The following code produces this diagnostic because `f` defines 2
parameters but is invoked with 3 arguments:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2, [!3!]);
}
```

## Common fixes

Remove the arguments that don't correspond to parameters:

```dart
void f(int a, int b) {}
void g() {
  f(1, 2);
}
```
