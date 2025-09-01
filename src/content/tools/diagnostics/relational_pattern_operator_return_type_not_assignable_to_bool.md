---
title: relational_pattern_operator_return_type_not_assignable_to_bool
description: >-
  Details about the relational_pattern_operator_return_type_not_assignable_to_bool
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The return type of operators used in relational patterns must be assignable to
'bool'._

## Description

The analyzer produces this diagnostic when a relational pattern references
an operator that doesn't produce a value of type `bool`.

## Example

The following code produces this diagnostic because the operator `>`, used
in the relational pattern `> c2`, returns a value of type `int` rather
than a `bool`:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case [!>!] c2) {}
}
```

## Common fixes

If there's a different operator that should be used, then change the
operator:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case < c2) {}
}
```

If the operator is expected to return `bool`, then update the declaration
of the operator:

```dart
class C {
  const C();

  bool operator >(C c) => true;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case > c2) {}
}
```
