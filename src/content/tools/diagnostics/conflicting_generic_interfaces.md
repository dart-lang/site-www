---
title: conflicting_generic_interfaces
description: >-
  Details about the conflicting_generic_interfaces
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The {0} '{1}' can't implement both '{2}' and '{3}' because the type arguments
are different._

## Description

The analyzer produces this diagnostic when a class attempts to implement a
generic interface multiple times, and the values of the type arguments
aren't the same.

## Example

The following code produces this diagnostic because `C` is defined to
implement both `I<int>` (because it extends `A`) and `I<String>` (because
it implements`B`), but `int` and `String` aren't the same type:

```dart
class I<T> {}
class A implements I<int> {}
class B implements I<String> {}
class [!C!] extends A implements B {}
```

## Common fixes

Rework the type hierarchy to avoid this situation. For example, you might
make one or both of the inherited types generic so that `C` can specify the
same type for both type arguments:

```dart
class I<T> {}
class A<S> implements I<S> {}
class B implements I<String> {}
class C extends A<String> implements B {}
```
