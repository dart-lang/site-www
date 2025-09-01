---
title: extension_override_access_to_static_member
description: >-
  Details about the extension_override_access_to_static_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_An extension override can't be used to access a static member from an
extension._

## Description

The analyzer produces this diagnostic when an extension override is the
receiver of the invocation of a static member. Similar to static members in
classes, the static members of an extension should be accessed using the
name of the extension, not an extension override.

## Example

The following code produces this diagnostic because `m` is static:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E('').[!m!]();
}
```

## Common fixes

Replace the extension override with the name of the extension:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E.m();
}
```
