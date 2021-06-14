{% if include.incompatible != empty %}

{% assign incompatible_rules = "" | split: ',' %}

{% for incompatible in include.incompatible %}

{%- capture incompatible_rule -%}
[{{incompatible}}](#{{incompatible}})
{% endcapture %}

{% assign incompatible_rules = incompatible_rules | push: incompatible_rule %}

{% endfor %}

<em>Incompatible rules: {{ incompatible_rules | join: ", " }}</em>

{% endif %}
