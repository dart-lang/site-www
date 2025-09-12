---
title: non_bool_operand
description: >-
  Details about the non_bool_operand
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The operands of the operator '{0}' must be assignable to 'bool'._

## Description

The analyzer produces this diagnostic when one of the operands of either
the `&&` or `||` operator doesn't have the type `bool`.

## Example

The following code produces this diagnostic because `a` isn't a Boolean
value:

```dart
int a = 3;
bool b = [!a!] || a > 1;
```

## Common fixes

Change the operand to a Boolean value:

```dart
int a = 3;
bool b = a == 0 || a > 1;
```
