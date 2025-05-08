---
title: wrong_number_of_parameters_for_operator
description: >-
  Details about the wrong_number_of_parameters_for_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Operator '-' should declare 0 or 1 parameter, but {0} found._

_Operator '{0}' should declare exactly {1} parameters, but {2} found._

## Description

The analyzer produces this diagnostic when a declaration of an operator has
the wrong number of parameters.

## Example

The following code produces this diagnostic because the operator `+` must
have a single parameter corresponding to the right operand:

```dart
class C {
  int operator [!+!](a, b) => 0;
}
```

## Common fixes

Add or remove parameters to match the required number:

```dart
class C {
  int operator +(a) => 0;
}
```
