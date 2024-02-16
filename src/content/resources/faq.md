---
title: Dart FAQ
short-title: FAQ
description: You have questions about Dart, we have answers.
---

{% assign pdf = '<i style="vertical-align: text-top" class="material-symbols">picture_as_pdf</i>' %}
{% assign site-repo = site.repo.this %}
{% assign sdk-repo = site.repo.dart.sdk %}
{% assign lang-repo = site.repo.dart.lang %}
{% assign ecma-pdf = 'https://ecma-international.org/wp-content/uploads' %}

This page collects some of the top questions from the community.

## General

### Q. Is there a specification for Dart?

Yes. [EMCA-408][emca408] covers the Dart Programming Language Specification.

Five versions have been published.
The latest in-progress version covers to Dart 2.13-dev.

| Edition               | Published         | Approved      | Covers to version |
|-----------------------|-------------------|---------------|-------------------|
| [6th][6th-ed] {{pdf}} | January 24, 2024  |               | 2.13-dev          |
| [5th][5th-ed] {{pdf}} | April 9, 2021     |               | 2.10              |
| [4th][4th-ed] {{pdf}} | August 19, 2015   | December 2015 | 1.11              |
| [3rd][3rd-ed] {{pdf}} | April 15, 2015    | June 2015     | 1.9               |
| [2nd][2nd-ed] {{pdf}} | November 21, 2014 | December 2014 | 1.6               |
| [1st][1st-ed] {{pdf}} | March 27, 2014    | June 2014     | 1.3               |

{:.table .table-striped}

To learn more about the specification,
review the [Dart language specification](/guides/language/spec) page.

### Q. How are you taking input on changes to Dart?

The team listens to feedback, reads [issues][SDK issues],
and reviews patches from contributors.
A contributor with a good track record can be granted
write permission to the repository.
Google engineers also work in the public repository, making visible changes.
The project has received many external patches
and welcomes distributed committers.

[emca408]: https://ecma-international.org/publications-and-standards/standards/ecma-408/
[1st-ed]: {{ecma-pdf}}/ECMA-408_1st_edition_june_2014.pdf
[2nd-ed]: {{ecma-pdf}}/ECMA-408_2nd_edition_december_2014.pdf
[3rd-ed]: {{ecma-pdf}}/ECMA-408_3rd_edition_june_2015.pdf
[4th-ed]: {{ecma-pdf}}/ECMA-408_4th_edition_december_2015.pdf
[5th-ed]: https://dart.dev/guides/language/specifications/DartLangSpec-v2.10.pdf
[6th-ed]: https://spec.dart.dev/DartLangSpecDraft.pdf

---

## Language

### Q. Isn't Dart a lot like Java?

Dart has some similarities with Java.
To review brief examples with familiar syntax,
reviewed the code samples in the [Introduction to Dart](/language).

### Q. How does Dart relate to Go?

Google started the Dart and Go language projects.
These independent projects have different goals.
As a result, they make different choices.
The languages have very different natures,
but team members learn from each others' work.

### Q. Why isn't Dart more like Haskell / Smalltalk / Python / Scala / other language?

Various reasons that depend on the comparison language.

**Languages differ from JavaScript**
: Dart must compile to efficient JavaScript.
Source languages that differ too much from JavaScript can generate complex
output code to emulate the source language's behavior.
This can cause performance to vary in non-obvious ways to the programmer.

**Languages that compile to native code**
: Dart prioritizes efficient compliation to machine code.
  Therefore, it shares some aspects with other compiled languages.

**Languages that are considered "more dynamic" than Dart**
: Dart chooses to trade off some of this arbitrary runtime modification
  to achieve better performance and more productive tools.

### Q. Why isn't Dart syntax more exciting?

Some nice syntactic features exist, like the `this.` constructor args and `=>`
for one-line functions.
Dart chooses _familiarity_ over _excitement_.

### Q. Does Dart have reflection capabilities?

**Servers and command-line scripts**
: Yes, Dart supports reflection from the [mirrors API][dart-mirror].

**Web or Flutter apps**
: No, Dart doesn't support write to [web or Flutter apps][Flutter no mirrors].

### Q. Can Dart add tuples, partial evaluation, ...?

Future releases might include a feature you want.
Some features don't fit the nature of the language.
Some don't play well with other features.
Simplicity is the most important gift to give to future programmers.

To check if someone has filed your request,
review the [language funnel][lang-funnel] and
[language issues list][lang-issues].

* If an issue exists, add your thumbs up.
* If an issue doesn't exist, request a [new issue][new-issue].

  Make a thoughtful argument for your feature.
  Add evidence to your argument. Include sample code with and without your
  feature or a sizeable codebase.

To learn more, consult the [language evolution process][lang-process].

Don't be surprised if the Dart language team turns down your request.
Removing a language feature inflicts more pain than adding one.
The Dart language team adds the most obvious features first,
and revisits the next tier later.

The community will request more features than any single language
can meet without making a total hash of it.
The Dart language team does appreciate suggestions and evidence.
This appreciation should become apparent through careful design choices
and fair communication about them.

---

## Typing

### Q. Does Dart use static typing?

Yes, Dart uses static typing. To learn more, consult [Dart's type system][].

Combining static and runtime checks, Dart has a sound type system.
This guarantees that an expression of one type cannot produce a value
of another type.

if you need the flexibility of a dynamic typing,
you can annotate any variable with `dynamic`.
This `dynamic` type is static, but can contain any type at _runtime_.
That removes many benefits of a type-safe language from that variable.

### Q. Why are generics covariant?

Covariant generics fit a common intuition that programmers have, and very often
this intuition is correct, such as in the common "read-only" use of a generic.
Although this intuition isn't always correct, Dart is erring on the side of
convenience by having covariant generics.

The only other reasonable default variance would be invariance. While having
only invariant generics would definitely prevent more errors, it would also
prevent a lot of valid programs or require conversion every time you have a list
of "apples", and someone just wants "fruits".

We are familiar with a variety of ways that languages try to mark or infer
variance. We feel that variance inference systems add too much complexity for
their benefit in Dart.

Again, we're trying to be pragmatic, and we think the outcome is reasonable.

---

## Usage and tools

### Q. Does Dart support JSON?

Yes. To learn more, consult the [JSON] converters in the [dart:convert][] library.

### Q. Can Dart run on the server?

Yes. To learn more, consult [Dart on the Server].

### Q. How do I use third party code, or share code?

Search for packages on the [pub.dev site][pub],
the package-hosting service for Dart and Flutter.
Use the [`pub` command][pub-cmd] to package your code and upload to the site.

### Q. Do I need to use a particular editor or IDE to write Dart code?

No. You can try out Dart code with [DartPad,][DartPad] and then use your favorite
editor or IDE for development. Some full-featured IDEs such as IntelliJ IDEA,
WebStorm, and Visual Studio Code have Dart plugins. Open source Dart plugins
also exist for a number of editors. For more information, see the [Dart tools][].

### Q. Can I build an Android app with Dart?

Yes! You can build an Android app using the [Flutter][Flutter] framework
and the Dart language.
Any Flutter app you write will also work on iOS, the web, and desktop platforms.

### Q. What are some real-world production deployments of Dart?

Google Ads, AdSense, AdMob, and the Google Assistant use Dart.
A significant portion of Google's revenue flows through these apps.
Inside or outside of Google, [every Flutter app][FlutterShowcase] uses Dart.

[dart:convert]: {{site.dart-api}}/stable/dart-convert/dart-convert-library.html
[SDK issues]: {{sdk-repo}}/issues
[lang-issues]: {{lang-repo}}/issues
[lang-funnel]: {{lang-repo}}/projects/1
[lang-process]: {{lang-repo}}/blob/main/doc/life_of_a_language_feature.md
[pub]: {{site.pub}}
[announcement]: https://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html
[lang]: /language
[JSON]: {{site.dart-api}}/dart-convert/JsonCodec-class.html
[Dart on the Server]: /server
[Dart tools]: /tools/
[DartPad]: {{site.dartpad}}
[Flutter]: {{site.flutter}}
[Dart's type system]: /language/type-system
[Flutter no mirrors]: {{site.flutter-docs}}/resources/faq#does-flutter-come-with-a-reflection--mirrors-system
[FlutterShowcase]: {{site.flutter}}/showcase
[new-issue]: {{site-repo}}/issues/new/choose
[isolate]: {{site.dart-api}}/stable/dart-isolate/dart-isolate-library.html

---

## Native execution

### Q. Is Dart single-threaded?

No. On native targets,
[Dart's isolate API][isolate] can start multiple execution threads when needed.
The Dart VM uses multiple CPU cores to run those threads at the same time.

[Dart's concurrency architecture](/language/concurrency) abstracts the complex,
error-prone code of typical shared-memory threading.
This might explain the misconception that Dart is single-threaded.

Concurrency works differently in Dart web apps.
To learn more, consult
[Is Dart single-threaded on the web?](#q-is-dart-single-threaded-on-the-web)

### Q. Can I compile Dart code to native code?

Yes. When compiling apps that target devices like desktops or mobile,
[Dart Native](/overview#native-platform)
includes both a Dart VM with a just-in-time (JIT) compiler and an
ahead-of-time (AOT) compiler to produce native code.

The [Flutter][] framework uses Dart's native compilation capability to produce
fast native apps.

### Q. Can I compile a Dart program for running in a terminal?

Yes. Dart programs can be compiled to native code for running in a
macOS Terminal, Windows command prompt, or a Linux shell.

Consult the [dart compile][] documentation.

### Q. Which is faster: AOT- or JIT-compiled code?

It depends.
How Dart compiles code produces apps with different performance characteristics.

* AOT-compiled code starts fast with consistent runtime performance,
  with no latency during early runs.

* JIT-compiled code starts slower, but reaches peak performance after it runs
  long enough to apply runtime optimizations.

---

## Web execution

### Q. What browsers do you support as JavaScript compilation targets?

The _production_ web compiler supports the last two major releases of
the following browsers:

* Google Chrome
* Microsoft Edge
* Firefox
* Apple Safari

The [_development_ JavaScript compiler](/tools/webdev#serve) only
supports Chrome for debugging.

### Q. Is Dart single-threaded on the web?

Somewhat.
Dart web apps can't use isolates.
To achieve code concurrency, web apps use [web workers][].
Web workers lack the ease and efficiency of isolates,
and have different capabilities and restrictions.
To learn more, consult
[Concurrency on the web](/language/concurrency#concurrency-on-the-web).

[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers

### Q. Will any valid Dart code compile to JavaScript?

Any valid Dart code should compile to JavaScript.
Some libraries run only on the server or in Flutter.
Consider the `dart:io` library.
It provides access to operating system files
and directories with APIs not available to the browser.

### Q. Why does Dart have two ways to compile to JavaScript?

Both ways use the `webdev` command.
The `webdev build` command produces minified JavaScript optimized for
production.
The `webdev serve` command produces modulized JavaScript optimized for
debugging.

To learn more,
consult the [Dart JavaScript compiler reference](/tools/dart-compile#js)

### Q. How are floating point numbers handled when compiled to JavaScript?

JavaScript has only one number representation: an IEEE-754 double-precision
floating-point number. This means that any number—integer or floating
point—is represented as a double. JavaScript has typed data arrays,
and the mapping from native Dart typed lists to JavaScript typed arrays is trivial.

### Q. How does Dart handle integers when compiling to JavaScript?

JavaScript stores all [numbers as doubles][number-js].
This limits integers to 53-bit precision
with values ranging from -2<sup>53</sup> to 2<sup>53</sup>
JavaScript can store integers in this range without loss of accuracy.
As JavaScript VMs manipulates the internal representation of numbers,
stay within the small integer (SMI) range.
In JavaScript, that range falls between -2<sup>31</sup> to 2<sup>31</sup>
(-2,147,483,647 to 2,147,483,648 including 0).

### Q. How are typed lists handled when compiled to JavaScript?

JavaScript offers 32-bit typed arrays compatible with Dart's typed lists.
This maps as `Float32List` becoming a `Float32Array`.
The production JavaScript compiler doesn't support 64-bit integers:
`Int64List` or `Uint64List`. Compiling Dart code with
either of those lists results in a runtime exception.

[number-js]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures#number_type
[ppwsize]: https://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[package:js]: {{site.pub-pkg}}/js
[dart compile]: /tools/dart-compile
[dart analyze]: /tools/dart-analyze
[webdev]: /tools/webdev

[dart-mirror]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-mirrors
[pub-cmd]: https://dart.dev/tools/pub/cmd
