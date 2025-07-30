---
title: main_is_not_function
description: >-
  Details about the main_is_not_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The declaration named 'main' must be a function._

## Description

The analyzer produces this diagnostic when a library contains a declaration
of the name `main` that isn't the declaration of a top-level function.

## Example

The following code produces this diagnostic because the name `main` is
being used to declare a top-level variable:

```dart
var [!main!] = 3;
```

## Common fixes

Use a different name for the declaration:

```dart
var mainIndex = 3;
```
