---
title: non_constant_map_element
description: >-
  Details about the non_constant_map_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The elements in a const map literal must be constant._

## Description

The analyzer produces this diagnostic when an `if` element or a spread
element in a constant map isn't a constant element.

## Examples

The following code produces this diagnostic because it's attempting to
spread a non-constant map:

```dart
var notConst = <int, int>{};
var map = const <int, int>{...[!notConst!]};
```

Similarly, the following code produces this diagnostic because the
condition in the `if` element isn't a constant expression:

```dart
bool notConst = true;
var map = const <int, int>{if ([!notConst!]) 1 : 2};
```

## Common fixes

If the map needs to be a constant map, then make the elements constants.
In the spread example, you might do that by making the collection being
spread a constant:

```dart
const notConst = <int, int>{};
var map = const <int, int>{...notConst};
```

If the map doesn't need to be a constant map, then remove the `const`
keyword:

```dart
bool notConst = true;
var map = <int, int>{if (notConst) 1 : 2};
```
