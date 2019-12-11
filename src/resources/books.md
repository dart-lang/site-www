---
title: Books about Dart
description: Read all about it! Here's a collection of books about Dart.
---

Here's a collection of books about Dart.
If you find another one that we should add,
[let us know.](https://github.com/dart-lang/site-www/issues)

## Dart 2

We don't know of any Dart 2 books yet.
Check back later to see the latest updates.
For information on converting Dart 1 code to Dart 2, see the
[Dart 2 migration guide](/dart-2).


## Dart 1

The following books cover Dart 1.

{% for book in site.data.books %}
<div class="book-img-with-details row">
<a href="{{book.link}}" title="{{book.title}}" class="col-sm-3 no-automatic-external">
  <img src="{% asset 'cover/{{book.cover}}' @path %}" alt="{{book.title}}"/>
</a>
<div class="details col-sm-9" markdown="1">
### [{{book.title}}]({{book.link}})
{:.title}

by {{book.authors | array_to_sentence_string}}
{:.authors.h4}

{{book.desc}}
</div>
</div>
{% endfor %}
