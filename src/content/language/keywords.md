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
{% assign unr = '&nbsp;<sup>3</sup>' %}

The following table lists the words
that the Dart language reserves for its own use.
These words can't be used as identifiers unless otherwise noted.
Even when allowed, using keywords as identifiers can confuse other
developers reading your code and should be avoided.
To learn more about identifier usage, click on the term.

<table class="table table-striped">

{% tablerow keyword in keywords cols: 4 %}
<a href="{{keyword.link}}">{{keyword.term}}</a>
{%- case keyword.type %}
{% when 'bit' %}{{bii}}
{% when 'context' %}{{ckw}}
{% when 'unrestricted' %}{{unr}}
{% endcase %}
{% endtablerow %}
</table>

{{ckw}} This keyword can be used as an identifier
        depending on **context**.

{{bii}} This keyword can't be used as the name of a type
        (a class, a mixin, an enum, an extension type, or a type alias),
        the name of an extension, or as an import prefix.
        It can be used as an identifier in all other circumstances.

{{unr}} This keyword can be used as an identifier without restriction.
