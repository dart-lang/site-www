---
title: ambiguous_set_or_map_literal_either
description: >-
  Details about the ambiguous_set_or_map_literal_either
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_This literal must be either a map or a set, but the elements don't have enough information for type inference to work._

## Description

Because map and set literals use the same delimiters (`{` and `}`), the
analyzer looks at the type arguments and the elements to determine which
kind of literal you meant. When there are no type arguments and all of the
elements are spread elements (which are allowed in both kinds of literals)
then the analyzer uses the types of the expressions that are being spread.
If all of the expressions have the type `Iterable`, then it's a set
literal; if they all have the type `Map`, then it's a map literal.

This diagnostic is produced when none of the expressions being spread have
a type that allows the analyzer to decide whether you were writing a map
literal or a set literal.

## Example

The following code produces this diagnostic:

```dart
union(a, b) => [!{...a, ...b}!];
```

The problem occurs because there are no type arguments, and there is no
information about the type of either `a` or `b`.

## Common fixes

There are three common ways to fix this problem. The first is to add type
arguments to the literal. For example, if the literal is intended to be a
map literal, you might write something like this:

```dart
union(a, b) => <String, String>{...a, ...b};
```

The second fix is to add type information so that the expressions have
either the type `Iterable` or the type `Map`. You can add an explicit cast
or, in this case, add types to the declarations of the two parameters:

```dart
union(List<int> a, List<int> b) => {...a, ...b};
```

The third fix is to add context information. In this case, that means
adding a return type to the function:

```dart
Set<String> union(a, b) => {...a, ...b};
```

In other cases, you might add a type somewhere else. For example, say the
original code looks like this:

```dart
union(a, b) {
  var x = [!{...a, ...b}!];
  return x;
}
```

You might add a type annotation on `x`, like this:

```dart
union(a, b) {
  Map<String, String> x = {...a, ...b};
  return x;
}
```
