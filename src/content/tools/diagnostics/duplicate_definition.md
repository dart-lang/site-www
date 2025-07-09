---
title: duplicate_definition
description: >-
  Details about the duplicate_definition
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The name '{0}' is already defined._

## Description

The analyzer produces this diagnostic when a name is declared, and there is
a previous declaration with the same name in the same scope.

## Example

The following code produces this diagnostic because the name `x` is
declared twice:

```dart
int x = 0;
int [!x!] = 1;
```

## Common fixes

Choose a different name for one of the declarations.

```dart
int x = 0;
int y = 1;
```
