---
title: const_not_initialized
description: >-
  Details about the const_not_initialized
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The constant '{0}' must be initialized._

## Description

The analyzer produces this diagnostic when a variable that is declared to
be a constant doesn't have an initializer.

## Example

The following code produces this diagnostic because `c` isn't initialized:

```dart
const [!c!];
```

## Common fixes

Add an initializer:

```dart
const c = 'c';
```
