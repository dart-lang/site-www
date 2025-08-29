---
title: pattern_constant_from_deferred_library
description: >-
  Details about the pattern_constant_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used in patterns._

## Description

The analyzer produces this diagnostic when a pattern contains a value
declared in a different library, and that library is imported using a
deferred import. Constants are evaluated at compile time, but values from
deferred libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines the constant `zero`:

```dart
const zero = 0;
```

The following code produces this diagnostic because the constant pattern
`a.zero` is imported using a deferred import:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  switch (x) {
    case a.[!zero!]:
      // ...
      break;
  }
}
```

## Common fixes

If you need to reference the constant from the imported library, then
remove the `deferred` keyword:

```dart
import 'a.dart' as a;

void f(int x) {
  switch (x) {
    case a.zero:
      // ...
      break;
  }
}
```

If you need to reference the constant from the imported library and also
need the imported library to be deferred, then rewrite the switch
statement as a sequence of `if` statements:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  if (x == a.zero) {
    // ...
  }
}
```

If you don't need to reference the constant, then replace the case
expression:

```dart
void f(int x) {
  switch (x) {
    case 0:
      // ...
      break;
  }
}
```
