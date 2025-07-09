---
title: definitely_unassigned_late_local_variable
description: >-
  Details about the definitely_unassigned_late_local_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The late local variable '{0}' is definitely unassigned at this point._

## Description

The analyzer produces this diagnostic when [definite assignment][] analysis
shows that a local variable that's marked as `late` is read before being
assigned.

## Example

The following code produces this diagnostic because `x` wasn't assigned a
value before being read:

```dart
void f(bool b) {
  late int x;
  print([!x!]);
}
```

## Common fixes

Assign a value to the variable before reading from it:

```dart
void f(bool b) {
  late int x;
  x = b ? 1 : 0;
  print(x);
}
```

[definite assignment]: /resources/glossary#definite-assignment
