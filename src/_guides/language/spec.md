---
layout: default
title: "Dart Language Specification"
description: "The Dart language specification and proposed changes."
toc: false
---

Download the _Dart Programming Language Specification_ from
the Ecma website:

* <a href="http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-408.pdf"
   target="_blank">Dart Programming Language Specification, 3<sup>rd</sup> Edition</a>

For a gentler introduction to the Dart language, see the
[Dart language tour](/guides/language/language-tour).

You can find previous editions of the specification at
[Standard ECMA-408](http://www.ecma-international.org/publications/standards/Ecma-408-arch.htm).

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

{% comment %}
In the following documents,
<span style="background:yellow">yellow highlights</span>
mark proposed changes to the Dart language specification.
Non-normative text is in
<span style="color:blue; font-style:italic">blue italics</span> (for rationale)
or <span style="color:green">green</span> (for commentary).

* <a href="Asyncdraft-TC52.pdf"
     target="_blank">Async Await</a>
* <a href="EnumsTC52draft.pdf"
     target="_blank">Enums</a>
{% endcomment %}

## Proposed enhancements to the Dart language

Interested in learning about new features that may be added to Dart?

You can track all Dart Enhancement Proposals (DEPs) in the
[dart_enhancement_proposals](https://github.com/dart-lang/dart_enhancement_proposals)
repo on GitHub.
