{:.linter-rule}
{% if include.rule %}
Linter rule: [{{include.rule}}](/tools/linter-rules/{{include.rule}})
{% else %}
Linter rules: [{{include.rule1}}](/tools/linter-rules/{{include.rule1}}), [{{include.rule2}}](/tools/linter-rules/{{include.rule2}})
{% endif %}
