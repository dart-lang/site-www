---
layout: default
title: "Articles: Dart VM"
description: "Articles pertaining to the Dart Virtual Machine (VM), such as benchmarking, native extensions, and numeric computation"
permalink: /articles/dart-vm/
toc: false
---

Read these articles for insight into the Dart VM.

Also see: [Articles about the Dart language and libraries](/articles/)

<div class="break-80">
  {% assign articles = site.articles | filter: 'dart-vm' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

Also see:

* [Language articles](/articles/language/)
* [Libraries articles](/articles/libraries/)
* [Design decision articles](/articles/design-decisions/)
* [webdev articles]({{site.webdev}}/articles/)
