---
title: invalid_override
description: >-
  Details about the invalid_override
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}.{1}' ('{2}') isn't a valid override of '{3}.{1}' ('{4}')._
_The setter '{0}.{1}' ('{2}') isn't a valid override of '{3}.{1}' ('{4}')._

## Description

The analyzer produces this diagnostic when a member of a class is found
that overrides a member from a supertype and the override isn't valid. An
override is valid if all of these are true:
- It allows all of the arguments allowed by the overridden member.
- It doesn't require any arguments that aren't required by the overridden
  member.
- The type of every parameter of the overridden member is assignable to the
  corresponding parameter of the override.
- The return type of the override is assignable to the return type of the
  overridden member.

## Example

The following code produces this diagnostic because the type of the
parameter `s` (`String`) isn't assignable to the type of the parameter `i`
(`int`):

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void [!m!](String s) {}
}
```

## Common fixes

If the invalid method is intended to override the method from the
superclass, then change it to conform:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m(int i) {}
}
```

If it isn't intended to override the method from the superclass, then
rename it:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m2(String s) {}
}
```
