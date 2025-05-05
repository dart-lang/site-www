---
title: throw_in_finally
description: >-
  Details about the throw_in_finally
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/throw_in_finally"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use of '{0}' in 'finally' block._

## Description

The analyzer produces this diagnostic when a `throw` statement is found
inside a `finally` block.

## Example

The following code produces this diagnostic because there is a `throw`
statement inside a `finally` block:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  } finally {
    [!throw 'error'!];
  }
}
```

## Common fixes

Rewrite the code so that the `throw` statement isn't inside a `finally`
block:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  }
  throw 'error';
}
```
