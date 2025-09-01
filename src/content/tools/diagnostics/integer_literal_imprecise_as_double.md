---
title: integer_literal_imprecise_as_double
description: >-
  Details about the integer_literal_imprecise_as_double
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The integer literal is being used as a double, but can't be represented as a
64-bit double without overflow or loss of precision: '{0}'._

## Description

The analyzer produces this diagnostic when an integer literal is being
implicitly converted to a double, but can't be represented as a 64-bit
double without overflow or loss of precision. Integer literals are
implicitly converted to a double if the context requires the type `double`.

## Example

The following code produces this diagnostic because the integer value
`9223372036854775807` can't be represented exactly as a double:

```dart
double x = [!9223372036854775807!];
```

## Common fixes

If you need to use the exact value, then use the class `BigInt` to
represent the value:

```dart
var x = BigInt.parse('9223372036854775807');
```

If you need to use a double, then change the value to one that can be
represented exactly:

```dart
double x = 9223372036854775808;
```
