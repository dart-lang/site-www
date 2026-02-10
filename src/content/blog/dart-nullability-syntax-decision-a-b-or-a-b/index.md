---
title: "Dart nullability syntax decision: a?[b] or a?.[b]"
description: "Dart is in the process of redesigning its type system so that individual types will be either nullable (expressions of that type can have…"
publishDate: 2019-08-26
author: kwalrath
image: images/1se-VT1aPyHd3J2VYDzDW5g.png
category: other
tags:
  - programming
  - programming-languages
  - dartlang
  - dart
  - syntax
layout: blog
---

> Update (3/2021): Thanks to your feedback, the Dart team [decided to use the a?[b] syntax](https://github.com/dart-lang/language/issues/376#issuecomment-576924506).

Dart is [in the process](https://github.com/dart-lang/language/issues/110) of redesigning its type system so that individual types will be either *nullable* (expressions of that type can have the value null) or *non-nullable*. Later this year we’ll tell you more about the timeline and roll-out process, but eventually Dart code will be non-nullable by default (*NNBD*), and you’ll have to use special syntax to say that a type permits null values.

For example, to declare that an integer can be null, you’ll need to add a `?` after the type:

```
int? someInt; // someInt can be null.
```


That question mark syntax might be familiar if you’ve seen Kotlin, Swift, or C# code. But some things are different — notably the subscript (`[]`) operator, which you most often see used for list or array access. C# and Swift use `?[]`. The current plan for Dart (and, by the way, for [ECMAScript](https://github.com/tc39/proposal-optional-chaining#syntax)) is to use `?.[]` instead:

```
e1?.[e2] // null if e1 is null; otherwise it’s e1[e2]
```


This article takes you behind the scenes to explain the reasoning behind this decision, and to encourage you to weigh in with your thoughts and suggestions. Most of this content is based on a [comment by Bob Nystrom](https://github.com/dart-lang/language/issues/376#issuecomment-497121257) ([munificent](https://github.com/munificent)) on language issue [#376](https://github.com/dart-lang/language/issues/376), which summarizes a discussion between Bob and the owner of the NNBD specification, Leaf Petersen ([leafpetersen](https://github.com/leafpetersen)).

## **Why use a dot?**

Both options for `[]` have advantages.

`e1?[e2]`:

* Follows C# and Swift

* Is concise

* Is similar to the syntax for the `!` operator (which you’ll be able to add after an expression to say that its value isn’t null, even though it has a nullable type): `e1![e2]`

`e1?.[e2]`:

* Is similar to cascade syntax:
`e1..[e2] // cascade syntax
e1?..[e2] // null-aware cascade syntax`

* Is similar to other null-aware method syntax: `e1?.e2()`

* Extends naturally to other operators

* Avoids the ambiguity in the following code: `{ e1 ? [e2] : e3 }`

We spent a while trying to come up with ways to avoid the ambiguity of `?[`. The problem is that you can’t tell whether code like `{ e1 ? [e2] : e3 }` is a [set literal](https://dart.dev/guides/language/language-tour#sets) containing the result of a conditional expression, or a [map literal](https://dart.dev/guides/language/language-tour#maps) containing the result of a null-aware subscript.

If we add parentheses to make that code unambiguous, we could either choose to add them around the entire expression — `{ (e1 ? [e2] : e3) }` — making it unambiguously a set literal. Or we could add them around the first part — `{ (e1 ? [e2]) : e3 }` — making it unambiguously a map literal. But in the absence of parentheses, the parser doesn’t know what to do.

There are various solutions to this ambiguity, but none of them seem very satisfying. One approach is to rely on whitespace to distinguish between the options. In this approach, you always treat `e1 ? [e2]` as the start of a conditional expression, because there is a space between the `?` and the `[`. And you always treat `e1?[e2]` as a null-aware subscript because there’s no space between those two tokens. But relying on whitespace can really harm the user experience.

In theory, relying on whitespace isn’t a problem in formatted code. But many users write unformatted Dart code as an input to the formatter. And that input format would thus become more whitespace sensitive and brittle in this corner of the language. So far, those kind of corners are very rare in Dart, which is a nice feature. (One such corner is that `— — a` and `--a` are both valid but mean different things.)

Ignoring the ambiguity, there’s another reason for using the dot: if we add null-aware forms for other operators — `e1?.+(e2)`, etc. — we’ll probably want to require the dot, in which case requiring it for subscript is consistent with that future.

Another addition we’ve discussed for NNBD is a null-aware call syntax. If we don’t require a dot there, it has the exact same ambiguity problem:

```
var wat = { e1?(e2):e3 }; // Map or set?
```


Whatever fix we come up with for the `?[`, we’ll also have to apply to `?(`.

Finally, consider this example of chaining the subscript:

```
someJson?[recipes]?[2]?[ingredients]?[pepper]
```


To our eyes, that doesn’t look very good. It scans less like a method chain and more like some combination of infix operators — a little like `??`. Compare it to this code:

```
someJson?.[recipes]?.[2]?.[ingredients]?.[pepper]
```


Here, it’s more clearly a method chain. Communicating that visually is important too, because users need to quickly understand how much of an expression will get null-short-circuited.

Putting all of that together, it seems like we should use the `?.[` form for the following reasons:

* It avoids ambiguity problems. (The lexer already treats `?.` as a single “null-aware” token.)

* It extends naturally to a null-aware call.

* It extends to other null-aware operators.

* It leaves Dart a more robust input language to the formatter.

* It looks pretty OK in a method chain.

* It makes it visually clearer how much of a method chain may be short-circuited.

## What do you think?

We’re always interested in feedback and suggestions. The best way to give feedback on this syntax is to comment (or thumbs-up a comment) on [language issue #376](https://github.com/dart-lang/language/issues/376). While you’re at it, consider checking out all of the other cool language features we’re working on.

Here’s where you can find more information:

NNBD:

* [Feature specification](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/feature-specification.md)

* [Roadmap](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md)

* [Issues](https://github.com/dart-lang/language/issues?utf8=%E2%9C%93&q=label%3Annbd)

Other Dart language changes and features:

* [Status of language changes](https://github.com/dart-lang/language/projects/1)

* [Language evolution process](https://github.com/dart-lang/language/blob/master/doc/life_of_a_language_feature.md#dart-language-evolution-process)

* [Dart language specification](https://dart.dev/guides/language/spec)

<DashImage src="images/1se-VT1aPyHd3J2VYDzDW5g.png" alt="A function that accepts a null argument and can return null." caption="A function that accepts a null argument and can return null." />
