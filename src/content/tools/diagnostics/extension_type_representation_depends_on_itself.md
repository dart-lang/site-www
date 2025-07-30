---
title: extension_type_representation_depends_on_itself
description: >-
  Details about the extension_type_representation_depends_on_itself
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The extension type representation can't depend on itself._

## Description

The analyzer produces this diagnostic when an extension type has a
representation type that depends on the extension type itself, either
directly or indirectly.

## Example

The following code produces this diagnostic because the representation
type of the extension type `A` depends on `A` directly:

```dart
extension type [!A!](A a) {}
```

The following two code examples produce this diagnostic because the
representation type of the extension type `A` depends on `A`
indirectly through the extension type `B`:

```dart
extension type [!A!](B b) {}

extension type [!B!](A a) {}
```

```dart
extension type [!A!](List<B> b) {}

extension type [!B!](List<A> a) {}
```

## Common fixes

Remove the dependency by choosing a different representation type for at
least one of the types in the cycle:

```dart
extension type A(String s) {}
```
