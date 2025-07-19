---
title: ambiguous_set_or_map_literal_both
description: >-
  Details about the ambiguous_set_or_map_literal_both
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_The literal can't be either a map or a set because it contains at least one
literal map entry or a spread operator spreading a 'Map', and at least one element which is neither of these._

## Description

Because map and set literals use the same delimiters (`{` and `}`), the
analyzer looks at the type arguments and the elements to determine which
kind of literal you meant. When there are no type arguments, then the
analyzer uses the types of the elements. If all of the elements are literal
map entries and all of the spread operators are spreading a `Map` then it's
a `Map`. If none of the elements are literal map entries and all of the
spread operators are spreading an `Iterable`, then it's a `Set`. If neither
of those is true then it's ambiguous.

The analyzer produces this diagnostic when at least one element is a
literal map entry or a spread operator spreading a `Map`, and at least one
element is neither of these, making it impossible for the analyzer to
determine whether you are writing a map literal or a set literal.

## Example

The following code produces this diagnostic:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    [!{...a, ...b, ...c}!];
```

The list `b` can only be spread into a set, and the maps `a` and `c` can
only be spread into a map, and the literal can't be both.

## Common fixes

There are two common ways to fix this problem. The first is to remove all
of the spread elements of one kind or another, so that the elements are
consistent. In this case, that likely means removing the list and deciding
what to do about the now unused parameter:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, ...c};
```

The second fix is to change the elements of one kind into elements that are
consistent with the other elements. For example, you can add the elements
of the list as keys that map to themselves:

```dart
union(Map<String, String> a, List<String> b, Map<String, String> c) =>
    {...a, for (String s in b) s: s, ...c};
```
