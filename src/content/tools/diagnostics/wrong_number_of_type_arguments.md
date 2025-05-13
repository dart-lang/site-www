---
title: wrong_number_of_type_arguments
description: >-
  Details about the wrong_number_of_type_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The type '{0}' is declared with {1} type parameters, but {2} type arguments
were given._

## Description

The analyzer produces this diagnostic when a type that has type parameters
is used and type arguments are provided, but the number of type arguments
isn't the same as the number of type parameters.

The analyzer also produces this diagnostic when a constructor is invoked
and the number of type arguments doesn't match the number of type
parameters declared for the class.

## Examples

The following code produces this diagnostic because `C` has one type
parameter but two type arguments are provided when it is used as a type
annotation:

```dart
class C<E> {}

void f([!C<int, int>!] x) {}
```

The following code produces this diagnostic because `C` declares one type
parameter, but two type arguments are provided when creating an instance:

```dart
class C<E> {}

var c = [!C<int, int>!]();
```

## Common fixes

Add or remove type arguments, as necessary, to match the number of type
parameters defined for the type:

```dart
class C<E> {}

void f(C<int> x) {}
```
