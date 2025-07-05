---
title: type_parameter_supertype_of_its_bound
description: >-
  Details about the type_parameter_supertype_of_its_bound
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' can't be a supertype of its upper bound._

## Description

The analyzer produces this diagnostic when the bound of a type parameter
(the type following the `extends` keyword) is either directly or indirectly
the type parameter itself. Stating that the type parameter must be the same
as itself or a subtype of itself or a subtype of itself isn't helpful
because it will always be the same as itself.

## Examples

The following code produces this diagnostic because the bound of `T` is
`T`:

```dart
class C<[!T!] extends T> {}
```

The following code produces this diagnostic because the bound of `T1` is
`T2`, and the bound of `T2` is `T1`, effectively making the bound of `T1`
be `T1`:

```dart
class C<[!T1!] extends T2, T2 extends T1> {}
```

## Common fixes

If the type parameter needs to be a subclass of some type, then replace the
bound with the required type:

```dart
class C<T extends num> {}
```

If the type parameter can be any type, then remove the `extends` clause:

```dart
class C<T> {}
```
