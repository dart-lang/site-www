---
title: Keywords
description: Keywords in Dart.
toc: false
prevpage:
  url: /language/libraries
  title: Libraries
nextpage:
  url: /language/built-in-types
  title: Built-in types
---

{% assign ckw = '&nbsp;<sup>1</sup>' %}
{% assign bii = '&nbsp;<sup>2</sup>' %}

The following table lists the words
that the Dart language reserves for its own use.
Don't use these terms as identifiers unless the term notes an exception.
To learn more about identifier usage, click on the term.

<table class="table table-striped">

{% tablerow keyword in keywords cols: 4 %}
<a href="{{keyword.link}}">{{keyword.term}}</a>
{%- case keyword.type %}
{% when 'bit' %}{{bii}}
{% when 'context' %}{{ckw}}
{% endcase %}
{% endtablerow %}
</table>

{{ckw}} These keywords can be used as an identifier
        depending on **context**.

{{bii}} These keywords can't be used as class names, type names,
        or import prefixes. They can be used as identifiers in all other
        circumstances.
