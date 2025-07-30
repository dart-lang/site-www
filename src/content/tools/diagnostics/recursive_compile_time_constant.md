---
title: recursive_compile_time_constant
description: >-
  Details about the recursive_compile_time_constant
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The compile-time constant expression depends on itself._

## Description

The analyzer produces this diagnostic when the value of a compile-time
constant is defined in terms of itself, either directly or indirectly,
creating an infinite loop.

## Example

The following code produces this diagnostic twice because both of the
constants are defined in terms of the other:

```dart
const [!secondsPerHour!] = minutesPerHour * 60;
const [!minutesPerHour!] = secondsPerHour / 60;
```

## Common fixes

Break the cycle by finding an alternative way of defining at least one of
the constants:

```dart
const secondsPerHour = minutesPerHour * 60;
const minutesPerHour = 60;
```
