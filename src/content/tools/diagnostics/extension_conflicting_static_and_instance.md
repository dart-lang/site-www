---
title: extension_conflicting_static_and_instance
description: >-
  Details about the extension_conflicting_static_and_instance
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_An extension can't define static member '{0}' and an instance member with the
same name._

## Description

The analyzer produces this diagnostic when an extension declaration
contains both an instance member and a static member that have the same
name. The instance member and the static member can't have the same name
because it's unclear which member is being referenced by an unqualified use
of the name within the body of the extension.

## Example

The following code produces this diagnostic because the name `a` is being
used for two different members:

```dart
extension E on Object {
  int get a => 0;
  static int [!a!]() => 0;
}
```

## Common fixes

Rename or remove one of the members:

```dart
extension E on Object {
  int get a => 0;
  static int b() => 0;
}
```
