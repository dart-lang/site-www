---
title: super_in_extension_type
description: >-
  Details about the super_in_extension_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The 'super' keyword can't be used in an extension type because an extension
type doesn't have a superclass._

## Description

The analyzer produces this diagnostic when `super` is used in an instance
member of an extension type. Extension types don't have superclasses, so
there's no inherited member that could be invoked.

## Example

The following code produces this diagnostic because :

```dart
extension type E(String s) {
  void m() {
    [!super!].m();
  }
}
```

## Common fixes

Replace or remove the `super` invocation:

```dart
extension type E(String s) {
  void m() {
    s.toLowerCase();
  }
}
```
