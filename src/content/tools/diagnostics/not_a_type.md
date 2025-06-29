---
title: not_a_type
description: >-
  Details about the not_a_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_{0} isn't a type._

## Description

The analyzer produces this diagnostic when a name is used as a type but
declared to be something other than a type.

## Example

The following code produces this diagnostic because `f` is a function:

```dart
f() {}
g([!f!] v) {}
```

## Common fixes

Replace the name with the name of a type.
