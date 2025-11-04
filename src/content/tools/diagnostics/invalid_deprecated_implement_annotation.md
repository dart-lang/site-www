---
title: invalid_deprecated_implement_annotation
description: >-
  Details about the invalid_deprecated_implement_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation '@Deprecated.implement' can only be applied to implementable classes._

## Description

The analyzer produces this diagnostic when the `@Deprecated.implement`
annotation is applied to a declaration that isn't an implementable class
or mixin. An implementable class or mixin is one that isn't declared with
the base, final, or sealed keywords.

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
