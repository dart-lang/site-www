---
title: abstract_sealed_class
description: >-
  Details about the abstract_sealed_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_A 'sealed' class can't be marked 'abstract' because it's already implicitly
abstract._

## Description

The analyzer produces this diagnostic when a class is declared using both
the modifier `abstract` and the modifier `sealed`. Sealed classes are
implicitly abstract, so explicitly using both modifiers is not allowed.

## Example

The following code produces this diagnostic because the class `C` is
declared using both `abstract` and `sealed`:

```dart
abstract [!sealed!] class C {}
```

## Common fixes

If the class should be abstract but not sealed, then remove the `sealed`
modifier:

```dart
abstract class C {}
```

If the class should be both abstract and sealed, then remove the
`abstract` modifier:

```dart
sealed class C {}
```
