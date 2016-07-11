---
layout: default
permalink: /resources/books
title: Books about Dart
description: Read all about it! Here's a collection of books about Dart.
toc: false
---

Here's a collection of books about Dart.
[Let us know](https://github.com/dart-lang/www.dartlang.org/issues)
if you find another book that we should add.

{% for book in site.data.books %}
<div class="book">
  <div class="cover">
    <a href="{{ book.link }}" title="{{ book.title }}">
      <img src="{% asset_path 'covers/{{ book.cover }}' %}" alt="Cover: {{ book.title }}"/>
    </a>
  </div>
  <div class="details">
    <h3 class="title"><a href="{{ book.link }}" title="{{ book.title }}">{{ book.title }}</a></h3>
    <h4 class="authors">Written by {{ book.authors || array_to_sentence_string }}</h4>
    <p>{{ book.desc }}</p>
  </div>
</div>
{% endfor %}
