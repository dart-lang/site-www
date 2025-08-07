---
pagination:
  data: linter_rules
  size: 1
  alias: lint
  addAllPagesToCollections: true
underscore_breaker_titles: true
eleventyComputed:
  permalink: "/tools/linter-rules/{{lint.name}}.html"
  title: "{{ lint.name }}"
  description: "Learn about the {{ lint.name }} linter rule."
skipFreshness: true
---

<div class="tags">
{% if lint.sinceDartSdk == "Unreleased" or lint.sinceDartSdk contains "-wip" -%}
<div class="tag-label orange" title="Lint is unreleased or work in progress." aria-label="Lint is unreleased or work in progress.">
<span class="material-symbols" aria-hidden="true">pending</span>
<span>Unreleased</span>
</div>
{% elsif lint.state == "experimental" -%}
<div class="tag-label orange" title="Lint is experimental." aria-label="Lint is experimental.">
<span class="material-symbols" aria-hidden="true">science</span>
<span>Experimental</span>
</div>
{% elsif lint.state == "deprecated" -%}
<div class="tag-label orange" title="Lint is deprecated." aria-label="Lint is deprecated.">
<span class="material-symbols" aria-hidden="true">report</span>
<span>Deprecated</span>
</div>
{% elsif lint.state == "removed" -%}
<div class="tag-label red" title="Lint has been removed." aria-label="Lint has been removed.">
<span class="material-symbols" aria-hidden="true">error</span>
<span>Removed</span>
</div>
{% else -%}
<div class="tag-label green" title="Lint is stable." aria-label="Lint is stable.">
<span class="material-symbols" aria-hidden="true">verified_user</span>
<span>Stable</span>
</div>
{% endif -%}
{% if lint.sets contains "core" -%}
<div class="tag-label" title="Lint is included in the core set of rules." aria-label="Lint is included in the core set of rules.">
<span class="material-symbols" aria-hidden="true">circles</span>
<span>Core</span>
</div>
{% elsif lint.sets contains "recommended" -%}
<div class="tag-label" title="Lint is included in the recommended set of rules." aria-label="Lint is included in the recommended set of rules.">
<span class="material-symbols" aria-hidden="true">thumb_up</span>
<span>Recommended</span>
</div>
{% elsif lint.sets contains "flutter" -%}
<div class="tag-label" title="Lint is included in the Flutter set of rules." aria-label="Lint is included in the Flutter set of rules.">
<span class="material-symbols" aria-hidden="true">flutter</span>
<span>Flutter</span>
</div>
{% endif -%}
{% if lint.fixStatus == "hasFix" %}
<div class="tag-label" title="Lint has one or more quick fixes available." aria-label="Lint has one or more quick fixes available.">
<span class="material-symbols" aria-hidden="true">build</span>
<span>Fix available</span>
</div>
{% endif %}
</div>

{{lint.description}}

## Details

{{lint.details}}

{% if lint.incompatible != empty -%}

## Incompatible rules

The `{{lint.name}}` rule is incompatible with the following rules:

{% for incompatible in lint.incompatible -%}
- [`{{incompatible}}`](/tools/linter-rules/{{incompatible}})
{% endfor -%}

{% endif -%}

<a id="usage" aria-hidden="true"></a>

## Enable

To enable the `{{lint.name}}` rule,
add `{{lint.name}}` under **linter > rules** in your
[`analysis_options.yaml`](/tools/analysis) file:

```yaml title="analysis_options.yaml"
linter:
  rules:
    - {{lint.name}}
```

If you're instead using the YAML map syntax to configure linter rules,
add `{{lint.name}}: true` under **linter > rules**:

```yaml title="analysis_options.yaml"
linter:
  rules:
    {{lint.name}}: true
```
