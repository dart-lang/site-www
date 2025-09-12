---
title: prefer_asserts_in_initializer_lists
description: >-
  Details about the prefer_asserts_in_initializer_lists
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_asserts_in_initializer_lists"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Assert should be in the initializer list._

## Description

The analyzer produces this diagnostic when the body of a constructor
begins with one or more assert statements.

## Example

The following code produces this diagnostic because the body of the
constructor begins with an assert statement:

```dart
class C {
  C(int i) {
    [!assert!](i != 0);
  }
}
```

## Common fixes

Move the assert to the initializer list, removing the body if there are
only assert statements in it:

```dart
class C {
  C(int i) : assert(i != 0);
}
```
