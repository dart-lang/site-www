---
title: import_deferred_library_with_load_function
description: >-
  Details about the import_deferred_library_with_load_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The imported library defines a top-level function named 'loadLibrary' that is
hidden by deferring this library._

## Description

The analyzer produces this diagnostic when a library that declares a
function named `loadLibrary` is imported using a deferred import. A
deferred import introduces an implicit function named `loadLibrary`. This
function is used to load the contents of the deferred library, and the
implicit function hides the explicit declaration in the deferred library.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Given a file `a.dart` that defines a function named `loadLibrary`:

```dart
void loadLibrary(Library library) {}

class Library {}
```

The following code produces this diagnostic because the implicit
declaration of `a.loadLibrary` is hiding the explicit declaration of
`loadLibrary` in `a.dart`:

```dart
[!import 'a.dart' deferred as a;!]

void f() {
  a.Library();
}
```

## Common fixes

If the imported library isn't required to be deferred, then remove the
keyword `deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.Library();
}
```

If the imported library is required to be deferred and you need to
reference the imported function, then rename the function in the imported
library:

```dart
void populateLibrary(Library library) {}

class Library {}
```

If the imported library is required to be deferred and you don't need to
reference the imported function, then add a `hide` clause:

```dart
import 'a.dart' deferred as a hide loadLibrary;

void f() {
  a.Library();
}
```
