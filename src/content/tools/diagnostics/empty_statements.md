---
title: empty_statements
description: >-
  Details about the empty_statements
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary empty statement._

## Description

The analyzer produces this diagnostic when an empty statement is found.

## Example

The following code produces this diagnostic because the statement
controlled by the `while` loop is an empty statement:

```dart
void f(bool condition) {
  while (condition)[!;!]
    g();
}

void g() {}
```

## Common fixes

If there are no statements that need to be controlled, then remove both
the empty statement and the control structure it's part of (being careful
that any other code being removed doesn't have a side-effect that needs to
be preserved):

```dart
void f(bool condition) {
  g();
}

void g() {}
```

If there are no statements that need to be controlled but the control
structure is still required for other reasons, then replace the empty
statement with a block to make the structure of the code more obvious:

```dart
void f(bool condition) {
  while (condition) {}
  g();
}

void g() {}
```

If there are statements that need to be controlled, remove the empty
statement and adjust the code so that the appropriate statements are being
controlled, possibly adding a block:

```dart
void f(bool condition) {
  while (condition) {
    g();
  }
}

void g() {}
```
