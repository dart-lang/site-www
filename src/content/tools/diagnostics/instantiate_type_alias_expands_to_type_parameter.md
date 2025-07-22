---
title: instantiate_type_alias_expands_to_type_parameter
description: >-
  Details about the instantiate_type_alias_expands_to_type_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Type aliases that expand to a type parameter can't be instantiated._

## Description

The analyzer produces this diagnostic when a constructor invocation is
found where the type being instantiated is a type alias for one of the type
parameters of the type alias. This isn't allowed because the value of the
type parameter is a type rather than a class.

## Example

The following code produces this diagnostic because it creates an instance
of `A`, even though `A` is a type alias that is defined to be equivalent to
a type parameter:

```dart
typedef A<T> = T;

void f() {
  const [!A!]<int>();
}
```

## Common fixes

Use either a class name or a type alias defined to be a class, rather than
a type alias defined to be a type parameter:

```dart
typedef A<T> = C<T>;

void f() {
  const A<int>();
}

class C<T> {
  const C();
}
```
