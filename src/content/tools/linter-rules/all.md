---
title: All linter rules
description: Auto-generated configuration enabling all linter rules.
toc: false
show_breadcrumbs: true
---

The following is an auto-generated list of all linter rules
available in the Dart SDK as of version `{{site.sdkInfo.version}}`.
Add them to your
[`analysis_options.yaml`](/tools/analysis) file
and adjust as you see fit.

{% assign sorted_lints = linter_rules | sort: "name" %}

```yaml title="analysis_options.yaml"
linter:
  rules:
    {% for lint in sorted_lints %}
    {%- if lint.sinceDartSdk != "Unreleased" and lint.sinceDartSdk not contains "-wip" and lint.state != "removed" and lint.state != "internal" -%}
    - {{lint.name}}
    {% endif -%}
    {%- endfor %}
```
