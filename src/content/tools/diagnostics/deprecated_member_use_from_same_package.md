---
title: deprecated_member_use_from_same_package
description: >-
  Details about the deprecated_member_use_from_same_package
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_'{0}' is deprecated and shouldn't be used._
_'{0}' is deprecated and shouldn't be used. {1}_

## Description

The analyzer produces this diagnostic when a deprecated library member or
class member is used in the same package in which it's declared.

## Example

The following code produces this diagnostic because `x` is deprecated:

```dart
@deprecated
var x = 0;
var y = [!x!];
```

## Common fixes

The fix depends on what's been deprecated and what the replacement is. The
documentation for deprecated declarations should indicate what code to use
in place of the deprecated code.
