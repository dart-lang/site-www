---
title: new_with_undefined_constructor_default
description: >-
  Details about the new_with_undefined_constructor_default
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The class '{0}' doesn't have an unnamed constructor._

## Description

The analyzer produces this diagnostic when an unnamed constructor is
invoked on a class that defines named constructors but the class doesn't
have an unnamed constructor.

## Example

The following code produces this diagnostic because `A` doesn't define an
unnamed constructor:

```dart
class A {
  A.a();
}

A f() => [!A!]();
```

## Common fixes

If one of the named constructors does what you need, then use it:

```dart
class A {
  A.a();
}

A f() => A.a();
```

If none of the named constructors does what you need, and you're able to
add an unnamed constructor, then add the constructor:

```dart
class A {
  A();
  A.a();
}

A f() => A();
```
