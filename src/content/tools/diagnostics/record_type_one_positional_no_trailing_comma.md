---
title: record_type_one_positional_no_trailing_comma
description: >-
  Details about the record_type_one_positional_no_trailing_comma
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A record type with exactly one positional field requires a trailing comma._

## Description

The analyzer produces this diagnostic when a record type annotation with a
single positional field doesn't have a trailing comma after the field.

In some locations a record type with a single positional field could also
be a parenthesized expression. A trailing comma is required to
disambiguate these two valid interpretations.

## Example

The following code produces this diagnostic because the record type has
one positional field, but doesn't have a trailing comma:

```dart
void f((int[!)!] r) {}
```

## Common fixes

Add a trailing comma:

```dart
void f((int,) r) {}
```
