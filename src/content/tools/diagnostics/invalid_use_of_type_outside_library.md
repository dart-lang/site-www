---
title: invalid_use_of_type_outside_library
description: >-
  Details about the invalid_use_of_type_outside_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't be extended outside of its library because it's a final class._
_The class '{0}' can't be extended outside of its library because it's an interface class._
_The class '{0}' can't be extended, implemented, or mixed in outside of its library because it's a sealed class._
_The class '{0}' can't be implemented outside of its library because it's a base class._
_The class '{0}' can't be implemented outside of its library because it's a final class._
_The class '{0}' can't be used as a mixin superclass constraint outside of its library because it's a final class._
_The mixin '{0}' can't be implemented outside of its library because it's a base mixin._

## Description

The analyzer produces this diagnostic when an `extends`, `implements`,
`with`, or `on` clause uses a class or mixin in a way that isn't allowed
given the modifiers on that class or mixin's declaration.

The message specifies how the declaration is being used and why it isn't
allowed.

## Example

Given a file `a.dart` that defines a base class `A`:

```dart
base class A {}
```

The following code produces this diagnostic because the class `B`
implements the class `A`, but the `base` modifier prevents `A` from being
implemented outside of the library where it's defined:

```dart
import 'a.dart';

final class B implements [!A!] {}
```

## Common fixes

Use of this type is restricted outside of its declaring library. If a
different, unrestricted type is available that can provide similar
functionality, then replace the type:

```dart
class B implements C {}
class C {}
```

If there isn't a different type that would be appropriate, then remove the
type, and possibly the whole clause:

```dart
class B {}
```
