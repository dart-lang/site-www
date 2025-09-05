---
title: invalid_deprecated_mixin_annotation
description: >-
  Details about the invalid_deprecated_mixin_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation '@Deprecated.mixin' can only be applied to classes._

## Description

The analyzer produces this diagnostic when anything other than a
mixin class is annotated with Deprecated.mixin.

## Example

The following code produces this diagnostic because the annotation is on a
non-mixin class:

```dart
@[!Deprecated.mixin!]()
class C {}
```

## Common fixes

Remove the annotation:

```dart
class C {}
```
