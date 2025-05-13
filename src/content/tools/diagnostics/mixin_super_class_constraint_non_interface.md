---
title: mixin_super_class_constraint_non_interface
description: >-
  Details about the mixin_super_class_constraint_non_interface
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Only classes and mixins can be used as superclass constraints._

## Description

The analyzer produces this diagnostic when a type following the `on`
keyword in a mixin declaration is neither a class nor a mixin.

## Example

The following code produces this diagnostic because `F` is neither a class
nor a mixin:

```dart
typedef F = void Function();

mixin M on [!F!] {}
```

## Common fixes

If the type was intended to be a class but was mistyped, then replace the
name.

Otherwise, remove the type from the `on` clause.
