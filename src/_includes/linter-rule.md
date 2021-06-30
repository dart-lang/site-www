{% assign lint = include.lint %}

### {{lint.name}}

{{lint.description}}

{% if lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**._
{% endif %}

{% if lint.incompatible != empty %}

{% assign incompatible_rules = "" | split: ',' %}

{% for incompatible in lint.incompatible %}

{%- capture incompatible_rule -%}
[{{incompatible}}](#{{incompatible}})
{% endcapture %}

{% assign incompatible_rules = incompatible_rules | push: incompatible_rule %}

{% endfor %}

<em>Incompatible rules: {{ incompatible_rules | join: ", " }}</em>

{% endif %}

#### Details

{{lint.details}}
