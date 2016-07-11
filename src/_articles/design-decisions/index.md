---
layout: default
title: "Articles: Design Decisions"
description: "Articles related to the reasoning behind some of Dart's design decisions."
permalink: /articles/design-decisions/
toc: false
---

Read these articles for insight into why Dart was designed to work the way it works.

<div class="break-80">
  {% assign articles = site.articles | filter: 'design-decisions' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

Also see:

* [Language articles](/articles/language/)
* [Libraries articles](/articles/libraries/)
* [Dart VM articles](/articles/dart-vm/)
* [webdev articles]({{site.webdev}}/articles/)
