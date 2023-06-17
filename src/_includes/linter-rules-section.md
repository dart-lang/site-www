{% for lint in site.data.linter_rules %}

{% if lint.group == include.type %}

<a id="{{lint.name}}"></a>
{% if lint.sinceDartSdk contains "wip" %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}}) _(Unreleased)_
{% elsif lint.state != "stable" %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}}) _({{lint.state | capitalize}})_
{% else %}
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}})
{% endif -%}
<br>{{lint.description}}

{% endif %}

{% endfor %}
