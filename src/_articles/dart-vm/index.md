---
layout: default
title: "Articles: Server-Side Dart"
description: "Articles pertaining to command-line and server-side Dart apps, covering topics such as benchmarking, native extensions, and numeric computation."
permalink: /articles/dart-vm
toc: false
---

Read these articles for information that's relevant to
Dart apps that run on the command line or as servers.

Also see: [Articles about the Dart language and libraries](/articles)

{% include article_index_warning.md %}

<div class="break-80">
  {% assign articles = site.articles | filter: 'dart-vm' | order: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

Also see:

* [Language articles](/articles/language)
* [Libraries articles](/articles/libraries)
* [webdev articles]({{site.webdev}}/articles)
