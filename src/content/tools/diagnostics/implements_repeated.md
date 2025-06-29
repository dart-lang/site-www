---
title: implements_repeated
description: >-
  Details about the implements_repeated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' can only be implemented once._

## Description

The analyzer produces this diagnostic when a single class is specified more
than once in an `implements` clause.

## Example

The following code produces this diagnostic because `A` is in the list
twice:

```dart
class A {}
class B implements A, [!A!] {}
```

## Common fixes

Remove all except one occurrence of the class name:

```dart
class A {}
class B implements A {}
```
