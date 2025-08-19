---
title: implements_super_class
description: >-
  Details about the implements_super_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' can't be used in both the 'extends' and 'implements' clauses._
_'{0}' can't be used in both the 'extends' and 'with' clauses._

## Description

The analyzer produces this diagnostic when a class is listed in the
`extends` clause of a class declaration and also in either the
`implements` or `with` clause of the same declaration.

## Example

The following code produces this diagnostic because the class `A` is used
in both the `extends` and `implements` clauses for the class `B`:

```dart
class A {}

class B extends A implements [!A!] {}
```

The following code produces this diagnostic because the class `A` is used
in both the `extends` and `with` clauses for the class `B`:

```dart
mixin class A {}

class B extends A with [!A!] {}
```

## Common fixes

If you want to inherit the implementation from the class, then remove the
class from the `implements` clause:

```dart
class A {}

class B extends A {}
```

If you don't want to inherit the implementation from the class, then remove
the `extends` clause:

```dart
class A {}

class B implements A {}
```
