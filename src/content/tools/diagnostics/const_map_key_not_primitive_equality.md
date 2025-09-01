---
title: const_map_key_not_primitive_equality
description: >-
  Details about the const_map_key_not_primitive_equality
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type of a key in a constant map can't override the '==' operator, or
'hashCode', but the class '{0}' does._

## Description

The analyzer produces this diagnostic when the class of object used as a
key in a constant map literal implements either the `==` operator, the
getter `hashCode`, or both. The implementation of constant maps uses both
the `==` operator and the `hashCode` getter, so any implementation other
than the ones inherited from `Object` requires executing arbitrary code at
compile time, which isn't supported.

## Examples

The following code produces this diagnostic because the constant map
contains a key whose type is `C`, and the class `C` overrides the
implementation of `==`:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

const map = {[!C()!] : 0};
```

The following code produces this diagnostic because the constant map
contains a key whose type is `C`, and the class `C` overrides the
implementation of `hashCode`:

```dart
class C {
  const C();

  int get hashCode => 3;
}

const map = {[!C()!] : 0};
```

## Common fixes

If you can remove the implementation of `==` and `hashCode` from the
class, then do so:

```dart
class C {
  const C();
}

const map = {C() : 0};
```

If you can't remove the implementation of `==` and `hashCode` from the
class, then make the map non-constant:

```dart
class C {
  const C();

  bool operator ==(Object other) => true;
}

final map = {C() : 0};
```
