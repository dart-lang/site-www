---
title: undefined_extension_method
description: >-
  Details about the undefined_extension_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The method '{0}' isn't defined for the extension '{1}'._

## Description

The analyzer produces this diagnostic when an extension override is used to
invoke a method, but the method isn't defined by the specified extension.
The analyzer also produces this diagnostic when a static method is
referenced but isn't defined by the specified extension.

## Examples

The following code produces this diagnostic because the extension `E`
doesn't declare an instance method named `b`:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').[!b!]();
}
```

The following code produces this diagnostic because the extension `E`
doesn't declare a static method named `a`:

```dart
extension E on String {}

var x = E.[!a!]();
```

## Common fixes

If the name of the method is incorrect, then change it to the name of an
existing method:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').a();
}
```

If the name of the method is correct, but the name of the extension is
wrong, then change the name of the extension to the correct name:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  F('c').b();
}
```

If the name of the method and extension are both correct, but the method
isn't defined, then define the method:

```dart
extension E on String {
  String a() => 'a';
  String b() => 'z';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').b();
}
```
