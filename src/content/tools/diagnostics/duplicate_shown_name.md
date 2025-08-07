---
title: duplicate_shown_name
description: >-
  Details about the duplicate_shown_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Duplicate shown name._

## Description

The analyzer produces this diagnostic when a name occurs multiple times in
a `show` clause. Repeating the name is unnecessary.

## Example

The following code produces this diagnostic because the name `min` is shown
more than once:

```dart
import 'dart:math' show min, [!min!];

var x = min(2, min(0, 1));
```

## Common fixes

If the name was mistyped in one or more places, then correct the mistyped
names:

```dart
import 'dart:math' show max, min;

var x = max(2, min(0, 1));
```

If the name wasn't mistyped, then remove the unnecessary name from the
list:

```dart
import 'dart:math' show min;

var x = min(2, min(0, 1));
```
