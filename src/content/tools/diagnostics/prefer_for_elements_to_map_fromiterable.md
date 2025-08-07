---
title: prefer_for_elements_to_map_fromiterable
description: >-
  Details about the prefer_for_elements_to_map_fromiterable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_for_elements_to_map_fromIterable"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'for' elements when building maps from iterables._

## Description

The analyzer produces this diagnostic when `Map.fromIterable` is used to
build a map that could be built using the `for` element.

## Example

The following code produces this diagnostic because `fromIterable` is
being used to build a map that could be built using a `for` element:

```dart
void f(Iterable<String> data) {
  [!Map<String, int>.fromIterable(!]
    [!data,!]
    [!key: (element) => element,!]
    [!value: (element) => element.length,!]
  [!)!];
}
```

## Common fixes

Use a `for` element to build the map:

```dart
void f(Iterable<String> data) {
  <String, int>{
    for (var element in data)
      element: element.length
  };
}
```
