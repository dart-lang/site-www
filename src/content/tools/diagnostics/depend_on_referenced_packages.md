---
title: depend_on_referenced_packages
description: >-
  Details about the depend_on_referenced_packages
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/depend_on_referenced_packages"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The imported package '{0}' isn't a dependency of the importing package._

## Description

The analyzer produces this diagnostic when a package import refers to a
package that is not specified in the `pubspec.yaml` file.

Depending explicitly on packages that you reference ensures they will
always exist and allows you to put a dependency constraint on them to
guard against breaking changes.

## Example

Given a `pubspec.yaml` file containing the following:

```yaml
dependencies:
  meta: ^3.0.0
```

The following code produces this diagnostic because there is no dependency
on the package `a`:

```dart
import 'package:a/a.dart';
```

## Common fixes

Whether the dependency should be a regular dependency or dev dependency
depends on whether the package is referenced from a public library (one
under either `lib` or `bin`), or only private libraries, (such as one
under `test`).

If the package is referenced from at least one public library, then add a
regular dependency on the package to the `pubspec.yaml` file under the
`dependencies` field:

```yaml
dependencies:
  a: ^1.0.0
  meta: ^3.0.0
```

If the package is referenced only from private libraries, then add a
dev dependency on the package to the `pubspec.yaml` file under the
`dev_dependencies` field:

```yaml
dependencies:
  meta: ^3.0.0
dev_dependencies:
  a: ^1.0.0
```
