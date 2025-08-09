---
title: duplicate_field_name
description: >-
  Details about the duplicate_field_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The field name '{0}' is already used in this record._

## Description

The analyzer produces this diagnostic when either a record literal or a
record type annotation contains a field whose name is the same as a
previously declared field in the same literal or type.

## Examples

The following code produces this diagnostic because the record literal has
two fields named `a`:

```dart
var r = (a: 1, [!a!]: 2);
```

The following code produces this diagnostic because the record type
annotation has two fields named `a`, one a positional field and the other
a named field:

```dart
void f((int a, {int [!a!]}) r) {}
```

## Common fixes

Rename one or both of the fields:

```dart
var r = (a: 1, b: 2);
```
