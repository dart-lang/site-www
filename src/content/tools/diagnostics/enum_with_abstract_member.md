---
title: enum_with_abstract_member
description: >-
  Details about the enum_with_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' must have a method body because '{1}' is an enum._

## Description

The analyzer produces this diagnostic when a member of an enum is found
that doesn't have a concrete implementation. Enums aren't allowed to
contain abstract members.

## Example

The following code produces this diagnostic because `m` is an abstract
method and `E` is an enum:

```dart
enum E {
  e;

  [!void m();!]
}
```

## Common fixes

Provide an implementation for the member:

```dart
enum E {
  e;

  void m() {}
}
```
