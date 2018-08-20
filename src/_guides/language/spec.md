---
layout: default
title: "Dart Language Specification"
description: "The Dart language specification and proposed changes."
---

Download the _Dart Programming Language Specification_ from
the Ecma website:

* <a href="http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-408.pdf"
   target="_blank">Dart Programming Language Specification, 4<sup>th</sup> Edition</a>

For a gentler introduction to the Dart language, see the
[Dart language tour](/guides/language/language-tour).

You can find previous editions of the specification at
[Standard ECMA-408](http://www.ecma-international.org/publications/standards/Ecma-408-arch.htm).


## Dart 2 changes

Dart 2 has changed the Dart language in many ways,
some of which are not backward-compatible.
For information about changes and implementation status,
see the following resources:

* [Dart 2 Updates](/dart-2)
* [Dart Language and Library Newsletters](https://github.com/dart-lang/sdk/tree/master/docs/newsletter#dart-language-and-library-newsletters)
* [Language specification source file (TeX format)](https://github.com/dart-lang/sdk/blob/master/docs/language/dartLangSpec.tex)
* [Informal specifications](https://github.com/dart-lang/sdk/tree/master/docs/language/informal)


## Changes in the 4<sup>th</sup> edition

The 4<sup>th</sup> edition of the specification has fewer restrictions on mixins.
The restrictions on mixins up until this edition were:

* Mixins must inherit directly from Object.
* Mixins cannot contain super calls.
* Mixins cannot define constructors.

Only the last one, mixins cannot define constructors, remains.

## Changes in the 3<sup>rd</sup> edition

The 3<sup>rd</sup> edition of the specification added information
about the following new language features:

* Null-aware operators

* [Generalized tear offs](https://github.com/gbracha/generalizedTearOffs/blob/master/proposal.md)

{% comment %}
Do we want to save this info on this page or delete it?

## Changes in the 2<sup>nd</sup> edition

The 2<sup>nd</sup> edition of the specification added information about
the following new language features:

* Enumerations (`enum`)<br>
  Implemented in 1.8. For details, see the language tour:
  [Enumerated types](/guides/language/language-tour#enums).

* Asynchrony support (`async`, `await`, and more)<br>
  Partially implemented in 1.8.
  For details, see the language tour:
  [Asynchrony support](/guides/language/language-tour#asynchrony).

* Deferred loading (`import ... deferred as`)<br>
  Implemented in 1.6. For details, see the language tour:
  [Lazily loading a library](/guides/language/language-tour#deferred-loading).
{% endcomment %}
