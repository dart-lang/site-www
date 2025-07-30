---
title: variable_type_mismatch
description: >-
  Details about the variable_type_mismatch
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A value of type '{0}' can't be assigned to a const variable of type '{1}'._

## Description

The analyzer produces this diagnostic when the evaluation of a constant
expression would result in a `CastException`.

## Example

The following code produces this diagnostic because the value of `x` is an
`int`, which can't be assigned to `y` because an `int` isn't a `String`:

```dart
const dynamic x = 0;
const String y = [!x!];
```

## Common fixes

If the declaration of the constant is correct, then change the value being
assigned to be of the correct type:

```dart
const dynamic x = 0;
const String y = '$x';
```

If the assigned value is correct, then change the declaration to have the
correct type:

```dart
const int x = 0;
const int y = x;
```
