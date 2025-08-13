---
title: implicit_call_tearoffs
description: >-
  Details about the implicit_call_tearoffs
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/implicit_call_tearoffs"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Implicit tear-off of the 'call' method._

## Description

The analyzer produces this diagnostic when an object with a `call` method
is assigned to a function-typed variable, implicitly tearing off the
`call` method.

## Example

The following code produces this diagnostic because an instance of
`Callable` is passed to a function expecting a `Function`:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt([!Callable()!]);
}
```

## Common fixes

Explicitly tear off the `call` method:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt(Callable().call);
}
```
