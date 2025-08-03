---
title: invalid_reference_to_this
description: >-
  Details about the invalid_reference_to_this
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_Invalid reference to 'this' expression._

## Description

The analyzer produces this diagnostic when `this` is used outside of an
instance method or a generative constructor. The reserved word `this` is
only defined in the context of an instance method, a generative
constructor, or the initializer of a late instance field declaration.

## Example

The following code produces this diagnostic because `v` is a top-level
variable:

```dart
C f() => [!this!];

class C {}
```

## Common fixes

Use a variable of the appropriate type in place of `this`, declaring it if
necessary:

```dart
C f(C c) => c;

class C {}
```
