---
title: invalid_deprecated_implement_annotation
description: >-
  Details about the invalid_deprecated_implement_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The annotation '@Deprecated.implement' can only be applied to implementable
classes._

## Description

The analyzer produces this diagnostic when anything other than an
implementable class or mixin is annotated with
Deprecated.implement. An implementable
class or mixin is one not declared with the `base`, `final`, or `sealed`
keywords.

## Example

The following code produces this diagnostic because the annotation is on a
sealed class:

```dart
@[!Deprecated.implement!]()
sealed class C {}
```

## Common fixes

Remove the annotation:

```dart
sealed class C {}
```
