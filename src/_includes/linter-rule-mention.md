{%- assign split_rules = rules | split: ', ' -%}
Linter rule{% if split_rules.size > 1 %}s{% endif %}:
{%- for rule in split_rules %}
  [{{rule}}](/tools/linter-rules/{{rule}}){%- unless forloop.last %}, {% endunless %}
{%- endfor %}
{:.linter-rule}