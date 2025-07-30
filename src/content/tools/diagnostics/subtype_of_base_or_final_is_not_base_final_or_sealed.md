---
title: subtype_of_base_or_final_is_not_base_final_or_sealed
description: >-
  Details about the subtype_of_base_or_final_is_not_base_final_or_sealed
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The mixin '{0}' must be 'base' because the supertype '{1}' is 'base'._

_The mixin '{0}' must be 'base' because the supertype '{1}' is 'final'._

_The type '{0}' must be 'base', 'final' or 'sealed' because the supertype '{1}'
is 'base'._

_The type '{0}' must be 'base', 'final' or 'sealed' because the supertype '{1}'
is 'final'._

## Description

The analyzer produces this diagnostic when a class or mixin has a direct
or indirect supertype that is either `base` or `final`, but the class or
mixin itself isn't marked either `base`, `final`, or `sealed`.

## Example

The following code produces this diagnostic because the class `B` is a
subtype of `A`, and `A` is a `base` class, but `B` is neither `base`,
`final` or `sealed`:

```dart
base class A {}
class [!B!] extends A {}
```

## Common fixes

Add either `base`, `final` or `sealed` to the class or mixin declaration:

```dart
base class A {}
final class B extends A {}
```
