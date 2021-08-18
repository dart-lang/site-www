{% for lint in site.data.linter_rules %}

{% if lint.group == include.type %}

### {{lint.name}}

{{lint.description}}

{% if lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**._
{% endif %}

{% if lint.sets != empty %}

{% assign rule_sets = "" %}

{% for set in lint.sets %}

{%- capture rule_set -%}
[{{set}}](#{{set}}){% if forloop.last == false %},{% endif %}
{% endcapture %}

{%- assign rule_sets = rule_sets | append: rule_set -%}

{% endfor %}

<em>Rule sets: {{ rule_sets }}</em>

{% endif %}

{% if lint.incompatible != empty %}

{% assign incompatible_rules = "" %}

{% for incompatible in lint.incompatible %}

{%- capture incompatible_rule -%}
[{{incompatible}}](#{{incompatible}}){% if forloop.last == false %},{% endif %}
{% endcapture %}

{% assign incompatible_rules = incompatible_rules | append: incompatible_rule %}

{% endfor %}

<em>Incompatible rules: {{ incompatible_rules }}</em>

{% endif %}

#### Details

{{lint.details}}

{% endif %}

{% endfor %}
