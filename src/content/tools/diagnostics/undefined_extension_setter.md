---
title: undefined_extension_setter
description: >-
  Details about the undefined_extension_setter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The setter '{0}' isn't defined for the extension '{1}'._

## Description

The analyzer produces this diagnostic when an extension override is used to
invoke a setter, but the setter isn't defined by the specified extension.
The analyzer also produces this diagnostic when a static setter is
referenced but isn't defined by the specified extension.

## Examples

The following code produces this diagnostic because the extension `E`
doesn't declare an instance setter named `b`:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').[!b!] = 'd';
}
```

The following code produces this diagnostic because the extension `E`
doesn't declare a static setter named `a`:

```dart
extension E on String {}

void f() {
  E.[!a!] = 3;
}
```

## Common fixes

If the name of the setter is incorrect, then change it to the name of an
existing setter:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').a = 'd';
}
```

If the name of the setter is correct, but the name of the extension is
wrong, then change the name of the extension to the correct name:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  F('c').b = 'd';
}
```

If the name of the setter and extension are both correct, but the setter
isn't defined, then define the setter:

```dart
extension E on String {
  set a(String v) {}
  set b(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').b = 'd';
}
```
