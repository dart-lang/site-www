---
title: integer_literal_out_of_range
description: >-
  Details about the integer_literal_out_of_range
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The integer literal {0} can't be represented in 64 bits._

## Description

The analyzer produces this diagnostic when an integer literal has a value
that is too large (positive) or too small (negative) to be represented in a
64-bit word.

## Example

The following code produces this diagnostic because the value can't be
represented in 64 bits:

```dart
var x = [!9223372036854775810!];
```

## Common fixes

If you need to represent the current value, then wrap it in an instance of
the class `BigInt`:

```dart
var x = BigInt.parse('9223372036854775810');
```
