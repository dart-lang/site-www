---
title: wrong_number_of_type_arguments_extension
description: >-
  Details about the wrong_number_of_type_arguments_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The extension '{0}' is declared with {1} type parameters, but {2} type arguments were given._

## Description

The analyzer produces this diagnostic when an extension that has type
parameters is used and type arguments are provided, but the number of type
arguments isn't the same as the number of type parameters.

## Example

The following code produces this diagnostic because the extension `E` is
declared to have a single type parameter (`T`), but the extension override
has two type arguments:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E[!<int, String>!](p).len;
}
```

## Common fixes

Change the type arguments so that there are the same number of type
arguments as there are type parameters:

```dart
extension E<T> on List<T> {
  int get len => length;
}

void f(List<int> p) {
  E<int>(p).len;
}
```
