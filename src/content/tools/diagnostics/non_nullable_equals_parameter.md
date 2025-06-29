---
title: non_nullable_equals_parameter
description: >-
  Details about the non_nullable_equals_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The parameter type of '==' operators should be non-nullable._

## Description

The analyzer produces this diagnostic when an override of the operator
`==` has a parameter whose type is nullable. The language spec makes it
impossible for the argument of the method to be `null`, and the
parameter's type should reflect that.

## Example

The following code produces this diagnostic because the implementation of
the operator `==` in `C` :

```dart
class C {
  @override
  bool operator [!==!](Object? other) => false;
}
```

## Common fixes

Make the parameter type be non-nullable:

```dart
class C {
  @override
  bool operator ==(Object other) => false;
}
```
