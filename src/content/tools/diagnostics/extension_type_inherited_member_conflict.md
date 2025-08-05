---
title: extension_type_inherited_member_conflict
description: >-
  Details about the extension_type_inherited_member_conflict
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The extension type '{0}' has more than one distinct member named '{1}' from implemented types._

## Description

The analyzer produces this diagnostic when an extension type implements
two or more other types, and at least two of those types declare a member
with the same name.

## Example

The following code produces this diagnostic because the extension type `C`
implements both `A` and `B`, and both declare a member named `m`:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type [!C!](A a) implements A, B {}
```

## Common fixes

If the extension type doesn't need to implement all of the listed types,
then remove all but one of the types introducing the conflicting members:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type C(A a) implements A {}
```

If the extension type needs to implement all of the listed types but you
can rename the members in those types, then give the conflicting members
unique names:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void n() {}
}

extension type C(A a) implements A, B {}
```
