---
title: undefined_extension_getter
description: >-
  Details about the undefined_extension_getter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The getter '{0}' isn't defined for the extension '{1}'._

## Description

The analyzer produces this diagnostic when an extension override is used to
invoke a getter, but the getter isn't defined by the specified extension.
The analyzer also produces this diagnostic when a static getter is
referenced but isn't defined by the specified extension.

## Examples

The following code produces this diagnostic because the extension `E`
doesn't declare an instance getter named `b`:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').[!b!];
}
```

The following code produces this diagnostic because the extension `E`
doesn't declare a static getter named `a`:

```dart
extension E on String {}

var x = E.[!a!];
```

## Common fixes

If the name of the getter is incorrect, then change it to the name of an
existing getter:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').a;
}
```

If the name of the getter is correct but the name of the extension is
wrong, then change the name of the extension to the correct name:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  F('c').b;
}
```

If the name of the getter and extension are both correct, but the getter
isn't defined, then define the getter:

```dart
extension E on String {
  String get a => 'a';
  String get b => 'z';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').b;
}
```
