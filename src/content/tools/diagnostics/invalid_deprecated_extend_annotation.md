---
title: invalid_deprecated_extend_annotation
description: >-
  Details about the invalid_deprecated_extend_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The annotation '@Deprecated.extend' can only be applied to extendable classes._

## Description

The analyzer produces this diagnostic when anything other than an
extendable class is annotated with
Deprecated.extend. An extendable class is a
class not declared with the `interface`, `final`, or `sealed` keywords,
and with at least one public generative constructor.

## Example

The following code produces this diagnostic because the annotation is on a
sealed class:

```dart
@[!Deprecated.extend!]()
sealed class C {}
```

## Common fixes

Remove the annotation:

```dart
sealed class C {}
```
