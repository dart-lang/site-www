---
title: only_throw_errors
description: >-
  Details about the only_throw_errors
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/only_throw_errors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't throw instances of classes that don't extend either 'Exception' or
'Error'._

## Description

The analyzer produces this diagnostic when the value being thrown isn't a
subclass of either `Exception` or `Error`.

## Example

The following code produces this diagnostic because the string `'f'` is
being thrown:

```dart
void f() => throw [!'f'!];
```

## Common fixes

Replace the value with an instance of a subclass of either `Exception` or
`Error`:

```dart
void f() => throw ArgumentError('f');
```
