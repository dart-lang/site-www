---
title: Books about Dart
description: Read all about it! Here's a collection of books about Dart.
toc: false
---

This page covers a collection of books about the Dart language.
Many [Flutter books]({{site.flutter-docs}}/resources/books)
also cover Dart.
If you find another Dart book that might be helpful,
[let us know.]({{site.repo.this}}/issues)

:::warning
If you find a Dart book not listed on this page,
check for publication dates after June 2021.
Older books lack coverage of Dart 2 and 3 topics such as
strong typing, null safety, FFI, the `dart` command-line utility,
and new developer tools.
:::


{% for book in books-dart %}

<div class="book-img-with-details row">
<a href="{{book.link}}" title="{{book.title}}" class="col-sm-3">
  <img src="/assets/img/cover/{{book.cover}}" alt="{{book.title}}">
</a>
<div class="details col-sm-9">

### [{{book.title}}]({{book.link}})
{:.title}

by {{book.authors | array_to_sentence_string}}
{:.authors.h4}

{{book.desc}}

</div>
</div>
{% endfor %}
