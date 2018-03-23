---
layout: default
permalink: /faq
title: Frequently Asked Questions (FAQ)
description: You have questions about Dart, we have answers.
---

_Updated August 2017_

This page collects some of the top questions we've heard from the community
since Dart was open sourced. For other questions and answers, see:

* [tools FAQ](/tools/faq)
* [performance FAQ](/performance)
* [webdev FAQ]({{site.webdev}}/faq)
* [Flutter FAQ]({{site.flutter}}/faq/)

## General

### Q. Is Dart under the control of a standards body?

Yes. As of December 2013, [Ecma TC52][tc52] has been put in charge to own,
evolve, and publish the [standard specification][spec] of the Dart language.
In addition to TC52, we have also introduced a process for submitting
Dart enhancement proposals ([DEP][DEP]), because we wanted to make it easier
to contribute to and follow the evolution of Dart.

### Q. How are you taking input on changes to the Dart repository?

We listen to feedback and issues, and we review patches from contributors.
A contributor with a good track record can become a committer to the repository.
Google engineers will also be working in the public repository, making visible
changes. The project is lucky to have received many external patches and has
welcomed distributed committers.

### Q. Why didn't Google make Dart an open standard right from the start?

We're taking the usual route to get to an open-standard programming language:
someone creates a coherent first version, people experiment with it, and we
standardize later.  The open standard web platform has been known to add other
pieces this way, where standardization follows after a vendor experiment:
canvas, for example.  We understand that this route raises concerns, but we
think it is sometimes useful, and in particular that it is useful for
programming languages, where design by committee is risky.

The most recent successful language designed by an open committee was Haskell,
starting in 1990.  The most widely used was COBOL, followed by Ada.  It's not a
common way to do language design.  Among dozens and dozens of major languages,
six (give or take a couple of debatables) were designed this way.  (And one of
those six was ALGOL-68.)

### Q. Why didn't Google build a bytecode VM targetable by multiple languages including Dart?

Each approach has advantages and disadvantages, but we feel that in the
context of Dart it made sense to build a language-specific VM for the following
reasons:

* Google already works on a multi-language bytecode:
[LLVM bitcode in PNaCl][pnacl].

* Even if a bytecode VM is specialized for Dart, a language VM will be simpler
and faster because it can work under stronger assumptions&mdash;for instance,
a structured control flow.  These assumptions make the implementation cleaner
and optimizations easier.

* A general-purpose bytecode VM would be even larger and slower, as it
generalizes assumptions and adds functionality that for Dart is dead code:
for example, multithreading with a shared heap.

* No bytecode VM is truly general-purpose; they all make assumptions that
privilege some class of languages.  A language VM leaves more room to improve
the VM and make deep changes to optimization of the language.

## Language

### Q. Isn't Dart a lot like Java?

Dart has some similarities with Java. See the [Intro to Dart for Java
Developers](https://codelabs.developers.google.com/codelabs/from-java-to-dart/)
codelab for examples of some of the differences between Dart and Java.

### Q. How does Dart relate to Go?

Dart and Go are both language projects started at Google, but they
are independent and have different goals. As a result,
they make different choices, and the languages have very different
natures, even while we all try to learn from each others' work.

### Q. Why isn't Dart more like Haskell / Smalltalk / Python / Scala / other language?

Various reasons, depending on the language being asked about.

For languages that are quite different from JavaScript: it's important for Dart
to compile to efficient JavaScript.  Our experience in GWT is that if the source
language is too different from JavaScript, it creates some cases where complex
output code is needed to emulate the source language's behavior. This can cause
performance to vary in ways that are not transparent to the programmer.

For languages that are less mainstream: we expect that modeling Dart on these
would, on the whole, hurt our adoption.  Our team includes fans of these
languages, and if we thought Dart could take up our favorite cool language
features and push them to widespread adoption we might be tempted, but really we
think we've got our hands full introducing a new language at all.

For languages that are "more dynamic" than Dart: Dart deliberately trades off
some of this arbitrary runtime modification for the goal of better performance
and tools.

### Q. Why isn't Dart syntax more exciting?

We did throw in some nice syntactic features such as `this.` constructor args
and `=>` for one-line functions, but we'd agree that Dart chooses
familiarity over excitement. One team member's personal testimonial:
"I wish it had a little more razzle dazzle but I can't deny that
literally on my first day of writing Dart code, I was productive in it."

### Q. Does Dart have reflection capabilities?

For servers and command-line scripts, we have reflection support from
the <a href="/articles/libraries/reflection-with-mirrors">mirrors API</a>.
We don't recommend using mirrors for web apps. The Flutter SDK [does not
support mirrors.](https://flutter.io/faq/#does-flutter-come-with-a-reflectionmirrors-system)

### Q. Can Dart add tuples, pattern matching, non-nullable types, partial evaluation, optional semicolons, ...?

Future releases might be able to include your feature,
although we can't include everything.
Some features don't fit the basic nature of the language,
and some don't play well with other features. Simplicity is
the single most important gift we all can give to future programmers.

Please look at the [list of language issues][issues] to see if your request is
already there, and add a new issue if not.  Make a thoughtful argument for your
feature.  Sample code with and without your feature is good evidence; a sizeable
codebase that shows the need is even better evidence.

Don't be surprised if the Dart designers say "no" by default.
It's far more painful to remove a language feature than to add it, so
Dart is likely to add the most obvious features first, and then revisit the next
tier later.  And there simply are more possible language features in the world
that can fit into any single language without making a total hash of it.   But
we do very much appreciate suggestions and evidence.  We hope you'll see our
appreciation through careful design choices and fair communication about them.

## Types

### Q. Is Dart a statically typed language?

Yes, as of Dart 2.
For more information, see [Dart's Type System].

Dart 1.x is statically typed if you opt in to [strong mode]
and use a compiler (such as the Dart development compiler,
[dartdevc]({{site.webdev}}/tools/dartdevc)),
that has static and runtime checks. With both types of checks,
Dart has a sound type system, which guarantees that an expression of one
type cannot produce a value of another type. (So, no surprises!)

Even with type-safe Dart, you can annotate any variable with
`dynamic` if you need the flexibility of a dynamic language.
The `dynamic` type itself is static, but can contain any type at runtime.
Of course, that removes many of the benefits of a type-safe language
for that variable.

### Q. What is strong mode?

Strong mode is a Dart 1.x feature
that contributed to Dart’s implementation of a sound type system.
With strong mode enabled (in an implementation that has both the
static and runtime checks), Dart 1.x is a statically typed language ensuring
that static type annotations are actually correct at runtime.
For more information, see [Dart's Type System][].


### Q. Why are generics covariant?

Covariant generics fit a common intuition that programmers have, and very often
this intuition is correct, such as in the common "read-only" use of a generic.
Although this intuition isn't always correct, Dart doesn't need it to be.  Dart
has already chosen optimistic static checking, so why not continue down that
path and allow covariant uses of generics to pass static type checking?

Where covariant generics are too optimistic, Dart's type-safe execution allows
the static warnings to be optimistic without being dangerous.  Although
covariance can be pessimistic too, we think it will be rare that people run into
that, and and there's a simple workaround for any pessimism.

We are familiar with a variety of ways that languages try to mark or infer
variance.  We don't think any of them are suitable for Dart, where we want type
annotations to be optional and unobtrusive: it wouldn't fit to _require_
marking, and we feel that variance inference systems add too much complexity for
their benefit in Dart.

Again, we're trying to be pragmatic, and we think the outcome is reasonable.

## Usage and tools

### Q. Does Dart support JSON?

Yes.  See the [JSON] converters in the dart:convert library.

### Q. Can Dart run on the server?

Yes. See [Dart on the Server] for details.

### Q. How do I use third party code, or share code?

You can find many packages on [pub.dartlang.org,][pub] a service for hosting
packages of Dart code. Use the `pub` command to package your code and upload
to pub.dartlang.org.

### Q. Do I need to use a particular editor or IDE to write Dart code?

Nope.
You can try out Dart code with [DartPad],
and then use your favorite editor or IDE for real development.
Some full-featured IDEs such as IntelliJ IDEA
and WebStorm have Dart plugins.
Dart plugins also exist for Sublime, VIM, Emacs, and other editors.
For more information, see [Dart Tools].

### Q. Can I build an Android app with Dart?

Yes! You can build an Android app that also works on iOS from a single codebase
using [Flutter.][Flutter]

### Q. What are some real-world production deployments of Dart?

Google AdWords, AdSense, and AdMob all use Dart.
More than 75% of Google's revenue flows through these apps.
See [Who Uses Dart] for a more complete list.

[dartisnotjava]: http://programming.oreilly.com/2013/05/dart-is-not-the-language-you-think-it-is.html
[pnacl]: https://developer.chrome.com/native-client/overview
[issues]: https://github.com/dart-lang/sdk/issues?q=is%3Aopen+is%3Aissue+label%3Aarea-language
[pub]: https://pub.dartlang.org
[announcement]: http://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html
[lang]: /guides/language/language-tour
[libs]: /guides/libraries/library-tour
[JSON]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/JsonCodec-class.html
[tc52]: http://news.dartlang.org/2013/12/ecma-forms-tc52-for-dart-standardization.html
[Dart on the Server]: https://dart-lang.github.io/server/
[Dart Tools]: /tools/
[Dart and Google Cloud Platform]: https://dart-lang.github.io/server/google-cloud-platform/
[Who Uses Dart]: /community/who-uses-dart.html
[spec]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[DEP]: https://github.com/dart-lang/dart_enhancement_proposals
[DartPad]: {{site.custom.dartpad.direct-link}}
[Flutter]: {{site.flutter}}
[DDC]: https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler#dev_compiler
[strong mode]: /guides/language/sound-dart
[Dart's Type System]: /guides/language/sound-dart
