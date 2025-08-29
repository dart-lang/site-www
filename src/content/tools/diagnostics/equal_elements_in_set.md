---
title: equal_elements_in_set
description: >-
  Details about the equal_elements_in_set
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Two elements in a set literal shouldn't be equal._

## Description

The analyzer produces this diagnostic when an element in a non-constant set
is the same as a previous element in the same set. If two elements are the
same, then the second value is ignored, which makes having both elements
pointless and likely signals a bug.

## Example

The following code produces this diagnostic because the element `1` appears
twice:

```dart
const a = 1;
const b = 1;
var s = <int>{a, [!b!]};
```

## Common fixes

If both elements should be included in the set, then change one of the
elements:

```dart
const a = 1;
const b = 2;
var s = <int>{a, b};
```

If only one of the elements is needed, then remove the one that isn't
needed:

```dart
const a = 1;
var s = <int>{a};
```

Note that literal sets preserve the order of their elements, so the choice
of which element to remove might affect the order in which elements are
returned by an iterator.
