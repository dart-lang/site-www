---
title: extension_type_constructor_with_super_invocation
description: >-
  Details about the extension_type_constructor_with_super_invocation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Extension type constructors can't include super initializers._

## Description

The analyzer produces this diagnostic when a constructor in an extension
type includes an invocation of a super constructor in the initializer
list. Because extension types don't have a superclass, there's no
constructor to invoke.

## Example

The following code produces this diagnostic because the constructor `E.n`
invokes a super constructor in its initializer list:

```dart
extension type E(int i) {
  E.n() : i = 0, [!super!].n();
}
```

## Common fixes

Remove the invocation of the super constructor:

```dart
extension type E(int i) {
  E.n() : i = 0;
}
```
