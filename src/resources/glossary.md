---
title: Glossary
description: A glossary reference for terminology used across dart.dev.
sitemap: false
---

The following are definitions of terms used across the Dart documentation.

## Irrefutable pattern

_Irrefutable patterns_ are patterns that always match. 
Irrefutable patterns are the only patterns that can appear in
_irrefutable contexts_: the _declaration_ and _assignment_ 
[pattern contexts][pattern context].

## Refutable pattern

A _refutable pattern_ is a pattern that can be tested against a value to
determine if the pattern matches the value. 
If not, the pattern _refutes_, or denies, the match.
Refutable patterns appear in [_matching contexts_][pattern context].


[pattern context]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/0546-patterns/feature-specification.md#pattern-context