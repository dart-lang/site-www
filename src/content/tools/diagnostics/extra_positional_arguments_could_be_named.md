---
title: extra_positional_arguments_could_be_named
description: >-
  Details about the extra_positional_arguments_could_be_named
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Too many positional arguments: {0} expected, but {1} found._

## Description

The analyzer produces this diagnostic when a method or function invocation
has more positional arguments than the method or function allows, but the
method or function defines named parameters.

## Example

The following code produces this diagnostic because `f` defines 2
positional parameters but has a named parameter that could be used for the
third argument:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, [!3!]);
}
```

## Common fixes

If some of the arguments should be values for named parameters, then add
the names before the arguments:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2, c: 3);
}
```

Otherwise, remove the arguments that don't correspond to positional
parameters:

```dart
void f(int a, int b, {int? c}) {}
void g() {
  f(1, 2);
}
```
