---
title: mixin_class_declares_constructor
description: >-
  Details about the mixin_class_declares_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The class '{0}' can't be used as a mixin because it declares a constructor._

## Description

The analyzer produces this diagnostic when a class is used as a mixin and
the mixed-in class defines a constructor.

## Example

The following code produces this diagnostic because the class `A`, which
defines a constructor, is being used as a mixin:

```dart
//@dart=2.19
class A {
  A();
}

class B with [!A!] {}
```

## Common fixes

If it's possible to convert the class to a mixin, then do so:

```dart
mixin A {
}

class B with A {}
```

If the class can't be a mixin and it's possible to remove the constructor,
then do so:

```dart
//@dart=2.19
class A {
}

class B with A {}
```

If the class can't be a mixin and you can't remove the constructor, then
try extending or implementing the class rather than mixing it in:

```dart
class A {
  A();
}

class B extends A {}
```
