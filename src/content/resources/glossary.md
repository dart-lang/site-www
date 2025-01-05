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

<div class="glossary-card expandable-card">
<div class="card-header">
<h2 class="card-title" id="{{term.id | default: term.term | slugify}}">{{term.term}}</h2>

<button class="expand-button icon-button">
<span class="material-symbols">keyboard_arrow_up</span>
</button>
</div>
<div class="initial-content">

{{term.short_description}}

</div>
<div class="expandable-content">

{{term.long_description | default: term.short_description }}

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
</div>
</div>

{% endfor -%}
</div>
</section>
