---
title: default_list_constructor
description: >-
  Details about the default_list_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_The default 'List' constructor isn't available when null safety is enabled._

## Description

The analyzer produces this diagnostic when it finds a use of the default
constructor for the class `List` in code that has opted in to null safety.

## Example

Assuming the following code is opted in to null safety, it produces this
diagnostic because it uses the default `List` constructor:

```dart
var l = [!List<int>!]();
```

## Common fixes

If no initial size is provided, then convert the code to use a list
literal:

```dart
var l = <int>[];
```

If an initial size needs to be provided and there is a single reasonable
initial value for the elements, then use `List.filled`:

```dart
var l = List.filled(3, 0);
```

If an initial size needs to be provided but each element needs to be
computed, then use `List.generate`:

```dart
var l = List.generate(3, (i) => i);
```
