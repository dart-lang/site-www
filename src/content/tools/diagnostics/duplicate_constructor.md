---
title: duplicate_constructor
description: >-
  Details about the duplicate_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The constructor with name '{0}' is already defined._
_The unnamed constructor is already defined._

## Description

The analyzer produces this diagnostic when a class declares more than one
unnamed constructor or when it declares more than one constructor with the
same name.

## Examples

The following code produces this diagnostic because there are two
declarations for the unnamed constructor:

```dart
class C {
  C();

  [!C!]();
}
```

The following code produces this diagnostic because there are two
declarations for the constructor named `m`:

```dart
class C {
  C.m();

  [!C.m!]();
}
```

## Common fixes

If there are multiple unnamed constructors and all of the constructors are
needed, then give all of them, or all except one of them, a name:

```dart
class C {
  C();

  C.n();
}
```

If there are multiple unnamed constructors and all except one of them are
unneeded, then remove the constructors that aren't needed:

```dart
class C {
  C();
}
```

If there are multiple named constructors and all of the constructors are
needed, then rename all except one of them:

```dart
class C {
  C.m();

  C.n();
}
```

If there are multiple named constructors and all except one of them are
unneeded, then remove the constructors that aren't needed:

```dart
class C {
  C.m();
}
```
