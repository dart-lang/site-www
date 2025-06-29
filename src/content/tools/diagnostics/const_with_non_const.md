---
title: const_with_non_const
description: >-
  Details about the const_with_non_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The constructor being called isn't a const constructor._

## Description

The analyzer produces this diagnostic when the keyword `const` is used to
invoke a constructor that isn't marked with `const`.

## Example

The following code produces this diagnostic because the constructor in `A`
isn't a const constructor:

```dart
class A {
  A();
}

A f() => [!const!] A();
```

## Common fixes

If it's desirable and possible to make the class a constant class (by
making all of the fields of the class, including inherited fields, final),
then add the keyword `const` to the constructor:

```dart
class A {
  const A();
}

A f() => const A();
```

Otherwise, remove the keyword `const`:

```dart
class A {
  A();
}

A f() => A();
```
