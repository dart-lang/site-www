---
title: undefined_prefixed_name
description: >-
  Details about the undefined_prefixed_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The name '{0}' is being referenced through the prefix '{1}', but it isn't defined in any of the libraries imported using that prefix._

## Description

The analyzer produces this diagnostic when a prefixed identifier is found
where the prefix is valid, but the identifier isn't declared in any of the
libraries imported using that prefix.

## Example

The following code produces this diagnostic because `dart:core` doesn't
define anything named `a`:

```dart
import 'dart:core' as p;

void f() {
  p.[!a!];
}
```

## Common fixes

If the library in which the name is declared isn't imported yet, add an
import for the library.

If the name is wrong, then change it to one of the names that's declared in
the imported libraries.
