{% for lint in site.data.linter_rules %}

{% if lint.group == include.type %}

<a id="{{lint.name}}"></a>
[`{{lint.name}}`](/tools/linter-rules/{{lint.name}})<br>
{{lint.description}}

{% endif %}

{% endfor %}
