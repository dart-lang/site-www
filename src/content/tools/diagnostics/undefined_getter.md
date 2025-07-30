---
title: undefined_getter
description: >-
  Details about the undefined_getter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The getter '{0}' isn't defined for the '{1}' function type._

_The getter '{0}' isn't defined for the type '{1}'._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
appears to be the name of a getter but either isn't defined or isn't
visible in the scope in which it's being referenced.

## Example

The following code produces this diagnostic because `String` has no member
named `len`:

```dart
int f(String s) => s.[!len!];
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
the name of a getter that is defined. The example above can be corrected by
fixing the spelling of the getter:

```dart
int f(String s) => s.length;
```
