---
title: undefined_function
description: >-
  Details about the undefined_function
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The function '{0}' isn't defined._

## Description

The analyzer produces this diagnostic when it encounters an identifier that
appears to be the name of a function but either isn't defined or isn't
visible in the scope in which it's being referenced.

## Example

The following code produces this diagnostic because the name `emty` isn't
defined:

```dart
List<int> empty() => [];

void main() {
  print([!emty!]());
}
```

## Common fixes

If the identifier isn't defined, then either define it or replace it with
the name of a function that is defined. The example above can be corrected
by fixing the spelling of the function:

```dart
List<int> empty() => [];

void main() {
  print(empty());
}
```

If the function is defined but isn't visible, then you probably need to add
an import or re-arrange your code to make the function visible.
