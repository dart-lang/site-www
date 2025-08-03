---
title: unnecessary_statements
description: >-
  Details about the unnecessary_statements
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary statement._

## Description

The analyzer produces this diagnostic when an expression statement has no
clear effect.

## Example

The following code produces this diagnostic because the addition of the
returned values from the two invocations has no clear effect:

```dart
void f(int Function() first, int Function() second) {
  [!first() + second()!];
}
```

## Common fixes

If the expression doesn't need to be computed, then remove it:

```dart
void f(int Function() first, int Function() second) {
}
```

If the value of the expression is needed, then make use of it, possibly
assigning it to a local variable first:

```dart
void f(int Function() first, int Function() second) {
  print(first() + second());
}
```

If portions of the expression need to be executed, then remove the
unnecessary portions:

```dart
void f(int Function() first, int Function() second) {
  first();
  second();
}
```
