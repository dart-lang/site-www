---
title: extends_non_class
description: >-
  Details about the extends_non_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes can only extend other classes._

## Description

The analyzer produces this diagnostic when an `extends` clause contains a
name that is declared to be something other than a class.

## Example

The following code produces this diagnostic because `f` is declared to be a
function:

```dart
void f() {}

class C extends [!f!] {}
```

## Common fixes

If you want the class to extend a class other than `Object`, then replace
the name in the `extends` clause with the name of that class:

```dart
void f() {}

class C extends B {}

class B {}
```

If you want the class to extend `Object`, then remove the `extends` clause:

```dart
void f() {}

class C {}
```
