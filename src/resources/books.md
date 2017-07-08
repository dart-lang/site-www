---
layout: default
permalink: /resources/books
title: Publications about Dart
description: Read all about it! Here's a collection of publications about Dart.
toc: false
---

Here's a collection of publications about Dart.
If you find another resource that we should add,
[let us know](https://github.com/dart-lang/site-www/issues).

{% for book in site.data.books %}
<div class="item-with-pic">
  <a href="{{ book.link }}" title="{{ book.title }}">
    <img src="{% asset_path 'covers/{{ book.cover }}' %}" alt="Cover: {{ book.title }}"/>
  </a>
  <div class="details">
    <h3 class="title"><a href="{{ book.link }}" title="{{ book.title }}">{{ book.title }}</a></h3>
    <h4 class="authors">by {{ book.authors | array_to_sentence_string }}</h4>
    <p>{{ book.desc }}</p>
  </div>
</div>
{% endfor %}
