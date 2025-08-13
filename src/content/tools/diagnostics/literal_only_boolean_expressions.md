---
title: literal_only_boolean_expressions
description: >-
  Details about the literal_only_boolean_expressions
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/literal_only_boolean_expressions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The Boolean expression has a constant value._

## Description

The analyzer produces this diagnostic when the value of the condition in
an `if` or loop statement is known to be either always `true` or always
`false`. An exception is made for a `while` loop whose condition is the
Boolean literal `true`.

## Examples

The following code produces this diagnostic because the condition will
always evaluate to `true`:

```dart
void f() {
  [!if (true) {!]
    [!print('true');!]
  [!}!]
}
```

The lint will evaluate a subset of expressions that are composed of
constants, so the following code will also produce this diagnostic because
the condition will always evaluate to `false`:

```dart
void g(int i) {
  [!if (1 == 0 || 3 > 4) {!]
    [!print('false');!]
  [!}!]
}
```

## Common fixes

If the condition is wrong, then correct the condition so that it's value
can't be known at compile time:

```dart
void g(int i) {
  if (i == 0 || i > 4) {
    print('false');
  }
}
```

If the condition is correct, then simplify the code to not evaluate the
condition:

```dart
void f() {
  print('true');
}
```
