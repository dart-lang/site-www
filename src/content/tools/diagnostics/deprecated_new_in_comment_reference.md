---
title: deprecated_new_in_comment_reference
description: >-
  Details about the deprecated_new_in_comment_reference
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Using the 'new' keyword in a comment reference is deprecated._

## Description

The analyzer produces this diagnostic when a comment reference (the name
of a declaration enclosed in square brackets in a documentation comment)
uses the keyword `new` to refer to a constructor. This form is deprecated.

## Examples

The following code produces this diagnostic because the unnamed
constructor is being referenced using `new C`:

```dart
/// See [[!new!] C].
class C {
  C();
}
```

The following code produces this diagnostic because the constructor named
`c` is being referenced using `new C.c`:

```dart
/// See [[!new!] C.c].
class C {
  C.c();
}
```

## Common fixes

If you're referencing a named constructor, then remove the keyword `new`:

```dart
/// See [C.c].
class C {
  C.c();
}
```

If you're referencing the unnamed constructor, then remove the keyword
`new` and append `.new` after the class name:

```dart
/// See [C.new].
class C {
  C.c();
}
```
