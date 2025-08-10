---
title: invocation_of_non_function
description: >-
  Details about the invocation_of_non_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_'{0}' isn't a function._

## Description

The analyzer produces this diagnostic when it finds a function invocation,
but the name of the function being invoked is defined to be something other
than a function.

## Example

The following code produces this diagnostic because `Binary` is the name of
a function type, not a function:

```dart
typedef Binary = int Function(int, int);

int f() {
  return [!Binary!](1, 2);
}
```

## Common fixes

Replace the name with the name of a function.
