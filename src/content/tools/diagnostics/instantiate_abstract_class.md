---
title: instantiate_abstract_class
description: >-
  Details about the instantiate_abstract_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

_Abstract classes can't be instantiated._

## Description

The analyzer produces this diagnostic when it finds a constructor
invocation and the constructor is declared in an abstract class. Even
though you can't create an instance of an abstract class, abstract classes
can declare constructors that can be invoked by subclasses.

## Example

The following code produces this diagnostic because `C` is an abstract
class:

```dart
abstract class C {}

var c = new [!C!]();
```

## Common fixes

If there's a concrete subclass of the abstract class that can be used, then
create an instance of the concrete subclass.
