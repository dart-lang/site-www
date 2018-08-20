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

## Dart 2

No Dart 2 publications exist yet.
Check back later to see the latest updates.
For information on converting Dart 1.x code to Dart 2, see the
[Dart 2 page](/dart-2).


## Dart 1.x

The following publications cover Dart 1.x.

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
