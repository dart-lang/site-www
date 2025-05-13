---
title: deprecated_member_use
description: >-
  Details about the deprecated_member_use
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_'{0}' is deprecated and shouldn't be used._

_'{0}' is deprecated and shouldn't be used. {1}_

## Description

The analyzer produces this diagnostic when a deprecated library or class
member is used in a different package.

## Example

If the method `m` in the class `C` is annotated with `@deprecated`, then
the following code produces this diagnostic:

```dart
void f(C c) {
  c.[!m!]();
}
```

## Common fixes

The documentation for declarations that are annotated with `@deprecated`
should indicate what code to use in place of the deprecated code.
