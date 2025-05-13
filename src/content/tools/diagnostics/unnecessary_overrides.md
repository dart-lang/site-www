---
title: unnecessary_overrides
description: >-
  Details about the unnecessary_overrides
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_overrides"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary override._

## Description

The analyzer produces this diagnostic when an instance member overrides an
inherited member but only invokes the overridden member with exactly the
same arguments.

## Example

The following code produces this diagnostic because the method `D.m`
doesn't do anything other than invoke the overridden method:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int [!m!](int x) => super.m(x);
}
```

## Common fixes

If the method should do something more than what the overridden method
does, then implement the missing functionality:

```dart
class C {
  int m(int x) => x;
}

class D extends C {
  @override
  int m(int x) => super.m(x) + 1;
}
```

If the overridden method should be modified by changing the return type or
one or more of the parameter types, making one of the parameters
`covariant`, having a documentation comment, or by having additional
annotations, then update the code:

```dart
import 'package:meta/meta.dart';

class C {
  int m(int x) => x;
}

class D extends C {
  @mustCallSuper
  @override
  int m(int x) => super.m(x);
}
```

If the overriding method doesn't change or enhance the semantics of the
code, then remove it:

```dart
class C {
  int m(int x) => x;
}

class D extends C {}
```
