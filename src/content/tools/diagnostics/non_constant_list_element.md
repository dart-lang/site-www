---
title: non_constant_list_element
description: >-
  Details about the non_constant_list_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The values in a const list literal must be constants._

## Description

The analyzer produces this diagnostic when an element in a constant list
literal isn't a constant value. The list literal can be constant either
explicitly (because it's prefixed by the `const` keyword) or implicitly
(because it appears in a [constant context][]).

## Example

The following code produces this diagnostic because `x` isn't a constant,
even though it appears in an implicitly constant list literal:

```dart
var x = 2;
var y = const <int>[0, 1, [!x!]];
```

## Common fixes

If the list needs to be a constant list, then convert the element to be a
constant. In the example above, you might add the `const` keyword to the
declaration of `x`:

```dart
const x = 2;
var y = const <int>[0, 1, x];
```

If the expression can't be made a constant, then the list can't be a
constant either, so you must change the code so that the list isn't a
constant. In the example above this means removing the `const` keyword
before the list literal:

```dart
var x = 2;
var y = <int>[0, 1, x];
```

[constant context]: /resources/glossary#constant-context
