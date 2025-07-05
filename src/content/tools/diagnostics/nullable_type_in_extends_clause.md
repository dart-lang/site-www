---
title: nullable_type_in_extends_clause
description: >-
  Details about the nullable_type_in_extends_clause
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_A class can't extend a nullable type._

## Description

The analyzer produces this diagnostic when a class declaration uses an
`extends` clause to specify a superclass, and the superclass is followed by
a `?`.

It isn't valid to specify a nullable superclass because doing so would have
no meaning; it wouldn't change either the interface or implementation being
inherited by the class containing the `extends` clause.

Note, however, that it _is_ valid to use a nullable type as a type argument
to the superclass, such as `class A extends B<C?> {}`.

## Example

The following code produces this diagnostic because `A?` is a nullable
type, and nullable types can't be used in an `extends` clause:

```dart
class A {}
class B extends [!A?!] {}
```

## Common fixes

Remove the question mark from the type:

```dart
class A {}
class B extends A {}
```
