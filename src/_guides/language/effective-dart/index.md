---
layout: guide
title: "Effective Dart"
description: "Best practices for building consistent, maintainable, efficient Dart libraries."
permalink: /guides/language/effective-dart/
toc: false

nextpage:
  url: /guides/language/effective-dart/style
  title: "Style"
---

Over the past several years, we've written a ton of Dart code and learned a lot
about what works well and what doesn't. We're sharing this with you so you can
write consistent, robust, fast code too.

There are two over-arching themes to writing effective code:

 1. **Be consistent.** With things like formatting, and casing, arguments as to
    which is better tend to end up being mostly subjective and impossible to
    resolve. What we do know is that being *consistent* is objectively helpful.

    If two pieces of code look different it should be because they *are*
    different in some meaningful way. When a bit of code stands out and catches
    your eye, it should do so for a useful reason.

 2. **Be brief.** Dart was designed to be easy to adopt, so it inherits many of
    the same statements and expressions as C, Java, JavaScript and other
    languages. But we created Dart because there is a lot of room to improve on
    what those languages offer. We added a bunch of features, from string
    interpolation to initializing formals to help you express your intent more
    simply and easily.

    If there are multiple ways to say something, you should generally pick the
    most concise one. This is not to say you should [code golf][] yourself into
    cramming a whole program into a single line. The goal is code that is
    *economical*, not *dense*.

[code golf]: https://en.wikipedia.org/wiki/Code_golf

## The guides

We split the guidelines into a few separate pages for easy digestion:

  * **[Style Guide][]** &ndash; This defines the rules we use to format our
    code&mdash;the same rules [dartfmt] implements. It also specifies how
    identifiers are formatted: `camelCase`, `using_underscores`, etc.

  * **[Documentation Guide][]** &ndash; This tells you everything you need to
    know about what goes inside comments. Both doc comments and regular,
    run-of-the-mill code comments.

  * **[Usage Guide][]** &ndash; This teaches you how to make the best use of
    language features to implement behavior. If it's in a statement or
    expression, it's covered here.

  * **[Design Guide][]** &ndash; This is the softest guide, but the one
    with the widest scope. It covers what we've learned about designing
    consistent, usable APIs for libraries. If it's in a type signature or
    declaration, this goes over it.

[dartfmt]: https://github.com/dart-lang/dart_style#readme
[style guide]: /guides/language/effective-dart/style
[documentation guide]: /guides/language/effective-dart/documentation
[usage guide]: /guides/language/effective-dart/usage
[design guide]: /guides/language/effective-dart/design

## How to read the guides

Each guide is broken into a few sections. Sections contain a list of guidelines.
Each guideline starts with one of these words:

* **DO** guidelines describe practices that should always be followed. There
will almost never be a valid reason to stray from them.

* **DON'T** guidelines are the converse: things that are almost never a good
idea. Fortunately, we don't have many of these in Dart. Rules like these in
other languages help avoid problems caused by historical baggage. Dart is
new enough that we can just fix those problems directly instead of putting
up ropes around them.

* **PREFER** guidelines are practices that you *should* follow. However, there
may be circumstances where it makes sense to do otherwise. Just make sure
you understand the full implications of ignoring the guideline when you
do.

* **AVOID** guidelines are the dual to "prefer": stuff you shouldn't do but
where there may be good reasons to on rare occasions.

* **CONSIDER** guidelines are practices that you might or might not want to
follow, depending on circumstances, precedents, and your own preference.

This sounds like the police are going to beat down your door if you don't have
your laces tied correctly. Things aren't that bad. Most of the guidelines here
are common sense and we're all reasonable people. The goal, as always, is nice,
readable and maintainable code.

## Glossary

To keep the guidelines brief, we use a few shorthand terms to refer to different
Dart constructs.

* A **member** is any definition or declaration in a library. This includes
  top-level variables, getters, setters, and functions. It also includes
  instance and static members inside classes: fields, getters, setters, methods,
  and operators.

* A **variable** is any variable declaration, local or top-level. This also
  includes member parameters.

* A **type** is any named type declaration: a class, typedef, or enum.

* A **property** is a "field-like" named construct. This includes actual fields
  inside classes, as well as getters and setters. This also includes top level
  variables, getters, and setters.

<aside class="alert alert-info" markdown="1">
  **Have feedback on the guides?** <br>
  Please [file an issue][issue] or add to an [existing one][].

  [issue]: https://github.com/dart-lang/www.dartlang.org/issues/new
  [existing one]: https://github.com/dart-lang/www.dartlang.org/issues?q=is%3Aopen+is%3Aissue+label%3AEffectiveDart
</aside>
