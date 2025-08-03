---
title: avoid_returning_null_for_void
description: >-
  Details about the avoid_returning_null_for_void
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_returning_null_for_void"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't return 'null' from a function with a return type of 'void'._

_Don't return 'null' from a method with a return type of 'void'._

## Description

The analyzer produces this diagnostic when a function that has a return
type of `void` explicitly returns `null`.

## Example

The following code produces this diagnostic because there is an explicit
return of `null` in a `void` function:

```dart
void f() {
  [!return null;!]
}
```

## Common fixes

Remove the unnecessary explicit `null`:

```dart
void f() {
  return;
}
```
