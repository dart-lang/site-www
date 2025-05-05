---
title: missing_return
description: >-
  Details about the missing_return
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_This function has a return type of '{0}', but doesn't end with a return
statement._

## Description

Any function or method that doesn't end with either an explicit return or a
throw implicitly returns `null`. This is rarely the desired behavior. The
analyzer produces this diagnostic when it finds an implicit return.

## Example

The following code produces this diagnostic because `f` doesn't end with a
return:

```dart
int [!f!](int x) {
  if (x < 0) {
    return 0;
  }
}
```

## Common fixes

Add a `return` statement that makes the return value explicit, even if
`null` is the appropriate value.
