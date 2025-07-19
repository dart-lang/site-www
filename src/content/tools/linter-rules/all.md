---
title: All linter rules
description: Auto-generated configuration enabling all linter rules.
showToc: false
show_breadcrumbs: true
processLints: true
---

The following is an auto-generated list of all linter rules
available in the Dart SDK as of version `{{site.sdkVersion}}`.
Add them to your
[`analysis_options.yaml`](/tools/analysis) file
and adjust as you see fit.

```yaml title="analysis_options.yaml"
linter:
  rules:
    {%- for lint in lintsToShow %}
    - {{lint.name}}
    {%- endfor %}
```
