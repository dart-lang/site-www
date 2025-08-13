---
title: override_on_non_overriding_member
description: >-
  Details about the override_on_non_overriding_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The field doesn't override an inherited getter or setter._
_The getter doesn't override an inherited getter._
_The method doesn't override an inherited method._
_The setter doesn't override an inherited setter._

## Description

The analyzer produces this diagnostic when a class member is annotated with
the `@override` annotation, but the member isn't declared in any of the
supertypes of the class.

## Example

The following code produces this diagnostic because `m` isn't declared in
any of the supertypes of `C`:

```dart
class C {
  @override
  String [!m!]() => '';
}
```

## Common fixes

If the member is intended to override a member with a different name, then
update the member to have the same name:

```dart
class C {
  @override
  String toString() => '';
}
```

If the member is intended to override a member that was removed from the
superclass, then consider removing the member from the subclass.

If the member can't be removed, then remove the annotation.
