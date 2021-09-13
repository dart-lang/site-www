---
title: Books about Dart
description: Read all about it! Here's a collection of books about Dart.
---

Here's a collection of books about the Dart language.
Many [Flutter books](https://flutter.dev/docs/resources/books)
also cover Dart.
If you find another Dart book that might be helpful, please
[let us know.](https://github.com/dart-lang/site-www/issues)

{{site.alert.warning}}
  You may find other books published on the Dart programming 
  language. We recommend that you check the date of publication, since 
  Dart has evolved a great deal, and older books lack coverage of many 
  important topics that are relevant to the modern Dart 2 language, 
  including strong typing, null safety, FFI, the `dart` command line
  utility, and our new developer tools. 
{{site.alert.end}}

## Dart books with null safety

{% for book in site.data.books-dart-null-safe %}

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

## Dart 2 books preceding null safety

The following books cover [Dart 2](/dart-2), but not [null safety](/null-safety):

{% for book in site.data.books-dart2 %}

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
