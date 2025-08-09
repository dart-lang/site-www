---
title: switch_on_type
description: >-
  Details about the switch_on_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/switch_on_type"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Avoid switch statements on a 'Type'._

## Description

The analyzer produces this diagnostic when a switch statement or switch
expression is used on either the value of a `Type` or a `toString` call
on a `Type`.

## Example

The following code produces this diagnostic because the switch statement
is used on a `Type`:

```dart
void f(Object o) {
  switch ([!o.runtimeType!]) {
    case const (int):
      print('int');
    case const (String):
      print('String');
  }
}
```

## Common fixes

Use pattern matching on the variable instead:

```dart
void f(Object o) {
  switch (o) {
    case int():
      print('int');
    case String():
      print('String');
  }
}
```
