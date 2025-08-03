---
title: main_first_positional_parameter_type
description: >-
  Details about the main_first_positional_parameter_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---

_The type of the first positional parameter of the 'main' function must be a
supertype of 'List<String>'._

## Description

The analyzer produces this diagnostic when the first positional parameter
of a function named `main` isn't a supertype of `List<String>`.

## Example

The following code produces this diagnostic because `List<int>` isn't a
supertype of `List<String>`:

```dart
void main([!List<int>!] args) {}
```

## Common fixes

If the function is an entry point, then change the type of the first
positional parameter to be a supertype of `List<String>`:

```dart
void main(List<String> args) {}
```

If the function isn't an entry point, then change the name of the function:

```dart
void f(List<int> args) {}
```
