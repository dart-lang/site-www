---
title: obsolete_colon_for_default_value
description: >-
  Details about the obsolete_colon_for_default_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Using a colon as the separator before a default value is no longer supported._

## Description

The analyzer produces this diagnostic when a colon (`:`) is used as the
separator before the default value of an optional named parameter.
While this syntax used to be allowed, it was removed in favor of
using an equal sign (`=`).

## Example

The following code produces this diagnostic because a colon is being used
before the default value of the optional parameter `i`:

```dart
void f({int i [!:!] 0}) {}
```

## Common fixes

Replace the colon with an equal sign:

```dart
void f({int i = 0}) {}
```
