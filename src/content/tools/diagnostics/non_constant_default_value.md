---
title: non_constant_default_value
description: >-
  Details about the non_constant_default_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The default value of an optional parameter must be constant._

## Description

The analyzer produces this diagnostic when an optional parameter, either
named or positional, has a default value that isn't a compile-time
constant.

## Example

The following code produces this diagnostic:

```dart
var defaultValue = 3;

void f([int value = [!defaultValue!]]) {}
```

## Common fixes

If the default value can be converted to be a constant, then convert it:

```dart
const defaultValue = 3;

void f([int value = defaultValue]) {}
```

If the default value needs to change over time, then apply the default
value inside the function:

```dart
var defaultValue = 3;

void f([int? value]) {
  value ??= defaultValue;
}
```
