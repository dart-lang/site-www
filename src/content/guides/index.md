---
title: Dart documentation
description: Learn to use the Dart language and libraries.
toc: false
---

## An approachable, portable, and productive language to create high-quality apps on any platform.

{% comment %}
To update these cards, edit src/_data/docs_cards.yml.
{% endcomment %}

<div class="card-grid card-col3">
{% for card in docs_cards.main -%}
  <div class="card">
    <h3><a href="{{card.url}}">{{card.name}}</a></h3>
    <p>{{card.description}}</p>
  </div>
{% endfor -%}
</div>

## Learn about Dart

<div class="card-grid card-col2">
{% for card in docs_cards.learn -%}
  <div class="card">
    <h3><a href="{{card.url}}">{{card.name}}</a></h3>
    <p>{{card.description}}</p>
  </div>
{% endfor -%}
</div>

## Featured topics

<div class="card-grid card-col3">
{% for card in docs_cards.featured -%}
  <div class="card">
    <h3><a href="{{card.url}}">{{card.name}}</a></h3>
    <p>{{card.description}}</p>
  </div>
{% endfor -%}
</div>
