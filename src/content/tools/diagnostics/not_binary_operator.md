---
title: not_binary_operator
description: >-
  Details about the not_binary_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_'{0}' isn't a binary operator._

## Description

The analyzer produces this diagnostic when an operator that can only be
used as a unary operator is used as a binary operator.

## Example

The following code produces this diagnostic because the operator `~` can
only be used as a unary operator:

```dart
var a = 5 [!~!] 3;
```

## Common fixes

Replace the operator with the correct binary operator:

```dart
var a = 5 - 3;
```
