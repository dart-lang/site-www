---
title: mixin_class_declaration_extends_not_object
description: >-
  Details about the mixin_class_declaration_extends_not_object
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The class '{0}' can't be declared a mixin because it extends a class other than
'Object'._

## Description

The analyzer produces this diagnostic when a class that is marked with
the `mixin` modifier extends a class other than `Object`. A mixin class
can't have a superclass other than `Object`.

## Example

The following code produces this diagnostic because the class `B`, which
has the modifier `mixin`, extends `A`:

```dart
class A {}

mixin class B extends [!A!] {}
```

## Common fixes

If you want the class to be used as a mixin, then change the superclass to
`Object`, either explicitly or by removing the extends clause:

```dart
class A {}

mixin class B {}
```

If the class needs to have a superclass other than `Object`, then remove
the `mixin` modifier:

```dart
class A {}

class B extends A {}
```

If you need both a mixin and a subclass of a class other than `Object`,
then move the members of the subclass to a new mixin, remove the `mixin`
modifier from the subclass, and apply the new mixin to the subclass:

```dart
class A {}

class B extends A with M {}

mixin M {}
```

Depending on the members of the subclass this might require adding an `on`
clause to the mixin.
