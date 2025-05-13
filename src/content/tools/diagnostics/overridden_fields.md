---
title: overridden_fields
description: >-
  Details about the overridden_fields
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/overridden_fields"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Field overrides a field inherited from '{0}'._

## Description

The analyzer produces this diagnostic when a class defines a field that
overrides a field from a superclass.

Overriding a field with another field causes the object to have two
distinct fields, but because the fields have the same name only one of the
fields can be referenced in a given scope. That can lead to confusion
where a reference to one of the fields can be mistaken for a reference to
the other.

## Example

The following code produces this diagnostic because the field `f` in `B`
shadows the field `f` in `A`:

```dart
class A {
  int f = 1;
}

class B extends A {
  @override
  int [!f!] = 2;
}
```

## Common fixes

If the two fields are representing the same property, then remove the
field from the subclass:

```dart
class A {
  int f = 1;
}

class B extends A {}
```

If the two fields should be distinct, then rename one of the fields:

```dart
class A {
  int f = 1;
}

class B extends A {
  int g = 2;
}
```

If the two fields are related in some way, but can't be the same, then
find a different way to implement the semantics you need.
