---
title: unawaited_futures
description: >-
  Details about the unawaited_futures
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unawaited_futures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing an 'await' for the 'Future' computed by this expression._

## Description

The analyzer produces this diagnostic on an expression with a `Future`
type, only in a few specific cases:

* when the expression is itself a statement (like `f();`),
* when the expression is part of a cascade (like `C()..f()`),
* when the expression is a String interpolation (like `'${f()}'`).

The analyzer only produces this diagnostic on expressions inside an
`async` or `async*` function.

The two common corrections are to 'await' the expression, or to wrap the
expression in a call to `unawaited()`.

## Example

The following code produces this diagnostic because the function `g`
returns a future, but the future isn't awaited:

```dart
Future<void> f() async {
  [!g!]();
}

Future<int> g() => Future.value(0);
```

## Common fixes

If the future needs to complete before the following code is executed,
then add an `await` before the invocation:

```dart
Future<void> f() async {
  await g();
}

Future<int> g() => Future.value(0);
```

If the future doesn't need to complete before the following code is
executed, then wrap the `Future`-returning invocation in an invocation of
the `unawaited` function:

```dart
import 'dart:async';

Future<void> f() async {
  unawaited(g());
}

Future<int> g() => Future.value(0);
```
