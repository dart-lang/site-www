---
title: duplicate_hidden_name
description: >-
  Details about the duplicate_hidden_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Duplicate hidden name._

## Description

The analyzer produces this diagnostic when a name occurs multiple times in
a `hide` clause. Repeating the name is unnecessary.

## Example

The following code produces this diagnostic because the name `min` is
hidden more than once:

```dart
import 'dart:math' hide min, [!min!];

var x = pi;
```

## Common fixes

If the name was mistyped in one or more places, then correct the mistyped
names:

```dart
import 'dart:math' hide max, min;

var x = pi;
```

If the name wasn't mistyped, then remove the unnecessary name from the
list:

```dart
import 'dart:math' hide min;

var x = pi;
```
