---
title: mixin_inherits_from_not_object
description: >-
  Details about the mixin_inherits_from_not_object
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The class '{0}' can't be used as a mixin because it extends a class other than
'Object'._

## Description

The analyzer produces this diagnostic when a class that extends a class
other than `Object` is used as a mixin.

## Example

The following code produces this diagnostic because the class `B`, which
extends `A`, is being used as a mixin by `C`:

```dart
//@dart=2.19
class A {}

class B extends A {}

class C with [!B!] {}
```

## Common fixes

If the class being used as a mixin can be changed to extend `Object`, then
change it:

```dart
//@dart=2.19
class A {}

class B {}

class C with B {}
```

If the class being used as a mixin can't be changed and the class that's
using it extends `Object`, then extend the class being used as a mixin:

```dart
class A {}

class B extends A {}

class C extends B {}
```

If the class doesn't extend `Object` or if you want to be able to mix in
the behavior from `B` in other places, then create a real mixin:

```dart
class A {}

mixin M on A {}

class B extends A with M {}

class C extends A with M {}
```
