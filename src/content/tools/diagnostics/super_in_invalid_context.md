---
title: super_in_invalid_context
description: >-
  Details about the super_in_invalid_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Invalid context for 'super' invocation._

## Description

The analyzer produces this diagnostic when the keyword `super` is used
outside of an instance method.

## Example

The following code produces this diagnostic because `super` is used in a
top-level function:

```dart
void f() {
  [!super!].f();
}
```

## Common fixes

Rewrite the code to not use `super`.
