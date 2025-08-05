---
title: type_parameter_referenced_by_static
description: >-
  Details about the type_parameter_referenced_by_static
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Static members can't reference type parameters of the class._

## Description

The analyzer produces this diagnostic when a static member references a
type parameter that is declared for the class. Type parameters only have
meaning for instances of the class.

## Example

The following code produces this diagnostic because the static method
`hasType` has a reference to the type parameter `T`:

```dart
class C<T> {
  static bool hasType(Object o) => o is [!T!];
}
```

## Common fixes

If the member can be an instance member, then remove the keyword `static`:

```dart
class C<T> {
  bool hasType(Object o) => o is T;
}
```

If the member must be a static member, then make the member be generic:

```dart
class C<T> {
  static bool hasType<S>(Object o) => o is S;
}
```

Note, however, that there isn't a relationship between `T` and `S`, so this
second option changes the semantics from what was likely to be intended.
