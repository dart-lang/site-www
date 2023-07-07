---
title: All linter rules
description: Auto-generated configuration enabling all linter rules.
toc: false
show_breadcrumbs: true
---

The following is an auto-generated list of all linter rules
available in the Dart SDK as of version `{{site.data.pkg-vers.SDK.vers}}`.
Add them to your
[`analysis_options.yaml`](/tools/analysis) file
and adjust as you see fit.

<?code-excerpt ?>
```yaml
linter:
  rules:
    {% for lint in site.data.linter_rules %}
    {%- if lint.sinceDartSdk != "Unreleased" and lint.state != "removed" -%}
    - {{lint.name}}
    {% endif -%}
    {% endfor -%}
```
<div class="prettify-filename">analysis_options.yaml</div>
