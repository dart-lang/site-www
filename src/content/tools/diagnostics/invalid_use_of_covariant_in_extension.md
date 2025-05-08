---
title: invalid_use_of_covariant_in_extension
description: >-
  Details about the invalid_use_of_covariant_in_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Can't have modifier '{0}' in an extension._

## Description

The analyzer produces this diagnostic when a member declared inside an
extension uses the keyword `covariant` in the declaration of a parameter.
Extensions aren't classes and don't have subclasses, so the keyword serves
no purpose.

## Example

The following code produces this diagnostic because `i` is marked as being
covariant:

```dart
extension E on String {
  void a([!covariant!] int i) {}
}
```

## Common fixes

Remove the `covariant` keyword:

```dart
extension E on String {
  void a(int i) {}
}
```
