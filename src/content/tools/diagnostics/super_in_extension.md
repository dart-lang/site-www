---
title: super_in_extension
description: >-
  Details about the super_in_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The 'super' keyword can't be used in an extension because an extension doesn't
have a superclass._

## Description

The analyzer produces this diagnostic when a member declared inside an
extension uses the `super` keyword . Extensions aren't classes and don't
have superclasses, so the `super` keyword serves no purpose.

## Example

The following code produces this diagnostic because `super` can't be used
in an extension:

```dart
extension E on Object {
  String get displayString => [!super!].toString();
}
```

## Common fixes

Remove the `super` keyword :

```dart
extension E on Object {
  String get displayString => toString();
}
```
