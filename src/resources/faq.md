---
title: Dart FAQ
short-title: FAQ
description: You have questions about Dart, we have answers.
---

This page collects some of the top questions we've heard from the community
since Dart was open sourced.

## General

### Q. Is there a specification for Dart?

Yes. EMCA-408 covers the Dart Programming Language Specification.

Five versions have been published.
The latest in-progress version covers to Dart 2.13-dev.

| Edition       | Published         | Approved      | Covers to version |
|---------------|-------------------|---------------|-------------------|
| [6th][6th-ed] | January 24, 2024  |               | 2.13-dev          |
| [5th][5th-ed] | April 9, 2021     |               | 2.10              |
| [4th][4th-ed] | August 19, 2015   | December 2015 | 1.11              |
| [3rd][3rd-ed] | April 15, 2015    | June 2015     | 1.9               |
| [2nd][2nd-ed] | November 21, 2014 | December 2014 | 1.6               |
| [1st][1st-ed] | March 27, 2014    | June 2014     | 1.3               |

To learn more about the specification,
review the [Dart language specification](/guides/language/spec) page.

[1st-ed]: https://ecma-international.org/wp-content/uploads/ECMA-408_1st_edition_june_2014.pdf
[2nd-ed]: https://ecma-international.org/wp-content/uploads/ECMA-408_2nd_edition_december_2014.pdf
[3rd-ed]: https://ecma-international.org/wp-content/uploads/ECMA-408_3rd_edition_june_2015.pdf
[4th-ed]: https://ecma-international.org/wp-content/uploads/ECMA-408_4th_edition_december_2015.pdf
[5th-ed]: https://dart.dev/guides/language/specifications/DartLangSpec-v2.10.pdf
[6th-ed]: https://spec.dart.dev/DartLangSpecDraft.pdf

### Q. How are you taking input on changes to Dart?

The team listens to feedback, reads [issues][SDK issues],
and reviews patches from contributors.
A contributor with a good track record can be granted
write permission to the repository.
Google engineers also work in the public repository, making visible changes.
The project has received many external patches
and welcomes distributed committers.

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

Languages differ from JavaScript
  Dart must compile to efficient JavaScript.
  Source languages that differ too much from JavaScript can generate complex
  output code to emulate the source language's behavior.
  This can cause performance to vary in non-obvious ways to the programmer.

Languages that compile to native code
  Dart prioritizes efficient compliation to machine code.
  Therefore, it shares some aspects with other compiled languages.

Languages that are considered "more dynamic" than Dart
  Dart chooses to trade off some of this arbitrary runtime modification
  to achieve better performance and more productive tools.

### Q. Why isn't Dart syntax more exciting?

Some nice syntactic features exist, like the `this.` constructor args and `=>`
for one-line functions.
Dart chooses familiarity over excitement.

### Q. Does Dart have reflection capabilities?

Servers and command-line scripts
  Yes, Dart supports reflection from the [mirrors API][dart-mirror].
Web or Flutter apps
  No, Dart doesn't support write ([web or Flutter apps][Flutter no mirrors]).

### Q. Can Dart add tuples, pattern matching, ...?

Future releases might include some of those features.
Some features don't fit the nature of the language.
Some don't play well with other features.
Simplicity is the most important gift we can give to future programmers.

To check if your request has been filed,
review at the [language funnel][language funnel] and
[language issues list][language issues].
If it is, give it a thumbs up.
Otherwise, go ahead
and add a new request issue (see the [language evolution process][language process]
for details).
Make a thoughtful argument for your feature. Sample code with and
without your feature is good evidence; a sizeable codebase that shows the need
is even better evidence.

Don't be surprised if the Dart language team says "no" by default.
It's far more painful to remove a language feature than to add it, so
Dart is likely to add the most obvious features first, and then revisit the next
tier later. And there simply are more possible language features in the world
that can fit into any single language without making a total hash of it.  But
we do very much appreciate suggestions and evidence. We hope you'll see our
appreciation through careful design choices and fair communication about them.

---

## Types

### Q. Is Dart a statically typed language?

Yes, Dart uses static typing. To learn more, review [Dart's type system][].

With its combination of static and runtime checks, Dart has a sound type system.
This guarantees that an expression of one type cannot produce a value
of another type.

Even with type-safe Dart, you can annotate any variable with `dynamic` if you need the flexibility of a dynamic language.
The `dynamic` type itself is static, but can contain any type at runtime.
Of course, that removes many of the benefits of a type-safe language for that variable.

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

Yes. To learn more, review the [JSON] converters in the dart:convert library.

### Q. Can Dart run on the server?

Yes. To learn more, review [Dart on the Server].

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

[dartisnotjava]: http://programming.oreilly.com/2013/05/dart-is-not-the-language-you-think-it-is.html
[pnacl]: https://developer.chrome.com/native-client/overview
[SDK issues]: https://github.com/dart-lang/sdk/issues
[language issues]: https://github.com/dart-lang/language/issues
[language funnel]: https://github.com/dart-lang/language/projects/1
[language process]: https://github.com/dart-lang/language/blob/main/doc/life_of_a_language_feature.md
[pub]: {{site.pub}}
[announcement]: https://blog.chromium.org/2013/11/dart-10-stable-sdk-for-structured-web.html
[lang]: /language
[JSON]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/JsonCodec-class.html
[tc52]: {{site.news}}/2013/12/ecma-forms-tc52-for-dart-standardization.html
[Dart on the Server]: /server
[Dart tools]: /tools/
[Dart and Google Cloud Platform]: /server/google-cloud
[Who Uses Dart]: /community/who-uses-dart
[spec]: https://www.ecma-international.org/publications/standards/Ecma-408.htm
[DEP]: https://github.com/dart-lang/dart_enhancement_proposals
[DartPad]: {{site.dartpad}}
[Flutter]: {{site.flutter}}
[DDC]: https://github.com/dart-lang/sdk/tree/main/pkg/dev_compiler#dev_compiler
[strong mode]: /language/type-system
[Dart's type system]: /language/type-system
[Flutter no mirrors]: {{site.flutter-docs}}/resources/faq#does-flutter-come-with-a-reflection--mirrors-system
[FlutterShowcase]: {{site.flutter}}/showcase

---

## Native execution

### Q. Is Dart single-threaded?

No. On native targets, Dart's isolate API can 
enable multiple threads of execution at any given time.
The Dart VM uses multiple processor cores
to run those threads concurrently.

[Dart's concurrency architecture](/language/concurrency)
abstracts the complex, error-prone code of typical shared-memory threading,
which might explain the misconception that Dart is single-threaded.

Note that concurrency works differently in Dart web apps.
To learn more, see
[Is Dart single-threaded on the web?](#q-is-dart-single-threaded-on-the-web)

### Q. Can I compile Dart code to native code?

Yes. For programs targeting devices (mobile, desktop, server, and more), [Dart
Native](/overview#native-platform) includes both a Dart VM with JIT
(just-in-time) compilation and an AOT (ahead-of-time) compiler for producing
machine code.

[Flutter][] is a sample framework that uses Dart's native compilation capability
to produce fast native apps.

### Q. Can I compile a Dart program for running in a terminal?

Yes. Dart programs can be compiled to native x64 machine code for running in a
Terminal/Command Prompt on desktop operating systems such as Windows, macOS, and
Linux. For more details, see the [dart compile][] documentation.

### Q. Which is faster: AOT- or JIT-compiled code?

Code that's compiled ahead-of-time (_AOT_) with
a tool such as [dart compile][]
has different performance characteristics from
code that's compiled just-in-time (_JIT_) in the Dart VM.
AOT-compiled code is guaranteed to have fast startup and consistent runtime
performance, with no latency during early runs. JIT-compiled code is slower at
startup, but it can have better peak performance after it runs
long enough for runtime optimizations to be applied.

---

## Web: general

### Q. What browsers do you support as JavaScript compilation targets?

The _production_ web compiler supports the last two major releases of
the following browsers:

  * Chrome
  * Edge
  * Firefox
  * Safari

The [_development_ JavaScript compiler](/tools/webdev#serve) supports Chrome only.
You _might_ be able to use other modern browsers: Microsoft Edge, Mozilla Firefox, and Apple Safari).

### Q. Is Dart supported by my browser?

Although no production browsers can execute Dart code directly,
all modern browsers can execute Dart code that's been compiled to JavaScript.

### Q. How do I debug an app?

For setup details and a walkthrough, see [Debugging Dart Web Apps](/web/debugging).

### Q. What web frameworks can I use with Dart?

You can use the low-level HTML API that core libraries define like `dart:html`, or you can choose from many [web packages](/web/libraries#web-packages).
You can also use the [Flutter framework]({{site.flutter}}), which has [web support]({{site.flutter}}/web)

### Q. Will Chrome add the Dart VM?

[No.]({{site.news}}/2015/03/dart-for-entire-web.html)
Dart compiles to JavaScript to run across the modern web.

### Q. Is Dart single-threaded on the web?

Dart is _mostly_ single-threaded on the web,
since web apps cannot use isolates.
To run code concurrently, web apps use [web workers][] instead.
Web workers lack the ease and efficiency of isolates,
and have different capabilities and restrictions.
To learn more, see
[Concurrency on the web](/language/concurrency#concurrency-on-the-web).

[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers

---

## Web: JavaScript and other technologies

### Q. How does Dart code interoperate with JavaScript libraries?

Dart and JavaScript exist as separate languages with separate VMs,
though they can interoperate. To learn more, review
[JavaScript and TypeScript interop](/interop/js-interop).

### Q. How can I migrate my JavaScript codebase to Dart?

Migrate one major feature at a time.
Use the [JavaScript interoperability library][package:js] when necessary.

### Q. How does Dart compare with using the Closure compiler on JavaScript?

Optional type annotations work in a similar way.
Dart's syntax reads better.

Compare the following Closure compiler code:

```js
// Closure compiler code

/**
 * @param {String} name
 * @return {String}
 */
makeGreeting = function(name) {
  /** @type {String} */
  var greeting = 'Hello ' + name;
  return greeting;
}
```

With the following Dart code:

<?code-excerpt "misc/test/faq.dart (make-greeting)"?>
```dart
// Dart code

String makeGreeting(String name) {
  var greeting = 'Hello $name';
  return greeting;
}
```

### Q. How does Dart compare with CoffeeScript?

JavaScript inspired both Dart and CoffeeScript and both translate to JavaScript.
They make different choices in the flavor of their syntax.
As a language,
Dart's semantics differ from JavaScript more than CoffeeScript's do.
This might result in a less line-for-line translation.
Dart-generated JavaScript can have excellent size and speed.

Dart introduces new semantics, while CoffeeScript retains the semantics
of JavaScript.

If you like CoffeeScript for its more structured feel than raw JavaScript,
you may like Dart's static type annotations.

### Q. What does Google think of TypeScript?

TypeScript and Dart have similar goals; they make building large-scale web
apps easier. However, their approaches are fairly different. TypeScript
maintains backwards compatability with JavaScript, whereas Dart purposely made a
break from certain parts of JavaScript's syntax and semantics in order to
eradicate large classes of bugs and to improve performance. The web has suffered
from too little choice for too long, and we think that both Dart and TypeScript
are pointing to a brighter future for web developers. You can read a
[more complete response][typescript] on our blog.

### Q. I have a large app written in GWT. How do I port it to Dart?

Java and Dart are syntactically similar,
so this might be easier than you think.
You can rely on the [Dart analyzer][dart analyze]
to flag any syntax problems. Alternatively, you may
consider porting one feature at a time to Dart and using the
[JavaScript interoperability library][package:js] as the common middle
ground. Be sure to watch [Dart-JavaScript
interoperability,](https://www.youtube.com/watch?v=aIonwL-8hdE)
a talk from Dart Developer Summit 2016.

---

## Web: JavaScript compilation

### Q. Will any valid Dart code compile to JavaScript, or are there limitations?

We intend for any valid Dart code to compile to JavaScript. Of course,
some libraries only run on the server or in Flutter.
For example, the `dart:io` library
provides access to operating system files and directories with APIs not
available to the browser.

### Q. Why does Dart have two ways to compile to JavaScript?

Each developer journey has different requirements. How Dart generates
JavaScript code depends on what you need to do. You should not need to
worry about which compiler you use. The [`webdev`][webdev] tool chooses the
right compiler for your use case. 

* When you're developing your app, `webdev` uses Dart's development
  compiler. This compiler creates modular JavaScript code and supports
  incremental compilation. This allows you to see the results of your
  edits quickly.
* When you're deploying your app, `webdev` chooses the production web
  compiler (which work the same as `dart compile js`). This compiler 
  uses techniques such as tree shaking to produce optimized code.

### Q. How can `dart compile js` produce JavaScript that runs faster than handwritten JavaScript?

The production JavaScript compiler analyzes your entire program and optimizes
code in ways you might not be able to or want to do. Just like `gcc`
moves code around to produce efficient code, the production web
compiler takes advantage of Dart's structured nature to implement
global optimizations.

We don't claim that all Dart code will run faster
than handwritten JavaScript, when compiled to JavaScript,
but we're working to make the common cases fast.

### Q. How can I write Dart code that compiles to performant JavaScript?

See [Improving production web compilation](/tools/dart-compile#helping-generate-efficient-code).
This information might change as the implementation of
`dart compile js` changes.

### Q. Why is the code for "Hello, World" so big, compared to the original Dart code after compilation to JavaScript?

We believe that it's important to create small and efficient JavaScript
from Dart, but most developers don't write "Hello, World" apps. It's all
relative, and with tree shaking (dead code elimination), minification, and
compression, Dart apps can be compiled to JavaScript fairly efficiently.

Kevin Moore [saw improvements][ppwsize] in the size of the generated
JavaScript from his real-world HTML5 game.

The web compiler team strives to reduce output code, but focuses more on
real-world apps instead of trivial examples.

### Q. How are floating point numbers handled when compiled to JavaScript?

JavaScript has only one number representation: an IEEE-754 double-precision
floating-point number. This means that any number—integer or floating
point—is represented as a double. JavaScript has typed data arrays,
and the mapping from native Dart typed lists to JavaScript typed arrays is trivial.

### Q. How are integers handled when compiled to JavaScript?

Because all numbers are stored as doubles,
integers are restricted to a 53-bit precision.
Integer values in the range of -2<sup>53</sup> to 2<sup>53</sup> can be stored
without loss of accuracy.
Because JavaScript VMs play tricks
with the internal representation of numbers
(similar to those described above),
staying within smi range is still good practice.

### Q. How are typed lists handled when compiled to JavaScript?

JavaScript offers typed arrays compatible with Dart's typed lists.
The mapping is trivial: `Float32List` becomes a `Float32Array`.
One exception exists: the production JavaScript compiler does not support
64-bit integers: `Int64List` or `Uint64List`. Compiling Dart code with
either of those lists results in a runtime exception.

[ppwsize]: https://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[package:js]: {{site.pub-pkg}}/js
[dart compile]: /tools/dart-compile
[dart analyze]: /tools/dart-analyze
[typescript]: {{site.news}}/2012/10/the-dart-team-welcomes-typescript.html
[webdev]: /tools/webdev

[dart-mirror]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors
[pub-cmd]: https://dart.dev/tools/pub/cmd