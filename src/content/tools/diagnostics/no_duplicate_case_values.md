---
title: no_duplicate_case_values
description: >-
  Details about the no_duplicate_case_values
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_duplicate_case_values"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The value of the case clause ('{0}') is equal to the value of an earlier case clause ('{1}')._

## Description

The analyzer produces this diagnostic when two or more `case` clauses in
the same `switch` statement have the same value.

Any `case` clauses after the first can't be executed, so having duplicate
`case` clauses is misleading.

This diagnostic is often the result of either a typo or a change to the
value of a constant.

## Example

The following code produces this diagnostic because two case clauses have
the same value (1):

```dart
// @dart = 2.14
void f(int v) {
  switch (v) {
    case 1:
      break;
    case [!1!]:
      break;
  }
}
```

## Common fixes

If one of the clauses should have a different value, then change the value
of the clause:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
    case 2:
      break;
  }
}
```

If the value is correct, then merge the statements into a single clause:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
  }
}
```
