---
title: Glossary
description: A glossary reference for terminology used across dart.dev.
sitemap: false
---

The following are definitions of terms used across the Dart documentation.

{% comment %}
[TODO: This page will soon house the glossary section of the diagnostics docs, and
any other terminology that would benefit from being defined site-wide]
{% endcomment %}

## Irrefutable pattern

_Irrefutable patterns_ are patterns that always match. 
Irrefutable patterns are the only patterns that can appear in
_irrefutable contexts_: the [_declaration_][] and [_assignment_][] 
pattern contexts.

[_declaration_]: /language/patterns#variable-declaration 
[_assignment_]: /language/patterns#variable-assignment

## Refutable pattern

A _refutable pattern_ is a pattern that can be tested against a value to
determine if the pattern matches the value. 
If not, the pattern _refutes_, or denies, the match.
Refutable patterns appear in [_matching contexts_][].

[_matching contexts_]: /language/patterns#matching
