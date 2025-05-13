---
title: field_initialized_by_multiple_initializers
description: >-
  Details about the field_initialized_by_multiple_initializers
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The field '{0}' can't be initialized twice in the same constructor._

## Description

The analyzer produces this diagnostic when the initializer list of a
constructor initializes a field more than once. There is no value to allow
both initializers because only the last value is preserved.

## Example

The following code produces this diagnostic because the field `f` is being
initialized twice:

```dart
class C {
  int f;

  C() : f = 0, [!f!] = 1;
}
```

## Common fixes

Remove one of the initializers:

```dart
class C {
  int f;

  C() : f = 0;
}
```
