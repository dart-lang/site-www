---
title: Dart documentation
description: Learn to use the Dart language and libraries.
showToc: false
showBreadcrumbs: false
---

Welcome to the Dart documentation!
For a list of changes to this site—new pages, new guidelines, and more—see
the [What's new][] page.

[What's new]: /resources/whats-new

Here are some of this site's most visited pages:

{% comment %}
To update these cards, edit src/_data/docs_cards.yml.
{% endcomment %}

<div class="card-grid">
{% for card in docs_cards -%}
  <Card title="{{card.name}}" link="{{card.url}}">

  {{card.description}}

  </Card>
{% endfor -%}
</div>
<!-- Small Hacktoberfest edit -->
