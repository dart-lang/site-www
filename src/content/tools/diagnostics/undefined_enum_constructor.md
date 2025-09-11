---
title: undefined_enum_constructor
description: >-
  Details about the undefined_enum_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The enum doesn't have a constructor named '{0}'._

_The enum doesn't have an unnamed constructor._

## Description

The analyzer produces this diagnostic when the constructor invoked to
initialize an enum value doesn't exist.

## Examples

The following code produces this diagnostic because the enum value `c`
is being initialized by the unnamed constructor, but there's no unnamed
constructor defined in `E`:

```dart
enum E {
  [!c!]();

  const E.x();
}
```

The following code produces this diagnostic because the enum value `c` is
being initialized by the constructor named `x`, but there's no constructor
named `x` defined in `E`:

```dart
enum E {
  c.[!x!]();

  const E.y();
}
```

## Common fixes

If the enum value is being initialized by the unnamed constructor and one
of the named constructors should have been used, then add the name of the
constructor:

```dart
enum E {
  c.x();

  const E.x();
}
```

If the enum value is being initialized by the unnamed constructor and none
of the named constructors are appropriate, then define the unnamed
constructor:

```dart
enum E {
  c();

  const E();
}
```

If the enum value is being initialized by a named constructor and one of
the existing constructors should have been used, then change the name of
the constructor being invoked (or remove it if the unnamed constructor
should be used):

```dart
enum E {
  c.y();

  const E();
  const E.y();
}
```

If the enum value is being initialized by a named constructor and none of
the existing constructors should have been used, then define a constructor
with the name that was used:

```dart
enum E {
  c.x();

  const E.x();
}
```
