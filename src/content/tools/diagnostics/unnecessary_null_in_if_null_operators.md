---
title: unnecessary_null_in_if_null_operators
description: >-
  Details about the unnecessary_null_in_if_null_operators
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_in_if_null_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of '??' with 'null'._

## Description

The analyzer produces this diagnostic when the right operand of the `??`
operator is the literal `null`.

## Example

The following code produces this diagnostic because the right-hand operand
of the `??` operator is `null`:

```dart
String? f(String? s) => s ?? [!null!];
```

## Common fixes

If a non-null value should be used for the right-hand operand, then
change the right-hand side:

```dart
String f(String? s) => s ?? '';
```

If there is no non-null value to use for the right-hand operand, then
remove the operator and the right-hand operand:

```dart
String? f(String? s) => s;
```
