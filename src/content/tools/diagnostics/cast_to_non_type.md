---
title: cast_to_non_type
description: >-
  Details about the cast_to_non_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The name '{0}' isn't a type, so it can't be used in an 'as' expression._

## Description

The analyzer produces this diagnostic when the name following the `as` in a
cast expression is defined to be something other than a type.

## Example

The following code produces this diagnostic because `x` is a variable, not
a type:

```dart
num x = 0;
int y = x as [!x!];
```

## Common fixes

Replace the name with the name of a type:

```dart
num x = 0;
int y = x as int;
```
