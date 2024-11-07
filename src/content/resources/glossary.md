---
title: Glossary
description: A glossary reference for terminology used across dart.dev.
body_class: glossary-page
---

{% comment %}
  Write glossary entries into the src/_data/glossary.yml file.
{% endcomment -%}

The following are definitions of terms used across the Dart documentation.

{% assign sorted_terms = glossary | sort: "term" %}

{% for term in sorted_terms -%}

<div class="term-separator" aria-hidden="true"></div>

## {{term.term}}{% if term.id %} {:#{{term.id}}}{% endif %}

{{term.long_description | default: term.short_description }}

{% if term.related_links != empty -%}
**Related docs and resources:**

{% for link in term.related_links -%}
- [{{link.text}}]({{link.link}})
{% endfor -%}
{% endif -%}
{% endfor -%}
