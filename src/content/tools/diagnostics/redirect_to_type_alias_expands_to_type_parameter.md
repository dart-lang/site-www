---
title: redirect_to_type_alias_expands_to_type_parameter
description: >-
  Details about the redirect_to_type_alias_expands_to_type_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A redirecting constructor can't redirect to a type alias that expands to a type
parameter._

## Description

The analyzer produces this diagnostic when a redirecting factory
constructor redirects to a type alias, and the type alias expands to one of
the type parameters of the type alias. This isn't allowed because the value
of the type parameter is a type rather than a class.

## Example

The following code produces this diagnostic because the redirect to `B<A>`
is to a type alias whose value is `T`, even though it looks like the value
should be `A`:

```dart
class A implements C {}

typedef B<T> = T;

abstract class C {
  factory C() = [!B!]<A>;
}
```

## Common fixes

Use either a class name or a type alias that is defined to be a class
rather than a type alias defined to be a type parameter:

```dart
class A implements C {}

abstract class C {
  factory C() = A;
}
```
