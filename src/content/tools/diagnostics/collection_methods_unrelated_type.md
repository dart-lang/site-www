---
title: collection_methods_unrelated_type
description: >-
  Details about the collection_methods_unrelated_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/collection_methods_unrelated_type"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The argument type '{0}' isn't related to '{1}'._

## Description

The analyzer produces this diagnostic when any one of several methods in
the core libraries are invoked with arguments of an inappropriate type.
These methods are ones that don't provide a specific enough type for the
parameter to allow the normal type checking to catch the error.

The arguments that are checked are:
- an argument to `Iterable<E>.contains` should be related to `E`
- an argument to `List<E>.remove` should be related to `E`
- an argument to `Map<K, V>.containsKey` should be related to `K`
- an argument to `Map<K, V>.containsValue` should be related to `V`
- an argument to `Map<K, V>.remove` should be related to `K`
- an argument to `Map<K, V>.[]` should be related to `K`
- an argument to `Queue<E>.remove` should be related to `E`
- an argument to `Set<E>.lookup` should be related to `E`
- an argument to `Set<E>.remove` should be related to `E`

## Example

The following code produces this diagnostic because the argument to
`contains` is a `String`, which isn't assignable to `int`, the element
type of the list `l`:

```dart
bool f(List<int> l)  => l.contains([!'1'!]);
```

## Common fixes

If the element type is correct, then change the argument to have the same
type:

```dart
bool f(List<int> l)  => l.contains(1);
```

If the argument type is correct, then change the element type:

```dart
bool f(List<String> l)  => l.contains('1');
```
