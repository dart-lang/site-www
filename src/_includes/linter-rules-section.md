{% for lint in site.data.linter_rules %}

{% if lint.group == include.type %}

### {{lint.name}}

{{lint.description}}

{% if lint.sinceDartSdk == "Unreleased" %}
_This rule is currently **experimental**
and not yet available in a stable SDK._
{% elsif lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**
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
[{{set}}](#{{set_link}}){% if forloop.last == false %},{% endif %}
{% endcapture %}

{%- assign rule_sets = rule_sets | append: rule_set -%}

{% endfor %}

<em>Rule sets: {{ rule_sets }}</em>

{% endif %}

{% if lint.fixStatus == "hasFix" %}
<em>This rule has a [quick fix](#quick-fixes) available.</em>
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
