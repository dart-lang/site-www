---
title: unnecessary_to_list_in_spreads
description: >-
  Details about the unnecessary_to_list_in_spreads
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_to_list_in_spreads"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of 'toList' in a spread._

## Description

The analyzer produces this diagnostic when `toList` is used to convert an
`Iterable` to a `List` just before a spread operator is applied to the
list. The spread operator can be applied to any `Iterable`, so the
conversion isn't necessary.

## Example

The following code produces this diagnostic because `toList` is invoked on
the result of `map`, which is an `Iterable` that the spread operator could
be applied to directly:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()).[!toList!](),
  ];
}
```

## Common fixes

Remove the invocation of `toList`:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()),
  ];
}
```
