---
title: list_element_type_not_assignable
description: >-
  Details about the list_element_type_not_assignable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The element type '{0}' can't be assigned to the list type '{1}'._

## Description

The analyzer produces this diagnostic when the type of an element in a list
literal isn't assignable to the element type of the list.

## Example

The following code produces this diagnostic because `2.5` is a double, and
the list can hold only integers:

```dart
List<int> x = [1, [!2.5!], 3];
```

## Common fixes

If you intended to add a different object to the list, then replace the
element with an expression that computes the intended object:

```dart
List<int> x = [1, 2, 3];
```

If the object shouldn't be in the list, then remove the element:

```dart
List<int> x = [1, 3];
```

If the object being computed is correct, then widen the element type of the
list to allow all of the different types of objects it needs to contain:

```dart
List<num> x = [1, 2.5, 3];
```
