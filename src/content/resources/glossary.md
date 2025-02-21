---
title: Glossary
description: A glossary reference for terminology used across dart.dev.
body_class: glossary-page
toc: false
---

{% comment %}
  Write glossary entries into the src/_data/glossary.yml file.
{% endcomment -%}

The following are definitions of terms used across the Dart documentation.

{% assign sorted_terms = glossary | sort: "term" %}

<section id="filter-and-search"></section>

<section class="content-search-results">
<div class="card-grid">

{% for term in sorted_terms -%}

{% assign cardId = term.id | default: term.term | slugify -%}
<div class="glossary-card expandable-card" id="{{cardId}}">
<div class="card-header">
<h2 class="card-title">{{term.term}}</h2>

<div class="card-buttons">
  <a class="share-button icon-button" href="#{{cardId}}" title="Link to card" aria-label="Link to {{term.term}} card">
    <span class="material-symbols" aria-hidden="true">tag</span>
  </a>
  <button class="expand-button icon-button" title="Expand or collapse card" aria-label="Expand or collapse {{term.term}} card">
    <span class="material-symbols" aria-hidden="true">keyboard_arrow_up</span>
  </button>
</div>
</div>
<div class="initial-content">

{{term.short_description}}

</div>
<div class="expandable-content">

{% if term.long_description -%}
{{term.long_description }}
{% endif -%}

{% if term.related_links and term.related_links.size > 0 -%}
<div>
<h3 class="no_toc details-header">Related docs and resources</h3>


<ul class="resources-list">

{% for link in term.related_links -%}
<li>
<a href="{{link.link}}" class="filled-button">
<span class="material-symbols" aria-hidden="true">
{%- case link.type %}
  {% when "term", "glossary" %}
    dictionary
  {% when "article", "doc" %}
    article
  {% when "tutorial" %}
    school
  {% when "api" %}
    description
  {% when "video" %}
    play_arrow
  {% when "code", "sample" %}
    code_blocks
  {% else %}
    article
{% endcase -%}
</span>
<span>{{link.text}}</span>
</a>
</li>
{% endfor -%}

</ul>

</div>
{% endif -%}

</div>
</div>

{% endfor -%}
</div>
</section>
