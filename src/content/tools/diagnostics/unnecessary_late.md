---
title: unnecessary_late
description: >-
  Details about the unnecessary_late
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_late"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary 'late' modifier._

## Description

The analyzer produces this diagnostic when a top-level variable or static
field with an initializer is marked as `late`. Top-level variables and
static fields are implicitly late, so they don't need to be explicitly
marked.

## Example

The following code produces this diagnostic because the static field `c`
has the modifier `late` even though it has an initializer:

```dart
class C {
  static [!late!] String c = '';
}
```

## Common fixes

Remove the keyword `late`:

```dart
class C {
  static String c = '';
}
```
