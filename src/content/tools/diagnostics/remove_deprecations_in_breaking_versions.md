---
title: remove_deprecations_in_breaking_versions
description: >-
  Details about the remove_deprecations_in_breaking_versions
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/remove_deprecations_in_breaking_versions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Remove deprecated elements in breaking versions._

## Description

The analyzer produces this diagnostic in packages that have a "breaking"
version number (`x.0.0` or `0.x.0`) for every declaration that has a
`@Deprecated` annotation.

## Example

Given a package with a `pubspec.yaml` file containing:

```yaml
name: p
version: 2.0.0
environment:
  sdk: ^3.9.0
```

The following code produces this diagnostic because the function `f` is
annotated with `@deprecated`:

```dart
@[!deprecated!]
void f() {}

void g() {}
```

## Common fixes

* If the declaration should be removed in the next release of the package,
then remove the declaration:

```dart
void g() {}
```

* If you are not making a breaking change, then use a minor or patch
  version increment for the package:

```yaml
name: p
version: 1.0.1
environment:
  sdk: ^3.9.0
```
