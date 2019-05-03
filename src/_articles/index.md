---
title: Articles
description: Read early articles about the Dart language and libraries.
---

Read these articles for insight into the Dart language and its libraries.
To find newer articles, see the
[Dart publication on medium.com.](https://medium.com/dartlang)

Also see:

* [Effective Dart](/guides/language/effective-dart)
* [Tutorials](/tutorials)
* [Articles about Dart web development]({{site.webdev}}/articles)

<div class="break-80">
  <h2>Language details</h2>
  {% assign articles = site.articles | where: 'categories', 'language' | sort: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>

<div class="break-80">
  <h2>Libraries and APIs</h2>
  {% assign articles = site.articles | where: 'categories', 'libraries' | sort: 'date' | reverse %}
  <ul class="nav-list">
    {% for article in articles %}
      <li>{% include article_summary.html %}</li>
    {% endfor %}
  </ul>
</div>
