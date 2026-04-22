---
title: "Announcing Dart 2.7: A safer, more expressive Dart"
description: "Today we’re announcing the stable release of the Dart 2.7 SDK, with additional new capabilities for developers. It’s been a busy year for…"
publishDate: 2019-12-11
author: mit-mit
image: images/0G-I1kyYJFCTCiAUk.png
category: releases
layout: blog
---


Today we’re announcing the stable release of the Dart 2.7 SDK, with additional new capabilities for developers. It’s been a busy year for Dart, our client-optimized language for fast apps on any platform. We’ve shipped six new releases with dozens of new features. It’s been very rewarding to see the Dart community use these features, and we were delighted by the recent [GitHub Octoverse](https://octoverse.github.com/) report listing Dart as the [#1 fastest growing language](https://octoverse.github.com/#top-languages), ranked by number of contributors.

Dart 2.7 adds support for extension methods, plus a new package for handling strings with special characters. We have an update on null safety (type-safe nullable and non-nullable types) and a brand new null safety playground experience in DartPad. At the ecosystem level, pub.dev has a new *Like* feature for giving feedback to packages that you appreciate. Dart 2.7 is available today as an SDK download from [dart.dev](http://dart.dev), and it’s also built into today’s [Flutter 1.12 release](https://medium.com/@csells_18027/flutter-1-12-release-blog-22c256ba525d).

<DashImage src="images/0G-I1kyYJFCTCiAUk.png" />


## Extension methods

Dart 2.7 adds a long-requested, powerful new language feature: **extension methods**. These enable you to add new functionality to any type — even types you don’t control — and have the brevity and auto-complete experience of regular method calls.

Let’s look at a small example: adding support for parsing ints and doubles from Strings. As app developers we can’t change the `String` class, because that’s defined in the dart:core library, but with extension methods we can extend it! Once we define this extension, we can call our new `parseInt` method on a String as if the method was defined on the String class itself:

```
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}

main() {
  int i = '42'.parseInt();
  print(i);
}
```


## Extension methods are static

Extension methods are resolved and dispatched statically, which means you can’t call them on values whose type is `dynamic`. Here the call throws an exception at runtime:

```
dynamic d = '2';

d.parseInt();

→ Runtime exception: NoSuchMethodError
```


Extension methods work well with Dart’s [type inference](https://dart.dev/guides/language/sound-dart#type-inference), so in the following variable `v` is inferred to have type `String`, and the extension on String is available:

```
var v = '1';
v.parseInt(); // Works!
```


Because extension methods are resolved statically, they’re as fast as calling a static function or helper method, but with a much friendlier invocation syntax.

## Extensions can have type variables

Imagine we want to define an extension on `List` for getting the elements at even indices. We’d like this extension to work on lists of any type, returning a new list of the same type as the input list. We can do this by making the extension generic and applying its type parameter to both the type it extends and the extension method:

```
extension FancyList<T> on List<T> {
  List<T> get evenElements {
    return <T>[for (int i = 0; i < this.length; i += 2) this[i]];
  }
}
```


## Extension methods are really extension members

We call the feature *extension methods* because that’s familiar terminology if you’ve used the corresponding language feature in other programming languages. But in Dart the feature is more general: it also supports extending classes with new getters, setters, and operators. In the FancyList example above, `evenElements` is a getter. Here’s an example of adding an operator for shifting strings:

```
extension ShiftString on String {
  String operator <<(int shift) {
    return this.substring(shift, this.length) + this.substring(0, shift);
  }
}
```


## Great examples from the community

We’ve already seen many developers in the Dart community experiment with extension methods. Here are some of the cool uses we’ve seen so far.

Jeremiah Ogbomo created the [time package](https://pub.dev/packages/time), which uses extensions on `num` (the base class for ints and doubles) to enable easy construction of `Duration` objects:

```
// Create a Duration via a `minutes` extension on num.
Duration tenMinutes = 10.minutes;

// Create a Duration via an `hours` extension on num.
Duration oneHourThirtyMinutes = 1.5.hours;

// Create a DateTime using a `+` operator extension on DateTime.
final DateTime afterTenMinutes = DateTime.now() + 10.minutes;
```


Marcelo Glasberg created an [i18n (internationalization) package](https://www.reddit.com/r/FlutterDev/comments/dm288s/dart_extensions_applied_to_i18n_you_have/) that uses extension methods to simplify string localization:

```
Text('Hello'.i18n) // Displays Hello in English, Hola in Spanish, etc.
```


Simon Leier created the [dartx package](https://pub.dev/packages/dartx), which contains extensions for a bunch of core Dart types. Some examples:

```
var allButFirstAndLast = list.slice(1, -2);    // [1, 2, 3, 4]
var notBlank = ' .'.isBlank;                   // false
var file = File('some/path/testFile.dart');
print(file.name);                              // testFile.dart
print(file.nameWithoutExtension);              // testFile
```


Brian Egan is [updating](https://github.com/ReactiveX/rxdart/pull/368) the popular [RxDart package](https://pub.dev/packages/rxdart) with extension methods to redefine the API for working with streams.

## Safe substring handling

Dart’s standard String class uses the [UTF-16](https://en.wikipedia.org/wiki/UTF-16) encoding. This is a common choice in programming languages, especially those that offer support for running both natively on devices, and on the web.

UTF-16 strings usually work well, and the encoding is transparent to the developer. However, when manipulating strings, and especially when manipulating strings entered by users, you may experience a difference between what the user perceives as a character, and what is encoded as a code unit in UTF-16. Let’s look at a small example, extracting the first three characters of a string entered by a user:

```
var input = ['Resume'];
input.forEach((s) => print(s.substring(0, 3)));

$ dart main.dart
Res
```


No problems so far; we printed the first three characters of the string in our input list, and the result is `Res`. Now let’s consider users from varying regions, who might enter strings that contain accents, Hangul (Korean script), and even a combination of emoji to represent the concept ‘resume’:

```
// New longer input list:
var input = ['Resume', 'Résumé', '이력서', '💼📃', 'Currículo'];

$ dart main.dart
Res
Ré
이력서
💼�
Cur
```


Hmm, some of those worked, but what happened to the elements `Résumé` and `💼📃`? For `Résumé`, why did we get a “two character” string? For `💼📃`, what’s up with the odd question mark? The problems here lie in the [dark corners of Unicode](https://eev.ee/blog/2015/09/12/dark-corners-of-unicode/). The accented `é` in `Résumé` is actually two code points: an *e* and a [*combining acute accent*](https://unicode.org/cldr/utility/character.jsp?a=0301). And 📃, the [page with curl](https://emojipedia.org/emoji/%F0%9F%93%83/) emoji, is a single code point that happens to be encoded with a surrogate pair of `U+d83d U+dcc3`. Confused?

As we said, often you don’t need to worry about characters and code points. If all you do is receive, pass around, and hand over whole strings, the internal encoding is transparent. But if you need to iterate over the characters of a string or to manipulate the contents of a string, you can get into trouble. The good news is that Dart 2.7 **introduces a new package, [characters](https://pub.dev/packages/characters)**, for handling these cases. This package supports strings viewed as sequences of user-perceived characters, also known as Unicode [grapheme clusters](https://unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries). With the characters package we can fix our code with a small change to the code that shortens the text:

```
// Before:
input.forEach((s) => print(s.substring(0, 3)));

// After, using the characters package:
input.forEach((s) => print(s.characters.take(3)));
```


First we create a new `Characters` instance from the string in `s` (using the convenient `.characters` extension method). Then we use the nifty `take()` method to extract the initial 3 characters.

A technical preview of this new package is [available on pub.dev](https://pub.dev/packages/characters). We’d love to hear your thoughts about this package. If you find any issues, [please report them](https://github.com/dart-lang/characters/issues).

## Null safety preview

A few months ago we [announced our intent](https://medium.com/dartlang/announcing-dart-2-5-super-charged-development-328822024970#0391) to support **null safety** in Dart, adding support for accessing object references safely without triggering null reference exceptions. Today we’re giving you a way to preview null safety static analysis. Let’s look at a small motivating example:

```
void main() {
  Person('Larry', birthday: DateTime(1973, 03, 26)).describe();
  Person('Sergey').describe();
}

class Person {
  String firstName;
  DateTime birthday;
  Person(this.firstName, {this.birthday});

  void describe() {
    print(firstName);
    int birthyear = birthday?.year;
    print('Born ${DateTime.now().year - birthyear} years ago');
  }
}
```


If we run this code it crashes with a null pointer exception while describing the second person, because that person doesn’t have a birthday set. We made a coding mistake: while we did anticipate some persons having unknown birthdays by making the `birthday` field optional in the constructor and by testing for a null birthday in `birthday?.year`, we forgot to handle the case where `birthyear` is null.

Let’s try to paste this code into our new [null safety playground](https://nullsafety.dartpad.dev), a special build of DartPad that contains a technical preview of the static analysis part of the null safety feature. Without even running the code, we can see three issues:

<DashImage src="images/0YFTJUSwsYzsHTY4b.png" alt="DartPad with null safety showing three analysis errors related to nulls" caption="DartPad with null safety showing three analysis errors related to nulls" />


By fixing these analysis errors, we can begin to take advantage of null safety. Try making the following edits in the null safety playground (eventually getting to [this safe code](https://gist.github.com/mit-mit/c210bfb088545e69ba9231ee459615ba)):

1. To declare that birthday might be null, change
*`DateTime birthday`* to *`DateTime? birthday`*

1. To declare that birthyear might be null when birthday is null, change 
*`int birthyear`* to *`int? birthyear`*

1. Wrap the last print call in a null test:
`*if (birthyear != null)* {…}`

We hope this example gives you a good indication of the experience we want with null safety. As mentioned, this playground is just an early technical preview of part of null safety, as it’s being built. We’re working hard on completing a first beta release of null safety in the Dart SDK. Here’s what we’re working on for beta:

1. Completing the full implementation of nullable and non-nullable references

1. Integrating null safety into Dart’s type inference and smart promotion (for example, allowing safe access to a nullable variable after an assignment or null-check)

1. Porting the Dart [core libraries](https://dart.dev/guides/libraries) to declare which types are nullable and which are non-nullable

1. Adding a migration tool, which can automate the majority of the upgrade tasks for porting Dart apps and packages

Once this work is complete, we’ll make it available in a beta SDK, and you can begin to take advantage of the feature in your apps and packages. We also plan to keep the null safety playground updated with new features as they’re implemented.

While we’re sure many developers will want to use null safety as soon as it’s available, you can migrate whenever it’s convenient, opting into the feature when you’re ready. Libraries and packages that haven’t yet opted into the feature will be able to depend on libraries that *have opted in*, and vice versa.

We’ll have more to say about null safety in the coming months, including more detailed advice on how to prepare for the transition.

## Liking 👍 packages on pub.dev

Also launching on pub.dev today is a new ***Like* feature** for packages. This introduces a new “human signal” for indicating which packages you’re fond of. To like a package, simply click the thumbs-up icon that’s next to the package detail information:

<DashImage src="images/0xCGEGkntNxnM1XAh.png" alt="*pub.dev package detail page with new Like-feature voting button*" caption="*pub.dev package detail page with new Like-feature voting button*" />


Currently we don’t factor the number of likes into our overall scoring model, but we plan on doing so in a later release. We also plan on giving our general search UI and list pages a visual overhaul that will highlight the like-ability of a package.

## Thank you

On behalf of the Dart team, we’d like to thank you — and everyone in the Dart community — for your continued support! Please continue to offer us feedback, and participate in Dart [discussions and communities](https://dart.dev/community). We wouldn’t be a well-functioning open source project without the support we get from the Dart community.

2019 has been an incredibly exciting year for Dart, but we’re not stopping here. We have bold plans for 2020, including shipping stable versions of features like [dart:ffi](https://dart.dev/guides/libraries/c-interop) and [null safety](https://github.com/dart-lang/language/issues/110) and introducing new features. We invite you to start using Dart 2.7 today. It’s available from [dart.dev](http://dart.dev), in today’s [Flutter 1.12](https://medium.com/@csells_18027/flutter-1-12-release-blog-22c256ba525d) release, and on the recently [redesigned DartPad](https://medium.com/dartlang/a-brand-new-dartpad-dev-with-flutter-support-16fe6027784).