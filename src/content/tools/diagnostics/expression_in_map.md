---
title: expression_in_map
description: >-
  Details about the expression_in_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Expressions can't be used in a map literal._

## Description

The analyzer produces this diagnostic when the analyzer finds an
expression, rather than a map entry, in what appears to be a map literal.

## Example

The following code produces this diagnostic:

```dart
var map = <String, int>{'a': 0, 'b': 1, [!'c'!]};
```

## Common fixes

If the expression is intended to compute either a key or a value in an
entry, fix the issue by replacing the expression with the key or the value.
For example:

```dart
var map = <String, int>{'a': 0, 'b': 1, 'c': 2};
```
