---
title: relational_pattern_operand_type_not_assignable
description: >-
  Details about the relational_pattern_operand_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The constant expression type '{0}' is not assignable to the parameter type
'{1}' of the '{2}' operator._

## Description

The analyzer produces this diagnostic when the operand of a relational
pattern has a type that isn't assignable to the parameter of the operator
that will be invoked.

## Example

The following code produces this diagnostic because the operand in the
relational pattern (`0`) is an `int`, but the `>` operator defined in `C`
expects an object of type `C`:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > [!0!]:
      print('positive');
  }
}
```

## Common fixes

If the switch is using the correct value, then change the case to compare
the value to the right type of object:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > const C():
      print('positive');
  }
}
```

If the switch is using the wrong value, then change the expression used to
compute the value being matched:

```dart
class C {
  const C();

  bool operator >(C other) => true;

  int get toInt => 0;
}

void f(C c) {
  switch (c.toInt) {
    case > 0:
      print('positive');
  }
}
```
