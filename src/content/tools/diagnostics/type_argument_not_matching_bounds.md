---
title: type_argument_not_matching_bounds
description: >-
  Details about the type_argument_not_matching_bounds
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' doesn't conform to the bound '{2}' of the type parameter '{1}'._

## Description

The analyzer produces this diagnostic when a type argument isn't the same
as or a subclass of the bounds of the corresponding type parameter.

## Example

The following code produces this diagnostic because `String` isn't a
subclass of `num`:

```dart
class A<E extends num> {}

var a = A<[!String!]>();
```

## Common fixes

Change the type argument to be a subclass of the bounds:

```dart
class A<E extends num> {}

var a = A<int>();
```
