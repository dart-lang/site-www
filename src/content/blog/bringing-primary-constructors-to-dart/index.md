---
title: "Bringing Primary Constructors to Dart"
description: "An inside look at the design decisions, trade-offs, and syntactic sugar behind adding primary constructors to Dart 3.13."
publishDate: 2026-08-20
author: munificent
image: images/dash-primary-constructors.webp
category: deep-dive
layout: blog
---

<DashImage
  src="images/dash-primary-constructors.webp"
  alt="Illustration of Dash with blueprint drawing of primary constructor syntax."
  caption="Bringing primary constructors to Dart"
/>

(AI disclosure: I wrote every sentence of this myself—including the em
dashes.)

My favorite feature in Dart 3.13 is
[primary constructors](https://dart.dev/language/primary-constructors).
Getting there took a lot of time and iteration before the language team had a
design we felt was solid. Since many of you have been patiently waiting for
this feature, I thought it would be worth writing about some of the challenges
we worked through to bring this large syntax change to Dart.

## On syntactic sugar

Users have been asking for something like primary constructors for years.
It's a highly desired feature, which is kind of strange when you think about
it. Primary constructors don't let you do anything you can't already do in
Dart. They're just a different—hopefully better!—syntax for what you can
already express.

In the 1960s, Peter Landin coined the term "syntactic sugaring" to refer to
layering some textual niceties on top of a more fundamental but unpleasant
language. Today, we tend to use the term more like a noun and call features
like these "syntactic sugar".

The immortal enemy of every programming language is complexity.
Even the tiniest feature must be designed,
specified, implemented, tested, and documented.
The cost is large. I think of complexity in a language like weight in an
airplane. Some amount of it is necessary for the thing to work,
but you have to be careful to not add weight unnecessarily or risk the whole
apparatus not getting off the ground.

From that angle, syntactic sugar seems like a bad idea.
It's additional complexity with no additional utility.
Even worse, once we add it, we pass complexity onto our users too.
Now they have to choose which syntax to use each time they are trying to
express something.

When are these kinds of features ever a good idea?
(I admit I feel some need to justify this because so much of my work over the
past several years has been adding these kinds of features to Dart.)
I think syntactic sugar can carry its weight in a couple of ways:

### The new way is simply better

Despite our somewhat robotic affect and fondness for
[EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form), we
language designers are human and make mistakes.
Further, we are always learning, the ecosystem we serve is constantly
discovering new ways to make software,
and user expectations drift over time.

When Dart was first designed, you had to use an explicit `new` keyword to call
a constructor. This was deliberate to be familiar to users coming from C++,
Java, JavaScript, and other languages.
The intent was to make it clearer in the code when a call allocates a new
object. As garbage collectors got better and users got more comfortable with
automatic memory management, most users found `new` to be more noise than
signal.

(Also, honestly, Dart has always undermined that signal by supporting
[factory constructors](https://dart.dev/language/constructors#factory-constructors).
A factory constructor can return some previously created object even when you
invoke it with `new`.)

In Dart 2.0, we shipped a language change that allowed you to omit the `new`
keyword (and `const` in many places) when calling a constructor.
We still support the old syntax, so this language change is essentially
syntactic sugar, but we really only kept the old syntax around for backwards
compatibility.

We always want you to use the new shorter syntax.
We shipped [tooling](https://dart.dev/tools/dart-fix) to automatically remove
the unnecessary `new` keywords, and have
[a lint](https://dart.dev/tools/linter-rules/unnecessary_new) that reminds you
when you forget. The old syntax is effectively deprecated and over time you
see it less and less. If you're new to Dart,
you may not have even realized we supported using `new` in constructor calls.

That means the complexity for supporting constructor calls both with and
without `new` is low. There is a transition cost for existing users to learn
the new syntax. But new users will mostly just learn the new way and never
encounter the old. There's little cognitive load when choosing between the two
syntaxes because you simply always use the new one (and our tools will gently
remind you if you don't).

Short of having a time machine to go back and do it right the first time,
this is the next best thing we can do to fix a mistake in the language.

### The syntax can be much better for a common use case

For the first several years of its public existence,
Dart had no support for enum declarations.
The language didn't let you write:

```dart
enum Color { red, blue, yellow }
```

Instead, you had to write something like this:

```dart
class Color {
  static const Color red = Color._(0, 'red');
  static const Color blue = Color._(1, 'blue');
  static const Color yellow = Color._(2, 'yellow');

  const Color._(this.index, this.name);

  final int index;
  final String name;
}
```

Old Java heads will remember this as Josh Bloch's "typesafe enum pattern".
Under the hood, this more verbose class declaration does almost exactly the
same thing as an enum declaration in Dart today.
Dart enum declarations are almost entirely sugar.
(I say "almost" because enum declarations give you
[exhaustiveness checks](https://dart.dev/language/branches#exhaustiveness-checking)
in switches.)

However, as you can see from these two examples,
enum declarations are *really nice* sugar.
A simple enum declaration unpacks to a lot of Dart code.
Now, if almost no one was writing enumerated types,
then it might still not be worth adding syntax to optimize for this use case.
But in a language that prioritizes type safety and data validation,
enums are quite common. The Flutter framework alone defines dozens of them.

A relatively small amount of syntactic sugar can sometimes make a *lot* of
user code shorter and simpler.

### The syntax can make the intent clearer

The previous section makes it sound like brevity is the whole point.
I suppose in a world where we are increasingly paying AI agents per-token
costs to read and write code there is a direct financial incentive.
But it's not just about character count.
Consider:

```dart
class Color {
  static const Color red = Color('red', 0xff0000);
  static const Color blue = Color('blue', 0x0000ff);
  static const Color yellow = Color('yellow', 0xff00ff);

  const Color(this.name, this.rgb);

  final String name;
  final int rgb;
}
```

Is this an enumerated type? By that,
I really mean *enumerated*: Should someone using this class assume that the
*only* instances of `Color` they will have to worry about are `red`,
`blue`, or `yellow`?

Note that the constructor *is* public,
so other libraries are free to invoke the constructor and create other colors.
Is the intent of this class to be a *closed* list of colors,
or an open factory of them with a handful of pre-defined values?

Reading the code, *we don't know.* The code is a lot of machinery that defines
a type and some constants. It *looks like* the code you'd write if you did
want an enum, but the machinery doesn't reveal the intent.
The code tells the compiler what the code means,
but it doesn't tell a reader how to use it.

If we change this to an enum declaration,
then the policy that it's a closed set of values becomes obvious.
(And, now that Dart has real enums,
choosing to *not* change this code to an enum declaration likely sends a
signal that it's *not* a closed set.)

For me, this is a compelling reason to add syntactic sugar.
Code is written and executed as syntax,
but what every user working with the code cares about is what it *means*—its
semantics. To maintain code correctly,
we need to understand its intentions and policy.
This is increasingly true in a world where AI is often generating code faster
than we have time to diligently review it.

Even when it's possible to make the compiler do what you want by cobbling
together the machinery of several existing language features,
it can be worth it to have syntactic sugar that yields the same behavior
because better syntax raises that behavior into a higher level of abstraction
where the intended semantics are more obvious.
That can *reduce* the cognitive work required to understand the code even
though the entire language is more complex.

## Why primary constructors

Right, I'm supposed to be talking about primary constructors,
not enums and `new` keywords. (Though—foreshadowing!—I will be talking about
`new` too.) For many years, the
[#1 open issue](https://github.com/dart-lang/language/issues/314) on the Dart
language repo has been a feature request for data classes.
If you don't know, data classes are
[a feature in Kotlin](https://kotlinlang.org/docs/data-classes.html) that lets
you define a class with some fields,
and the compiler gives you equality,
hash code, and some other stuff for free.

If you read through the hundreds of comments on that issue,
you'll see that most users are less interested in the value semantics part—the
equality and hash code bits. It's mostly about having an easier way to define
a class that has a constructor and stores some state.

That functionality actually comes from a different,
more fundamental feature in Kotlin:
[primary constructors](https://kotlinlang.org/docs/classes.html#primary-constructor).
I believe Kotlin got this idea from
[Scala](https://docs.scala-lang.org/scala3/book/domain-modeling-tools.html#classes).
Since then,
[C#](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/instance-constructors#primary-constructors)
and [Java](https://openjdk.org/jeps/395) have added their own takes on the
concept.

(The value semantics part of data classes is useful too.
We are
[exploring that separately](https://github.com/dart-lang/language/blob/main/working/value-classes/feature-specification.md).
)

There are two key pieces to primary constructors:

- You can define a constructor by writing a parameter list right inside the
  class header. That avoids needing to write a keyword or repeat the class name
  to declare the constructor. It also avoids two levels of nesting and
  indentation, one for the class body and one for the constructor parameter
  list, in very simple classes that only contain some state.

- Inside that parameter list, you can indicate that some parameters should
  declare corresponding instance fields that are automatically initialized from
  the parameter.

Without primary constructors or any other kind of syntactic sugar,
we have to do something like this in Dart:

```dart
class Point {
  final int x;
  final int y;

  Point(int x, int y) : x = x, y = y;
}
```

In this example, we had to write the class name twice.
For each bit of state, we wrote its type twice and its name *four* times.
It's not too heinous in this example because there are only two fields and the
names are all short. Once you start dealing with complex domain-specific stuff
with long names and piles of state,
it gets ugly.

This is not a new problem, and Dart has long had a bit of syntactic sugar
called "[initializing
formals](https://dart.dev/language/constructors#use-initializing-formal-parameters)"
to help:

```dart
class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}
```

Using `this.` on constructor parameters means you only have to write each
field's type once and name twice. Better!
But you still have to write the class name twice and each field's name twice.
Initializing formals are nice, but users still tell us they don't go far
enough.

## On borrowing features from other languages

So some users coming to Dart from another language tell us that they miss a
feature. What do we do with that kind of feedback?

Personally, I like borrowing features from other languages.
The creators of those languages have already put a lot of work into designing
and validating the feature. We can learn a lot from them,
and that other language is an existence proof that the feature is conceptually
coherent and tractable to implement.

Taking inspiration from other languages can also make our language easier to
learn. Unless a user is completely new to programming,
they aren't learning Dart from scratch.
They come to us with all that they have already learned from other languages.
What remains for them to learn is the *difference* between what they know and
what Dart contains. When we borrow syntax and semantics from other languages,
we reduce the size of that difference and lower the effort to learn Dart.

This philosophy has been key to Dart's success.
From little semicolons all the way up to classes,
Dart was designed through and through to be familiar and easy to learn for
users of other mainstream languages like JavaScript,
Java, and C#.

At the same time, good language design is contextual and holistic.
"What's a good pair of shoes?" has very different answers when you are
standing on the arctic tundra versus a Hawaiian beach.
A language feature that works beautifully in,
say, Rust might not slot gracefully into Dart with its distinct syntax,
semantics, history, user base, and ecosystem.

I don't want Dart to feel like Frankenstein's monster stitched together from
body parts ripped off of other languages.
Thus, when the Dart language team looks at features from other languages,
we're simultaneously looking at how the feature solves problems in that
language's context and also at how well that context matches Dart's own.

## Adding primary constructors to Dart

We knew users wanted a nicer notation to define a class that initializes some
fields from constructor parameters.
With primary constructors, you write the constructor and the compiler
synthesizes the fields. A language could also go the other way.
You write the field declarations and the compiler gives you the constructor
for free. Swift does that with
[memberwise initializers](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Memberwise-Initializers-for-Structure-Types).

A challenge any time your language derives two declarations from one piece of
syntax is that one syntax needs to handle all of the various ways you might
configure both of those declarations.
In our case here, the instance field may be final or not.
It might have metadata like `@override` or doc comments on it.
The constructor can be named or unnamed,
`const` or not. A constructor parameter can be positional or named,
optional or required. If it's optional,
it might need to specify a default value.

We spent some time investigating
[inferring a constructor from field declarations](https://github.com/dart-lang/language/issues/698),
but eventually decided that parameters were the more useful declaration for a
user to hand-author. Since the constructor is often public API,
it's important to control the signature fully:
the constructor's name and `const` -ness,
which parameters are named or positional,
the order of the positional ones, and their default values.

In order to infer an instance field from a constructor parameter,
the only missing piece a user needs to provide is whether the field should be
final. It's fairly natural to allow a leading `final` or `var` on the
parameter to control that. The absence of both modifiers then means the
parameter doesn't declare an instance field at all.
That's similar to what Scala and Kotlin do with `val` and `var`.
The result in Dart looks like this:

```dart
class Point(
  final int x,
  final int y,
);
```

(Since primary constructors make empty class bodies more common,
we also now allow you to use `;` instead of `{}` for an empty class body.)

## On syntactic cliffs

This looks pretty nice, but what if the primary constructor also needs a body
or an initializer list? One option is to simply say,
"Well, in that case, don't use a primary constructor."
Syntactic sugar often takes a subset of use cases and offers more concise
syntax for them. If you fall outside of that subset,
it's reasonable to require the user to fall back to the older,
more elaborate syntax.

That's the right call in some cases.
But the language team is very mindful that code evolves over time.
Let's say you're writing a class. It starts off simple with just a few fields
initialized from constructor parameters:

```dart
class FormatterOptions({
  final int indent = 0,
  final int pageWidth = 80,
}) {
  // ...
}
```

A perfect use case for a primary constructor.
Later you add some more fields and parameters.
Great. Before long, you have a constructor with a bunch of parameters
declaring fields:

```dart
class FormatterOptions(
  final int indent = 0,
  final int pageWidth = 80,
  final Version? languageVersion,
  final TrailingCommas? trailingCommas,
  final bool followLinks = false,
  final Show show = Show.changed,
  final Output output = Output.write,
  final Summary summary = Summary.none,
  final bool setExitIfChanged = false,
  final List<String> experimentFlags = const [],
) {
  // ...
}
```

Then one day you decide you want to do a little logging in the constructor
body. If primary constructors didn't support bodies,
then you would have to convert that entire primary constructor into an in-body
constructor:

```dart
class FormatterOptions {
  final int indent;
  final int pageWidth;
  final Version? languageVersion;
  final TrailingCommas? trailingCommas;
  final bool followLinks;
  final Show show;
  final Output output;
  final Summary summary;
  final bool setExitIfChanged;
  final List<String> experimentFlags;

  FormatterOptions({
    this.indent = 0,
    this.pageWidth = 80,
    this.languageVersion,
    this.trailingCommas,
    this.followLinks,
    this.show = Show.changed,
    this.output = Output.write,
    this.summary = Summary.none,
    this.setExitIfChanged = false,
    this.experimentFlags = const [],
  }) {
    log.write('Created options.');
  }

  // ...
}
```

That's doable. The Dart SDK includes lots of quick-fix tooling that can do
these exact kinds of changes for you with a click of a button,
so it's not *mechanically* hard to change the code.
But it's still a large textual change.
You just wanted to add a line of logging and now you have 20 lines of changes
to look at.

On the language team, we call this a "syntactic cliff".
You want to make a small *semantic* change (here,
adding a line of logging), but what you want to express is just slightly
outside the bounds of what the optimized syntax supports.
You fall off the nice plateau of that syntax and land on the more verbose
terrain below.

It doesn't feel good when that happens.
You're trying to freely explore the semantic space of your program,
but it feels like some small steps in meaning are just out of reach in terms
of syntax. When we're designing language features,
we spend a lot of time talking about these kinds of cliffs and trying to avoid
them when we can.

We want the language to feel like smooth terrain where small semantic changes
only require equally small textual ones.
When you are doing a code review, we want the changed lines to reflect the
behavioral changes in the program, and not meaningless lateral moves through
the language's grammar.

## Primary constructor bodies

Kotlin's solution is to allow an
[initializer block](https://kotlinlang.org/docs/classes.html#initializer-blocks)
inside the class body. In Dart, we support something similar,
but using the `this` keyword:

```dart
class FormatterOptions(
  final int indent = 0,
  final int pageWidth = 80,
  final Version? languageVersion,
  final TrailingCommas? trailingCommas,
  final bool followLinks = false,
  final Show show = Show.changed,
  final Output output = Output.write,
  final Summary summary = Summary.none,
  final bool setExitIfChanged = false,
  final List<String> experimentFlags = const [],
) {
  this {
    log.write('Created options.');
  }
}
```

The initializer block gives you a place to fill in a body or initializer list
for the primary constructor. It's also a natural place to add a doc comment
for the constructor. (If you put the doc comment above the class header,
it applies to the entire class, not just the primary constructor.)

These initializer blocks are sort of syntactic sugar on top of syntactic
sugar. We don't need them, but they help prevent users from falling off a
syntactic cliff. You can start with a primary constructor while your class is
simple, and the language never forces you out of that choice as your class
evolves.

## On semantic bundling

Now, even though *the language* won't force you to turn your primary
constructor into an in-body constructor,
*you* might still want to define a constructor inside the class body.
Classes can have a lot of things going on in the class header:
type parameters, an `extends` clause,
mixins in a `with` clause, and maybe `implements` too.
The constructor parameters might have doc comments.
It can get cluttered and messy up there.

Or you might have a class with multiple constructors where none of them is
clearly more "primary" than the others.
(When you have a primary constructor,
all other non-factory constructors for the class must redirect to it.)
Alternatively, maybe the most fundamental constructor is private,
and you think it looks confusing to put a private constructor in the highly
visible class header.

For these reasons and more, Dart still supports constructors declared inside
the class body. We don't think of primary constructors as *inherently superior
to* in-body constructors, just different and better suited to certain use
cases.

However, only a primary constructor has access to the `var` and `final`
syntactic sugar on a parameter that implicitly declares an instance field and
initializes it from that parameter.
Those two features—declaring a constructor in the class header and constructor
parameters that induce fields—are bundled together.
You can't use the latter without the former.

In general, we try hard with the language to not put the user in a position
where they want only one of two behaviors but the language ties them together
and makes them take both. For example,
when we added [class modifiers](https://dart.dev/language/class-modifiers), we
deliberately added both `final` and `sealed`.
They are quite similar, but `final` lets you prevent subclassing *without*
also opting in to exhaustiveness checking.

Deciding what to bundle is a balancing act.
I believe a big part of what gives each programming language its character and
fitness for certain domains is how it chooses to map semantics onto syntax.
Part of that is where it hangs multiple behaviors off a single piece of text.
For example, in most object-oriented languages,
making a class a subclass of another also makes it a subtype in the static
type system. That's not strictly necessary,
as private inheritance in C++ shows.
But for most object-oriented languages,
that coupling seems to make sense.

It might seem ideal to have a strict one-to-one mapping of behavior to text,
but bundling behavior can make it easier to express common patterns.
Think about how much easier it is to walk into a burger joint and say "I'll
have a #2," instead of, "a double cheeseburger with mustard but no ketchup,
medium fries, and a medium fountain drink."

When it comes to combining declaring parameters with primary constructors,
this felt like a relatively safe bundling.
Declaring parameters are themselves syntactic sugar and don't let you express
anything you can't already express in a normal class declaration.
If you don't want a constructor to be a primary constructor for whatever
reason, you have to give up the syntactic convenience of declaring parameters.
But brevity is all you give up. You can still define your class with exactly
the API and semantics you want.

It would be nice to be able to use declaring parameters inside in-body
constructors, and we worked on
[a proposal](https://github.com/dart-lang/language/blob/main/working/declaring-constructors/feature-specification.md)
to allow it. Ultimately, we felt there were too many negative consequences.
If some random constructor anywhere in the class body can implicitly declare
instance fields in its parameter list,
then it gets harder to find all the state a class stores and reason about it.
This is less of a problem with primary constructors because the primary
constructor is always right there at the top of the class.

## Shorter in-body constructors

Another source of verbosity with Dart's existing constructor declaration
syntax is having to repeat the class name.
It doesn't look too bad with short names in examples like `Point`,
but when you have a class name like,
say,
[`AnimatedFractionallySizedBox`](https://api.flutter.dev/flutter/widgets/AnimatedFractionallySizedBox-class.html),
then repeating that entire 28-character identifier takes up a lot of space
that could otherwise be spent on the constructor's parameter list.

That problem we *can* fix. Dart's constructor syntax was inherited from Java
and C#, which in turn inherited it from C++.
Bjarne Stroustrup chose to use the class name to minimize the number of new
keywords and mirror what a constructor call looks like.
It's a cute syntax, but even he admits "this may have been overly clever."

Having one part of a language's syntax mirror another part can be a useful
tool to help users understand what the code means.
When two pieces of code look the same,
it sends a signal that they probably relate to each other in some way.
And if declarations look like call sites,
then once you've read the declaration,
you know what to write to call it.

At least, that's the idea. But Dart already fails to follow through on that
principle. It kind of works for function and method declarations if you ignore
the type annotations. Getters are declared using a `get` keyword without being
invoked using one. Operators are declared using a special `operator` keyword
and have the right-hand parameter in parentheses even though you don't need
parentheses to call the operator. Even in functions,
Dart uses `{...}` to declare named parameters,
which looks nothing like how you pass them at the call site.

Most other object-oriented languages don't use the class name to define a
constructor. Swift, Ruby, and Objective-C use `init()`.
Python sprinkles on some underscores and does `__init__()`.
JavaScript, TypeScript, and Kotlin use `constructor`.
PHP uses `__construct`.

This led us to conclude that repeating the class name for a constructor wasn't
really buying us much in terms of familiarity or consistency.
And there is a cost users must pay.
Names are often verbose, and every human,
template processor, code generator,
AI agent producing code, or future metaprogramming feature that wants to
inject a constructor into the class needs to know to use the class name.
It's almost like each class has its own special little contextual keyword.

That problem is particularly acute in another feature we're working on right
now:
[static extension members](https://github.com/dart-lang/language/blob/main/working/0723-static-extensions/feature-specification.md).
Extensions in Dart allow you to attach instance members to existing types,
but they don't currently let you add static members or constructors.
We'd like to support those too, but it raises a tricky edge case.
Extensions can be defined not just on classes,
but any static type, including typedefs.
Consider:

```dart
class SomeClass {}

typedef OtherName = SomeClass;

extension on OtherName {
  // ...
}
```

If you want to add a constructor in that extension,
what name do you use: `OtherName` or `SomeClass`?
Keep in mind that from the type system's perspective,
those are the exact same type. There is no class named `OtherName` anywhere in
the program. The typedef isn't creating a new named type,
it's just defining an ephemeral alias that can be used to refer to some other
type.

We could require you to use `OtherName` because that's the name that you wrote
at the top of the extension declaration.
But that violates the principle that a type can be replaced with a typedef
that refers to the same type without breaking anything.
Usually, swapping out a reference to some type with a typedef is a transparent
change. Here, and only here, the typedef name would become significant.

Or we could go the other way and say you have to use the name of the
underlying class that the typedef resolves to.
But that breaks the encapsulation of the typedef.
The typedef could be in another library and refer to a private class whose
name you can't even access in your library!

All the complexity here is a problem we created ourselves by using the class
name as a magic identifier to mean "constructor".
If we just pick a universal keyword,
the problem goes away.

So that's what we did. In Dart 3.13,
you can use `new` instead of the class name to declare a non-factory
constructor, and `factory` to declare a factory constructor.
If you want a named constructor, put the name after the `new` or `factory`
keyword.

```dart
// Before Dart 3.13:
class LongClassName {
  LongClassName();                          // Unnamed constructor.
  LongClassName.create();                   // Named constructor.
}

class AnotherLongClass {
  factory AnotherLongClass() { ... }        // Factory constructor.
  factory AnotherLongClass.create() { ... } // Named factory constructor.
}

// New Dart 3.13 syntax:
class LongClassName {
  new();                                    // Unnamed constructor.
  new create();                             // Named constructor.
}

class AnotherLongClass {
  factory () { ... }                        // Factory constructor.
  factory create() { ... }                  // Named factory constructor.
}
```

(The syntax for redirecting constructors is similar.)

This is in the category of syntactic sugar that we think is strictly better.
Unless your class name is shorter than three letters,
the new syntax is always shorter. It's more regular.
Aside from being unfamiliar right now (a feeling that will pass),
we think it's just better all around.

However, using `new` to define a constructor does lead to one weird
combination. If you also want that constructor to be constant,
you need a `const` modifier:

```dart
class SomeClass {
  const new() { ... }
}
```

I admit that `const new` looks oxymoronic.
This is especially true for Dart users who have been around long enough to
remember when every constructor *invocation* started with either `new` or
`const`. In that world, the two were directly opposed.
But you no longer write `new` to invoke constructors,
so the way I think of it now, the `new` keyword mostly just means "*declare* a
constructor" and `const` is always a modifier that means "make the thing
constant".

## Recap

Thank you for revisiting this long design process with me.
We spent so long mulling over every detail of the semantics and syntax of
constructors leading up to Dart 3.13 that I could write another five thousand
words talking about it. We considered putting the primary constructor
parameter list after the `extends`,
`implements`, and `with` clauses in the class header.
We debated every corner of a class body to decide where primary constructor
parameters should be in scope. Should we allow a superclass call in the class
header? What does that mean for the `with` clause?
What happens if you have a factory constructor named `factory`?

Constructors are fundamental to object-oriented programming and Dart already
spends a *lot* of language complexity on them.
Weaving primary constructors into Dart required very carefully mending dozens
of wrinkles in the fabric of the language.
I hope the result feels seamless, but I'm sure it's not perfect.

If you run into areas of the new features that feel weird or arbitrary,
I hope this long essay helps them make more sense.
If not, let us know. The language is always evolving and we're always trying
to make it better. In the meantime,
we hope you find that your code in Dart 3.13 feels cleaner,
simpler, and more enjoyable to read and write.
