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

## Subclass

A _subclass_ is a class that inherits from another class using the 
[`extends`](/language/extend) keyword.

```dart
class A extends B {} // A is a subclass of B; B is the superclass of A. 
```

Any subclass relation is also a [subtype](#subtype) relation,
so you can use "subtype" to describe any subclass in Dart. 
However, the inverse is not true. Not all subtypes are subclasses.
See the [subtype](#subtype) entry for more information.

## Subtype

A _subtype_ is a class that implements another class
([`implements`](/language/classes#implicit-interfaces)),
or inherits from another class ([`extends`](/language/extend)).

```dart
class A implements B {} // A is a subtype of B, but NOT a subclass of B.

class C extends D {} // C is a subtype AND a subclass of D.
```

Everything in Dart is an object, so _subtype_ is also used to describe
[variable types in any context](/language/built-in-types),
not only explicitly declared class relationships.
