---
title: type_alias_cannot_reference_itself
description: >-
  Details about the type_alias_cannot_reference_itself
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Typedefs can't reference themselves directly or recursively via another typedef._

## Description

The analyzer produces this diagnostic when a typedef refers to itself,
either directly or indirectly.

## Example

The following code produces this diagnostic because `F` depends on itself
indirectly through `G`:

```dart
typedef [!F!] = void Function(G);
typedef G = void Function(F);
```

## Common fixes

Change one or more of the typedefs in the cycle so that none of them refer
to themselves:

```dart
typedef F = void Function(G);
typedef G = void Function(int);
```
