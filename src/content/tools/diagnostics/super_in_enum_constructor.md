---
title: super_in_enum_constructor
description: >-
  Details about the super_in_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The enum constructor can't have a 'super' initializer._

## Description

The analyzer produces this diagnostic when the initializer list in a
constructor in an enum contains an invocation of a super constructor.

## Example

The following code produces this diagnostic because the constructor in
the enum `E` has a super constructor invocation in the initializer list:

```dart
enum E {
  e;

  const E() : [!super!]();
}
```

## Common fixes

Remove the super constructor invocation:

```dart
enum E {
  e;

  const E();
}
```
