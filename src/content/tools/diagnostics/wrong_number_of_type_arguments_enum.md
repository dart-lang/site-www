---
title: wrong_number_of_type_arguments_enum
description: >-
  Details about the wrong_number_of_type_arguments_enum
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The enum is declared with {0} type parameters, but {1} type arguments were given._

## Description

The analyzer produces this diagnostic when an enum value in an enum that
has type parameters is instantiated and type arguments are provided, but
the number of type arguments isn't the same as the number of type
parameters.

## Example

The following code produces this diagnostic because the enum value `c`
provides one type argument even though the enum `E` is declared to have
two type parameters:

```dart
enum E<T, U> {
  c[!<int>!]()
}
```

## Common fixes

If the number of type parameters is correct, then change the number of
type arguments to match the number of type parameters:

```dart
enum E<T, U> {
  c<int, String>()
}
```

If the number of type arguments is correct, then change the number of type
parameters to match the number of type arguments:

```dart
enum E<T> {
  c<int>()
}
```
