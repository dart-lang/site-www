---
title: extension_declares_abstract_member
description: >-
  Details about the extension_declares_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Extensions can't declare abstract members._

## Description

The analyzer produces this diagnostic when an abstract declaration is
declared in an extension. Extensions can declare only concrete members.

## Example

The following code produces this diagnostic because the method `a` doesn't
have a body:

```dart
extension E on String {
  int [!a!]();
}
```

## Common fixes

Either provide an implementation for the member or remove it.
