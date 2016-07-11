---
layout: default
permalink: /faq
title: Frequently Asked Questions (FAQ)
description: You have questions about Dart, we have answers.
---

_Updated April 2015_

This page collects some of the top questions we've heard from the community
since Dart was open sourced. For other questions and answers, see:

* [tools FAQ](/tools/faq)
* [performance FAQ](/performance)
* [webdev FAQ]({{site.webdev}}/faq)
* [Flutter FAQ]({{site.flutter}}/faq/)
* [Dartino FAQ](https://github.com/dartino/www.dartino.org/blob/master/faq.md#faq)

## General

### Q. Is Dart under the control of a standards body?

Yes. As of December 2013, [Ecma TC52][tc52] has been put in charge to own,
evolve, and publish the [standard specification][spec] of the Dart language.
In addition to TC52, we have also introduced a process for submitting
Dart enhancement proposals ([DEP][DEP]), because we wanted to make it easier
to contribute to and follow the evolvement of Dart.

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
the VM and make deep changes to optimization of the language. Some Dart
engineers wrote [an article][whynotbytecode] talking
about the VM question in more detail.

## Language

### Q. Isn't Dart a lot like Java?

Well, Java is statically typed, and Dart is dynamically typed.  Dart has
optional static type annotations, where in Java they are required.  To us these
are big differences in the nature of the two languages.  But Dart is a
curly-brace language, and it shares some keywords with Java, such as
`extends` and `final`, so we can see why people make the
comparison.  Honestly, we like having a straightforward and familiar syntax
that's easy to pick up, even if that means it's less exciting.

A few of the many other [examples of how Dart differs from Java][dartisnotjava]
include:

* The JVM is a bytecode VM, requiring source to be compiled first. The Dart VM
runs source code.

* The Dart language supports collection literals for a terse way to create
lists and maps.

* Java supports public, protected, package protected, and private. Dart supports
public and library-private.

* Dart is purely object oriented. Java has objects and primitives.

* The Dart language has mixins, optional static types, named parameters, and
more.

### Q. How does Dart relate to Go?

Dart and Go are both language projects started at Google, but they are
independent and have different goals.  As a result, they make different choices,
and the languages have very different natures, even while we all try to learn
from each others' work.

### Q. Why isn't Dart more like Haskell / Smalltalk / Python / Scala / other language?

Various reasons, depending on the language being asked about.

For languages that are quite different from JavaScript: it's important for Dart
to compile to efficient JavaScript.  Our experience in GWT is that if the source
language is too different from JavaScript, it creates some cases where complex
output code is needed to emulate the source language's behavior.  This can cause
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

We did throw in some nice syntactic features such as `this.`
constructor args and `=>` for one-line functions,
but we'd agree that Dart chooses familiarity over excitement.
One team member's personal testimonial: "I wish it had a little more razzle
dazzle but I can't deny that literally on my first day of writing Dart code, I
was productive in it."

### Q. Is it really a dynamic language if it doesn't have eval() or adding fields to a value at run time?

Dart as initially released didn't have anything like these, but future versions
of Dart may look at adding dynamic features of this sort.  The feature set
won't match up exactly with the features in your question, but we hope to serve
very much the same purposes.  When we see what gets added, then everyone can
decide how they classify the language.

What's important to us is that what you want to do with a dynamic language, you
can do with Dart and not feel cramped.  You should be able to design your system
without interference from static rules, and to modify the live system during
development and sometimes at run time.

So, for example, Dart isn't likely to support evaluating a string as code in the
current context, but it may support loading that code dynamically into a new
isolate.  Dart isn't likely to support adding fields to a value, but it may
(through a mirror system) support adding fields to a class, and you can
effectively add methods using `noSuchMethod()`.  Using these features
will have a runtime cost; it's important to us to minimize the cost for programs
that don't use them.

This area is still under development, so we welcome your thoughts on what you
need from runtime dynamism.

### Q. Does Dart have reflection capabilities?

We have reflection support from
the <a href="/articles/libraries/reflection-with-mirrors">mirrors API</a>.

### Q. Can Dart add tuples, pattern matching, non-nullable types, partial evaluation, optional semicolons, ...?

The language is now at 1.0, but we anticipate further language evolution
to occur in a standards group.  It might be able to include your feature,
although it can't include everything.  Some features don't fit the basic nature
of the language, and some don't play well with other features.  Simplicity is
the single most important gift we all can give to future programmers.

Please look at the [list of Dart issues][issues] to see if your request is
already there, and add a new issue if not.  Make a thoughtful argument for your
feature.  Sample code with and without your feature is good evidence; a sizeable
codebase that shows the need is even better evidence.

Please don't be surprised if the Dart designers say "no" by default, especially
for now.  It's far more painful to remove a language feature than to add it, so
Dart is likely to add the most obvious features first, and then revisit the next
tier later.  And there simply are more possible language features in the world
that can fit into any single language without making a total hash of it.   But
we do very much appreciate suggestions and evidence.  We hope you'll see our
appreciation through careful design choices and fair communication about them.

## Types

### Q. Does Dart have type inference?

Type inferencing is not something specified by the language specification, but
it is something that implementations are free to do. It's important to remember
that Dart has a dynamic type system, so type inferencing doesn't play the same
role as it does in languages such as Haskell. However, IDEs might do some
type inferencing, such as when you use var for local variables.

### Q. Why are type annotations optional?

We want to maintain the feel of a dynamically typed language, which is familiar
to web developers. Mandatory types don't fit with that goal. Experience
has also shown that full statically typed languages are sometimes too rigid,
and we wanted Dart development to be more flexible for a wide range of
developers.

### Q. Why is the type system designed to be unsound?

Rather than using a full, static type system, Dart has a dynamic type system
with optional static type annotations. Our main goals for the types are to
support tooling and documentation. We want to build a pragmatic tool that helps
web programmers without getting in their way.  In particular, we want our static
warnings to be optimistic rather than to complain about dynamically typed code
that may be valid and correctly written, such as "downcast" assignments.
Because Dart _execution_ is always type-safe, we can let some unsound cases
get through the static warnings and be caught at run time instead.

Typical object-oriented languages let you downcast, which also introduces
unsoundness into the type system and may result in a runtime type error.  In
Dart, we choose to allow downcasts without a syntax to mark them.

### Q. But don't you need sound typing information to get high performance?

Sound types can help with performance but aren't essential. What we need are
uniform, simple semantics. Modern VMs can use actual runtime behavior as a
valuable signal for optimizations.

### Q. Why do type annotations have no effect on the runtime behavior?

If type annotations affect the runtime, programs will change their behavior as
programmers add type information, even though the logic remains unchanged. The
normal mode of development is to gradually add types for documentation and
validation, and if that changes what the program does, programmers have no
stable foundation to work on. This is especially true given that types could be
inaccurate.

In addition, this policy helps us and others add additional type-checking tools
that implement different policies without unforeseen interactions with the
runtime.

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

### Q. Is Dart stable?

Dart is, at the time of this writing, at version 1.0. The core language and
core libraries are considered stable for production use.

### Q. Does Dart support JSON?

Yes.  See the [JSON] converters in the dart:convert library.

### Q. Can Dart run on the server?

Yes. See [Dart on the Server] for details.

### Q. How do I use third party code, or share code?

You can find many packages on [pub.dartlang.org][pub], a service for hosting
packages of Dart code. Use the `pub` command to package your code and upload
to pub.dartlang.org.

### Q. Do I need to use a particular editor or IDE to write Dart code?

Nope.
You can try out Dart code with [DartPad],
and then use your favorite editor or IDE for real development.
Some full-featured IDEs such as IntelliJ IDEA
and WebStorm have Dart plugins.
Dart plugins also exist for Sublime, VIM, Emacs, and other editors.
We used to provide a Dart-specific editor called Dart Editor,
but as of 1.11 Dart Editor is no longer available.
For more information, see [Dart Tools].

### Q. Can I build an Android app with Dart?

Yes! You can build an Android app that also works on iOS from a single codebase
using [Flutter]({{site.flutter}}.

### Q. Can I use Dart on App Engine?

Yes! See
[Dart and Google Cloud Platform]
for details.

### Q. What CPU architectures does the Dart VM support?

The Dart VM works on IA-32, x64, MIPS, ARMv5TE, ARMv6, ARMv7, and
ARM64 processors.

### Q. What are some real-world production deployments of Dart?

The [Dart 1.0 announcement][announcement] lists a few, like
internal Google apps, external Google apps,
Mixbook, blossom.io, Soundtrap, Mandrill, and more.
Many more have been released or are in development.
See [Who Uses Dart] for more.

[dartisnotjava]: http://programming.oreilly.com/2013/05/dart-is-not-the-language-you-think-it-is.html
[pnacl]: https://developers.google.com/native-client/overview#distributing-an-application
[whynotbytecode]: /articles/dart-vm/why-not-bytecode
[issues]: https://github.com/dart-lang/sdk/issues/
[pub]: https://pub.dartlang.org
[announcement]: http://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html
[lang]: /guides/language/language-tour
[libs]: /guides/libraries/library-tour
[JSON]: {{site.dart_api}}/dart-convert/JsonCodec-class.html
[tc52]: http://news.dartlang.org/2013/12/ecma-forms-tc52-for-dart-standardization.html
[Dart on the Server]: https://dart-lang.github.io/server/
[Dart Tools]: /tools/
[Dart and Google Cloud Platform]: https://dart-lang.github.io/server/google-cloud-platform/
[Who Uses Dart]: /community/who-uses-dart.html
[spec]: http://www.ecma-international.org/publications/standards/Ecma-408.htm
[DEP]: https://github.com/dart-lang/dart_enhancement_proposals
[DartPad]: {{site.custom.dartpad.direct-link}}
