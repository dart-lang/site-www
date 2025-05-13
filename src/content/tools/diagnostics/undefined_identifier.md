---
title: undefined_identifier
description: >-
  Details about the undefined_identifier
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Undefined name '{0}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
either isn't defined or isn't visible in the scope in which it's being
referenced.

## Example

The following code produces this diagnostic because the name `rihgt` isn't
defined:

```dart
int min(int left, int right) => left <= [!rihgt!] ? left : right;
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
an identifier that is defined. The example above can be corrected by
fixing the spelling of the variable:

```dart
int min(int left, int right) => left <= right ? left : right;
```

If the identifier is defined but isn't visible, then you probably need to
add an import or re-arrange your code to make the identifier visible.
