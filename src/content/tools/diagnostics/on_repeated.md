---
title: on_repeated
description: >-
  Details about the on_repeated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The type '{0}' can be included in the superclass constraints only once._

## Description

The analyzer produces this diagnostic when the same type is listed in the
superclass constraints of a mixin multiple times.

## Example

The following code produces this diagnostic because `A` is included twice
in the superclass constraints for `M`:

```dart
mixin M on A, [!A!] {
}

class A {}
class B {}
```

## Common fixes

If a different type should be included in the superclass constraints, then
replace one of the occurrences with the other type:

```dart
mixin M on A, B {
}

class A {}
class B {}
```

If no other type was intended, then remove the repeated type name:

```dart
mixin M on A {
}

class A {}
class B {}
```
