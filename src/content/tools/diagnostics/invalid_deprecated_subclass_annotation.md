---
title: invalid_deprecated_subclass_annotation
description: >-
  Details about the invalid_deprecated_subclass_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The annotation '@Deprecated.subclass' can only be applied to subclassable
classes and mixins._

## Description

The analyzer produces this diagnostic when anything other than a
subclassable class or mixin is annotated with
Deprecated.subclass. A subclassable
class is a class not declared with the `final` or `sealed` keywords. A
subclassable mixin is a mixin not declared with the `base` keyword.

## Example

The following code produces this diagnostic because the annotation is on a
sealed class:

```dart
@[!Deprecated.subclass!]()
sealed class C {}
```

## Common fixes

Remove the annotation:

```dart
sealed class C {}
```
