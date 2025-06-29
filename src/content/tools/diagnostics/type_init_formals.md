---
title: type_init_formals
description: >-
  Details about the type_init_formals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_init_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't needlessly type annotate initializing formals._

## Description

The analyzer produces this diagnostic when an initializing formal
parameter (`this.x`) or a super parameter (`super.x`) has an explicit type
annotation that is the same as the field or overridden parameter.

If a constructor parameter is using `this.x` to initialize a field, then
the type of the parameter is implicitly the same type as the field. If a
constructor parameter is using `super.x` to forward to a super
constructor, then the type of the parameter is implicitly the same as the
super constructor parameter.

## Example

The following code produces this diagnostic because the parameter `this.c`
has an explicit type that is the same as the field `c`:

```dart
class C {
  int c;

  C([!int!] this.c);
}
```

The following code produces this diagnostic because the parameter
`super.a` has an explicit type that is the same as the parameter `a` from
the superclass:

```dart
class A {
  A(int a);
}

class B extends A {
  B([!int!] super.a);
}
```

## Common fixes

Remove the type annotation from the parameter:

```dart
class C {
  int c;

  C(this.c);
}
```
