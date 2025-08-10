---
title: recursive_interface_inheritance
description: >-
  Details about the recursive_interface_inheritance
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_'{0}' can't be a superinterface of itself: {1}._

_'{0}' can't extend itself._

_'{0}' can't implement itself._

_'{0}' can't use itself as a mixin._

_'{0}' can't use itself as a superclass constraint._

## Description

The analyzer produces this diagnostic when there's a circularity in the
type hierarchy. This happens when a type, either directly or indirectly,
is declared to be a subtype of itself.

## Example

The following code produces this diagnostic because the class `A` is
declared to be a subtype of `B`, and `B` is a subtype of `A`:

```dart
class [!A!] extends B {}
class B implements A {}
```

## Common fixes

Change the type hierarchy so that there's no circularity.
