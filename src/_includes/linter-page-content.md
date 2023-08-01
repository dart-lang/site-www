{% assign lint = include.lint -%}

{{lint.description}}

{% if lint.sinceDartSdk == "Unreleased" %}
_This rule is currently **experimental**
and not yet available in a stable SDK._
{% elsif lint.state == "removed" %}
_This rule has been removed as of the latest Dart releases._
{% elsif lint.state != "stable" %}
_This rule is currently **{{lint.state}}**
and available as of Dart {{lint.sinceDartSdk}}._
{% else %}
_This rule is available as of Dart {{lint.sinceDartSdk}}._
{% endif %}

{% if lint.sets != empty %}

{% assign rule_sets = "" %}

{% for set in lint.sets %}

{% if set == "core" or set == "recommended" %}
{% assign set_link = "lints" %}
{% elsif set == "flutter" %}
{% assign set_link = "flutter_lints" %}
{% else %}
{% assign set_link = set %}
{% endif %}

{%- capture rule_set -%}
[{{set}}](/tools/linter-rules#{{set_link}}){% if forloop.last == false %},{% endif %}
{% endcapture %}

{%- assign rule_sets = rule_sets | append: rule_set -%}

{% endfor %}

<em>Rule sets: {{ rule_sets }}</em>

{% endif %}

{% if lint.fixStatus == "hasFix" %}
<em>This rule has a [quick fix](/tools/linter-rules#quick-fixes) available.</em>
{% endif %}

{% if lint.incompatible != empty %}

{% assign incompatible_rules = "" %}

{% for incompatible in lint.incompatible %}

{%- capture incompatible_rule -%}
[{{incompatible}}](/tools/linter-rules/{{incompatible}}){% if forloop.last == false %},{% endif %}
{% endcapture %}

{% assign incompatible_rules = incompatible_rules | append: incompatible_rule %}

{% endfor %}

<em>Incompatible rules: {{ incompatible_rules }}</em>

{% endif %}

## Details

{{lint.details}}

## Usage

To enable the `{{lint.name}}` rule,
add `{{lint.name}}` under **linter > rules** in your
[`analysis_options.yaml`](/tools/analysis)
file:

```yaml
linter:
  rules:
    - {{lint.name}}
```
