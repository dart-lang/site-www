---
title: Dart FAQ
short-title: FAQ
description: You have questions about Dart, we have answers.
---

_Updated May 2018_

This page collects some of the top questions we've heard from the community
since Dart was open sourced. For other questions and answers, see:

* [Flutter FAQ]({{site.flutter}}/faq/)
* [Dart web development FAQ]({{site.webdev}}/faq)

## General

### Q. Is Dart an open standard?

Yes. [Ecma TC52][tc52] owns, evolves, and publishes the [standard
specification][spec] of the Dart language.  In addition, Google's Dart team
improves the Dart language by doing experiments and initial implementations. For
example, Dart 2 is the result of work by Google's Dart team, together with key
users, to improve the language. We expect to have an updated formal
specification available for Ecma TC52 in the coming quarters.

### Q. How are you taking input on changes to the Dart repository?

We listen to feedback and [issues][issues], and we review patches from contributors.
A contributor with a good track record can become a committer to the repository.
Google engineers will also be working in the public repository, making visible
changes. The project is lucky to have received many external patches and has
welcomed distributed committers.

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
would, on the whole, hurt adoption.  Our team includes fans of these
languages, and if we thought Dart could take up our favorite cool language
features and push them to widespread adoption we might be tempted, and with
Dart 2 we are increasingly in a situation where we’d like to take on work to
add additional awesome features while respecting the ‘spirit’ of Dart and
keeping breaking changes at an absolute minimum.

For languages that are "more dynamic" than Dart: Dart deliberately trades off
some of this arbitrary runtime modification for the goal of better performance
and more productive tools.

### Q. Why isn't Dart syntax more exciting?

We did throw in some nice syntactic features such as `this.` constructor args
and `=>` for one-line functions, but we'd agree that Dart chooses
familiarity over excitement. One team member's personal testimonial:
"I wish it had a little more razzle dazzle but I can't deny that
literally on my first day of writing Dart code, I was productive in it."

### Q. Does Dart have reflection capabilities?

For servers and command-line scripts, we have reflection support from
the <a href="/articles/libraries/reflection-with-mirrors">mirrors API</a>.
There is no support for mirrors when using Dart to write web or
Flutter apps ([more info][Flutter no mirrors]).

### Q. Can Dart add tuples, pattern matching, non-nullable types, partial evaluation, optional semicolons, ...?

Future releases might be able to include (some of) those features, although
we can't include everything. Some features don't fit the basic nature of the
language, and some don't play well with other features. Simplicity is the single
most important gift we can give to future programmers.

Please look at the [list of language issues][issues] to see if your request is
already there. If it is, let us know that you care and give it a thumbs up.
Otherwise, go ahead and add a new issue.  Make a thoughtful argument for your feature.
Sample code with and without your feature is good evidence; a sizeable codebase
that shows the need is even better evidence.

Don't be surprised if the Dart language team says "no" by default.
It's far more painful to remove a language feature than to add it, so
Dart is likely to add the most obvious features first, and then revisit the next
tier later.  And there simply are more possible language features in the world
that can fit into any single language without making a total hash of it.   But
we do very much appreciate suggestions and evidence.  We hope you'll see our
appreciation through careful design choices and fair communication about them.

## Types

### Q. Is Dart a statically typed language?

Yes, Dart 2 is statically typed. For more information, see [Dart's Type System].

With its combination of static and runtime checks, Dart has a sound type system,
which guarantees that an expression of one type cannot produce a value of
another type. No surprises!

Even with type-safe Dart, you can annotate any variable with
`dynamic` if you need the flexibility of a dynamic language.
The `dynamic` type itself is static, but can contain any type at runtime.
Of course, that removes many of the benefits of a type-safe language
for that variable.

### Q. Why are generics covariant?

Covariant generics fit a common intuition that programmers have, and very often
this intuition is correct, such as in the common "read-only" use of a generic.
Although this intuition isn't always correct, Dart is erring on the side of
convenience by having covariant generics.

The only other reasonable default variance would be invariance. While having
only invariant generics would definitely prevent more errors, it would also
prevent a lot of valid programs or require conversion every time you have a list
of “apples”, and someone just wants “fruits”.

We are familiar with a variety of ways that languages try to mark or infer
variance. We feel that variance inference systems add too much complexity for
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

Nope. You can try out Dart code with [DartPad], and then use your favorite
editor or IDE for development. Some full-featured IDEs such as IntelliJ IDEA,
WebStorm, and Visual Studio Code have Dart plugins. Open source Dart plugins
also exist for a number of editors. For more information, see [Dart Tools].

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
[Flutter no mirrors]: https://flutter.io/faq/#does-flutter-come-with-a-reflectionmirrors-system
