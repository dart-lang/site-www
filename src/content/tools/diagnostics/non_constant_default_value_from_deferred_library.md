---
title: non_constant_default_value_from_deferred_library
description: >-
  Details about the non_constant_default_value_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used as a default parameter
value._

## Description

The analyzer produces this diagnostic when the default value of an optional
parameter uses a constant from a library imported using a deferred import.
Default values need to be available at compile time, and constants from
deferred libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines the constant `zero`:

```dart
const zero = 0;
```

The following code produces this diagnostic because `zero` is declared in a
library imported using a deferred import:

```dart
import 'a.dart' deferred as a;

void f({int x = a.[!zero!]}) {}
```

## Common fixes

If you need to reference the constant from the imported library, then
remove the `deferred` keyword:

```dart
import 'a.dart' as a;

void f({int x = a.zero}) {}
```

If you don't need to reference the constant, then replace the default
value:

```dart
void f({int x = 0}) {}
```
