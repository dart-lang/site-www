---
title: unnecessary_nan_comparison
description: >-
  Details about the unnecessary_nan_comparison
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_A double can't equal 'double.nan', so the condition is always 'false'._

_A double can't equal 'double.nan', so the condition is always 'true'._

## Description

The analyzer produces this diagnostic when a value is compared to
`double.nan` using either `==` or `!=`.

Dart follows the [IEEE 754] floating-point standard for the semantics of
floating point operations, which states that, for any floating point value
`x` (including NaN, positive infinity, and negative infinity),
- `NaN == x` is always false
- `NaN != x` is always true

As a result, comparing any value to NaN is pointless because the result is
already known (based on the comparison operator being used).

## Example

The following code produces this diagnostic because `d` is being compared
to `double.nan`:

```dart
bool isNaN(double d) => d [!== double.nan!];
```

## Common fixes

Use the getter `double.isNaN` instead:

```dart
bool isNaN(double d) => d.isNaN;
```

[IEEE 754]: https://en.wikipedia.org/wiki/IEEE_754
