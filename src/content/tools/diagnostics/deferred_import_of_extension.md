---
title: deferred_import_of_extension
description: >-
  Details about the deferred_import_of_extension
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Imports of deferred libraries must hide all extensions._

## Description

The analyzer produces this diagnostic when a library that is imported using
a deferred import declares an extension that is visible in the importing
library. Extension methods are resolved at compile time, and extensions
from deferred libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines a named extension:

```dart
class C {}

extension E on String {
  int get size => length;
}
```

The following code produces this diagnostic because the named extension is
visible to the library:

```dart
import [!'a.dart'!] deferred as a;

void f() {
  a.C();
}
```

## Common fixes

If the library must be imported as `deferred`, then either add a `show`
clause listing the names being referenced or add a `hide` clause listing
all of the named extensions. Adding a `show` clause would look like this:

```dart
import 'a.dart' deferred as a show C;

void f() {
  a.C();
}
```

Adding a `hide` clause would look like this:

```dart
import 'a.dart' deferred as a hide E;

void f() {
  a.C();
}
```

With the first fix, the benefit is that if new extensions are added to the
imported library, then the extensions won't cause a diagnostic to be
generated.

If the library doesn't need to be imported as `deferred`, or if you need to
make use of the extension method declared in it, then remove the keyword
`deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.C();
}
```
