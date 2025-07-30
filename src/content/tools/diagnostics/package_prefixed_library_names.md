---
title: package_prefixed_library_names
description: >-
  Details about the package_prefixed_library_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
body_class: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/package_prefixed_library_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The library name is not a dot-separated path prefixed by the package name._

## Description

The analyzer produces this diagnostic when a library has a name that
doesn't follow these guidelines:

- Prefix all library names with the package name.
- Make the entry library have the same name as the package.
- For all other libraries in a package, after the package name add the
  dot-separated path to the library's Dart file.
- For libraries under `lib`, omit the top directory name.

For example, given a package named `my_package`, here are the library
names for various files in the package:


## Example

Assuming that the file containing the following code is not in a file
named `special.dart` in the `lib` directory of a package named `something`
(which would be an exception to the rule), the analyzer produces this
diagnostic because the name of the library doesn't conform to the
guidelines above:

```dart
library [!something.special!];
```

## Common fixes

Change the name of the library to conform to the guidelines.
