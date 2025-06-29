---
title: undefined_method
description: >-
  Details about the undefined_method
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The method '{0}' isn't defined for the '{1}' function type._

_The method '{0}' isn't defined for the type '{1}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
appears to be the name of a method but either isn't defined or isn't
visible in the scope in which it's being referenced.

## Example

The following code produces this diagnostic because the identifier
`removeMiddle` isn't defined:

```dart
int f(List<int> l) => l.[!removeMiddle!]();
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
the name of a method that is defined. The example above can be corrected by
fixing the spelling of the method:

```dart
int f(List<int> l) => l.removeLast();
```
