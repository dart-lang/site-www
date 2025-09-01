---
title: extension_type_implements_representation_not_supertype
description: >-
  Details about the extension_type_implements_representation_not_supertype
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}', the representation type of '{1}', is not a supertype of '{2}', the
representation type of '{3}'._

## Description

The analyzer produces this diagnostic when an extension type implements
another extension type, and the representation type of the implemented
extension type isn't a subtype of the representation type of the implementing
extension type.

## Example

The following code produces this diagnostic because the extension type `B`
implements `A`, but the representation type of `A` (`num`) isn't a
subtype of the representation type of `B` (`String`):

```dart
extension type A(num i) {}

extension type B(String s) implements [!A!] {}
```

## Common fixes

Either change the representation types of the two extension types so that
the representation type of the implemented type is a supertype of the
representation type of the implementing type:

```dart
extension type A(num i) {}

extension type B(int n) implements A {}
```

Or remove the implemented type from the implements clause:

```dart
extension type A(num i) {}

extension type B(String s) {}
```
