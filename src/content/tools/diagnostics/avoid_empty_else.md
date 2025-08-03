---
title: avoid_empty_else
description: >-
  Details about the avoid_empty_else
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_empty_else"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Empty statements are not allowed in an 'else' clause._

## Description

The analyzer produces this diagnostic when the statement after an `else`
is an empty statement (a semicolon).

For more information, see the documentation for
[`avoid_empty_else`](https://dart.dev/diagnostics/avoid_empty_else).

## Example

The following code produces this diagnostic because the statement
following the `else` is an empty statement:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else [!;!]
    print("2");
}
```

## Common fixes

If the statement after the empty statement is intended to be executed only
when the condition is `false`, then remove the empty statement:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else
    print("2");
}
```

If there is no code that is intended to be executed only when the
condition is `false`, then remove the whole `else` clause:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  print("2");
}
```
