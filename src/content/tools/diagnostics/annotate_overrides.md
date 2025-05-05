---
title: annotate_overrides
description: >-
  Details about the annotate_overrides
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/annotate_overrides"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The member '{0}' overrides an inherited member but isn't annotated with
'@override'._

## Description

The analyzer produces this diagnostic when a member overrides an inherited
member, but isn't annotated with `@override`.

## Example

The following code produces this diagnostic because the method `m` in the
class `B` overrides the method with the same name in class `A`, but isn't
marked as an intentional override:

```dart
class A {
  void m() {}
}

class B extends A {
  void [!m!]() {}
}
```

## Common fixes

If the member in the subclass is intended to override the member in the
superclass, then add an `@override` annotation:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

If the member in the subclass is not intended to override the member in
the superclass, then rename one of the members:

```dart
class A {
  void m() {}
}

class B extends A {
  void m2() {}
}
```
