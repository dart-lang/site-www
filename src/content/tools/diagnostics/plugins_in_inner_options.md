---
title: plugins_in_inner_options
description: >-
  Details about the plugins_in_inner_options
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Plugins can only be specified in the root of a pub workspace or the root of a package that isn't in a workspace._

## Description

The analyzer produces this diagnostic when analyzer plugins are defined in
an analysis options file other than the `analysis_options.yaml` at the
root of the package.

## Example

Given an `analysis_options.yaml` file located in a subdirectory of the
package root, the following code produces this diagnostic because it
attempts to define plugins there:

```yaml
// %uri="inner/analysis_options.yaml"
[!plugins!]:
  one: ^1.0.0
```

## Common fixes

Remove the list of plugins from the file.
