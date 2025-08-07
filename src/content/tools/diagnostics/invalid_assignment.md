---
title: invalid_assignment
description: >-
  Details about the invalid_assignment
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_A value of type '{0}' can't be assigned to a variable of type '{1}'._

## Description

The analyzer produces this diagnostic when the static type of an expression
that is assigned to a variable isn't assignable to the type of the
variable.

## Example

The following code produces this diagnostic because the type of the
initializer (`int`) isn't assignable to the type of the variable
(`String`):

```dart
int i = 0;
String s = [!i!];
```

## Common fixes

If the value being assigned is always assignable at runtime, even though
the static types don't reflect that, then add an explicit cast.

Otherwise, change the value being assigned so that it has the expected
type. In the previous example, this might look like:

```dart
int i = 0;
String s = i.toString();
```

If you can't change the value, then change the type of the variable to be
compatible with the type of the value being assigned:

```dart
int i = 0;
int s = i;
```
