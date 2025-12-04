---
title: recursive_include_file
description: >-
  Details about the recursive_include_file
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The URI '{0}' included in '{1}' includes '{1}', creating a circular reference._

## Description

The analyzer produces this diagnostic when an analysis options file,
directly or indirectly, includes itself.

## Examples

The following code produces this diagnostic because the file directly
includes itself:

```yaml
// %uri="analysis_options.yaml"
include: [!analysis_options.yaml!]
```

Given a file named `shared_options.yaml` that contains:

```yaml
// %uri="shared_options.yaml"
include: analysis_options.yaml
```

The following code produces this diagnostic because the file indirectly
includes itself:

```yaml
// %uri="analysis_options.yaml"
include: [!shared_options.yaml!]
```

## Common fixes

Change at least one of the files in order to break the circularity.
