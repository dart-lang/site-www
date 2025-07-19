---
title: main_has_required_named_parameters
description: >-
  Details about the main_has_required_named_parameters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The function 'main' can't have any required named parameters._

## Description

The analyzer produces this diagnostic when a function named `main` has one
or more required named parameters.

## Example

The following code produces this diagnostic because the function named
`main` has a required named parameter (`x`):

```dart
void [!main!]({required int x}) {}
```

## Common fixes

If the function is an entry point, then remove the `required` keyword:

```dart
void main({int? x}) {}
```

If the function isn't an entry point, then change the name of the function:

```dart
void f({required int x}) {}
```
