---
title: unnecessary_null_aware_operator_on_extension_on_nullable
description: >-
  Details about the unnecessary_null_aware_operator_on_extension_on_nullable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_aware_operator_on_extension_on_nullable"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of a null-aware operator to invoke an extension method on a nullable type._

## Description

The analyzer produces this diagnostic when a null-aware operator is used
to invoke an extension method on an extension whose type is nullable.

## Example

The following code produces this diagnostic because the extension method
`m` is invoked using `?.` when it doesn't need to be:

```dart
extension E on int? {
  int m() => 1;
}

int? f(int? i) => i[!?.!]m();
```

## Common fixes

If it isn't a requirement not invoke the method when the receiver is
`null`, then remove the question mark from the invocation:

```dart
extension E on int? {
  int m() => 1;
}

int? f(int? i) => i.m();
```
