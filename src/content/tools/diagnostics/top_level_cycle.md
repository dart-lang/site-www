---
title: top_level_cycle
description: >-
  Details about the top_level_cycle
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type of '{0}' can't be inferred because it depends on itself through the
cycle: {1}._

## Description

The analyzer produces this diagnostic when a top-level variable has no type
annotation and the variable's initializer refers to the variable, either
directly or indirectly.

## Example

The following code produces this diagnostic because the variables `x` and
`y` are defined in terms of each other, and neither has an explicit type,
so the type of the other can't be inferred:

```dart
var x = y;
var y = [!x!];
```

## Common fixes

If the two variables don't need to refer to each other, then break the
cycle:

```dart
var x = 0;
var y = x;
```

If the two variables need to refer to each other, then give at least one of
them an explicit type:

```dart
int x = y;
var y = x;
```

Note, however, that while this code doesn't produce any diagnostics, it
will produce a stack overflow at runtime unless at least one of the
variables is assigned a value that doesn't depend on the other variables
before any of the variables in the cycle are referenced.
