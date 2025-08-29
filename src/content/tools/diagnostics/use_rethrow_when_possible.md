---
title: use_rethrow_when_possible
description: >-
  Details about the use_rethrow_when_possible
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_rethrow_when_possible"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'rethrow' to rethrow a caught exception._

## Description

The analyzer produces this diagnostic when a caught exception is thrown
using a `throw` expression rather than a `rethrow` statement.

## Example

The following code produces this diagnostic because the caught exception
`e` is thrown using a `throw` expression:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    [!throw e!];
  }
}
```

## Common fixes

Use `rethrow` instead of `throw`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    rethrow;
  }
}
```
