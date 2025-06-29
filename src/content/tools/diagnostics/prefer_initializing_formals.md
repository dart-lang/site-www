---
title: prefer_initializing_formals
description: >-
  Details about the prefer_initializing_formals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_initializing_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use an initializing formal to assign a parameter to a field._

## Description

The analyzer produces this diagnostic when a constructor parameter is used
to initialize a field without modification.

## Example

The following code produces this diagnostic because the parameter `c` is
only used to set the field `c`:

```dart
class C {
  int c;

  C(int c) : [!this.c = c!];
}
```

## Common fixes

Use an initializing formal parameter to initialize the field:

```dart
class C {
  int c;

  C(this.c);
}
```
