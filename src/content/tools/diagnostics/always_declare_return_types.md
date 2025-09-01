---
title: always_declare_return_types
description: >-
  Details about the always_declare_return_types
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_declare_return_types"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The function '{0}' should have a return type but doesn't._

_The method '{0}' should have a return type but doesn't._

## Description

The analyzer produces this diagnostic when a method or function doesn't
have an explicit return type.

## Example

The following code produces this diagnostic because the function `f`
doesn't have a return type:

```dart
[!f!]() {}
```

## Common fixes

Add an explicit return type:

```dart
void f() {}
```
