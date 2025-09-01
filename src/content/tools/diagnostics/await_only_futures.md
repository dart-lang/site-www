---
title: await_only_futures
description: >-
  Details about the await_only_futures
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/await_only_futures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uses 'await' on an instance of '{0}', which is not a subtype of 'Future'._

## Description

The analyzer produces this diagnostic when the expression after `await`
has any type other than `Future<T>`, `FutureOr<T>`, `Future<T>?`,
`FutureOr<T>?` or `dynamic`.

An exception is made for the expression `await null` because it is a
common way to introduce a microtask delay.

Unless the expression can produce a `Future`, the `await` is unnecessary
and can cause a reader to assume a level of asynchrony that doesn't exist.

## Example

The following code produces this diagnostic because the expression after
`await` has the type `int`:

```dart
void f() async {
  [!await!] 23;
}
```

## Common fixes

Remove the `await`:

```dart
void f() async {
  23;
}
```
