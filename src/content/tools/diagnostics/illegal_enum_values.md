---
title: illegal_enum_values
description: >-
  Details about the illegal_enum_values
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_An instance member named 'values' can't be declared in a class that implements
'Enum'._

_An instance member named 'values' can't be inherited from '{0}' in a class that
implements 'Enum'._

## Description

The analyzer produces this diagnostic when either a class that implements
`Enum` or a mixin with a superclass constraint of `Enum` has an instance
member named `values`.

## Examples

The following code produces this diagnostic because the class `C`, which
implements `Enum`, declares an instance field named `values`:

```dart
abstract class C implements Enum {
  int get [!values!] => 0;
}
```

The following code produces this diagnostic because the class `B`, which
implements `Enum`, inherits an instance method named `values` from `A`:

```dart
abstract class A {
  int values() => 0;
}

abstract class [!B!] extends A implements Enum {}
```

## Common fixes

Change the name of the conflicting member:

```dart
abstract class C implements Enum {
  int get value => 0;
}
```
