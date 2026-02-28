---
title: "Future<void> vs Future<Null>, what’s the difference?"
description: "One of the nice upgrades we were able to do in Dart 2 (in addition to better static checking, runtime type safety, optional new/const…"
publishDate: 2018-10-30
author: mfairhurst
image: images/0x0J9DBRyATjtQn42.jpg
category: other
tags:
  - type-theory
  - dart
  - dartlang
  - programming-languages
  - design-patterns
layout: blog
---


One of the nice upgrades we were able to do in [Dart 2](https://medium.com/dartlang/dart-2-stable-and-the-dart-web-platform-3775d5f8eac7) (in addition to better static checking, runtime type safety, optional new/const, core library improvements, and more) is to formalize `void` in a way that’s both more useful and less error-prone. This is especially clean in async programming where you can write `Future&lt;void&gt;` for asynchronous functions that don’t return an answer when their work completes. Before this you probably used `Future&lt;Null&gt;`, so common questions we get asked are: What’s the difference between `Future&lt;void&gt;` and `Future&lt;Null&gt;`? Which should I use, and when?

<DashImage src="images/0x0J9DBRyATjtQn42.jpg" />


Since my goal here is to be useful, I’m going to start with a TLDR.

TL;DR: **You want to use the void type 99.99% of the time.**

I also recommend you turn on two `void`-related [lint rules](https://www.dartlang.org/guides/language/analysis-options) in your projects, right now:

* **prefer_void_to_null:** Helps keep you from slipping back into the habit of typing the mostly-antiquated `Null`.

* **void_checks:** Gives you voidness semantics that you may find more intuitive, even though they are not strictly necessary for safe code.

The rest of this article is not light reading. It is a combination of history, edge cases, and type theory. What I’m about to write is like trying to explain a [Monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)), but I’ll do my best, and I hope you follow along for the ride.

## Quick Future&lt;Null&gt; trivia

To demonstrate the value you might get out of reading this post, I pose a trivia question for you.

Say we limit ourselves to two `Future`s — a `Future&lt;User&gt;` and a `Future&lt;Null&gt;`. What do the following lines of code do?

```
// does this fail in your editor?
Future<User> f1 = Future<Null>.value(null);

// does this fail at runtime?
Future<Null> f2 = Future<User>.value(0);
```


Does it help if we switch to awaits?

```
User u = await Future<Null>.value(null);
Null n = await Future<User>.value(0);
```


**pauses for dramatic effect**

The answer is that none of these four lines will show any errors in your editor, unless you have disabled implicit downcasts. That’s right, taking a `Future&lt;Null&gt;` and pretending it’s something it isn’t, like `Future&lt;User&gt;`, is 100% legal. This is not the case with `Future&lt;void&gt;`!

Also unintuitively, the second and fourth lines fail at runtime (it’s not “safe” to throw away the result of a `Future` in this way), and the others succeed silently.

These behaviors should make you uncomfortable. But don’t worry! You already know the solution: use `Future&lt;void&gt;`. I’ll break down why this unintuitive behavior works this way.

## How void works now

I debated a lot to myself about what the best ordering would be for this article. There are lots of concepts to explain here. However, I will try to go in order of most useful information to least useful information. Therefore, with void being much more useful than `Null` in Dart 2, it makes sense to start with Dart 2 `void` semantics.

The fundamental idea behind `void` in Dart is derived from the goal that a `void` value should not be used.

```
void f() {}
print(f()); // error!
```


This is hopefully what you expect to happen! So with that, so far so good.

It’s worth noting that achieving this goal *and* opening up `void` as a fairly normal type can get a bit weird:

```
f(void argument) {
  print(argument); // Error!
  // we can receive the argument, but we may not use it!
}
```


And this is where, in Dart 2, our new “generalized void” starts to get cool, and powerful…albeit sometimes confusing.

I pose the question to you…what type of value could we pass in as the argument of `f`?

```
f(void argument) { … }
f(x); // what is x?
```


The answer to this is…anything! Because we don’t let you use the value of `x` inside the function `f`, we can confidently say that there *is no value* that `x` can take *that could cause any runtime errors*.

```
f(1); // will have no difference compared to
f(“foo”); // will have no difference compared to
f([1, 2, 3]); // will have no difference compared to
// ...
```


If we derive the best semantics for `void` based on the idea that it is a value that will not be *used*, this is what we get. Which means, it’s a value that can be *filled* with absolutely anything. It’s like a vacuum: an input with no output.

Now, there are cases where something is always error-free at runtime, but still should cause static errors. This is a great case for a lint! And indeed this is the idea behind the `void_checks` lint. It looks for places where you pass anything but `null` into a `void` location, and I would encourage teams to enable it. It’s not required for soundness, but passing anything other than `null` into a `void` location is still likely to be an accident, which the lint will flag for you.

Since all of this is grounded in foundational type theory, `void` plays well with every part of Dart, even in continuations leveraging type inference in the context of a `Future&lt;void&gt;`:

```
Future<void>().then((x) {
  print(x); // error! x has type “void” so you can’t print it!
  // This is what we want!
});

// and yes, this is an error too:
Foo f = await voidFuture();
```


At this point, the average developer probably knows everything they need to know about `void` in order to effectively use it.

<DashImage src="images/0_2MNvj3It63IUFUH.gif" />


If you are still following along, however, there are a few more interesting nuggets.

Even with `void_checks` enabled, `void` locations will not be guaranteed to contain `null`. Take this override:

```
class A {
  void f(Object o) {}
}

class B extends A {
  @override
  Object f(Object o) => o;
}
```


We don’t want to make this override illegal, because it’s safe, useful, and would be a breaking change from Dart 1. And so we are forced to accept that `void` locations may hold absolutely any value. We also cannot “optimize out” the value that `A.f()` returns, because at runtime it may be a `B`!

Rather, we have the clever option of making `void` a sister type of `Object`. After all, it may hold any value, and all values are `Objects`. This is not something we designed, it’s just reality. Recognizing that reality makes it something we can then leverage.

<DashImage src="images/01ZUU5fNh-kmpPzMU.jpg" />


By making `void` a sibling of `Object`, we leave ourselves no *requirements* that a `void` value go *completely* unused. We try our best to keep `void` to itself, but we deliberately relax these restrictions in a few places for the sake of backwards compatibility:

```
dynamic f() => voidFn(); // this is legal
voidFn() as dynamic; // this is legal
```


These are special cases that would be legal for an `Object`, and we made it legal for `void`, too, in the interest of making Dart 2 a smoother rollout.

Making `void` a sibling of `Object` also means that `void` can be used as a type parameter without bloating the compiled output (no “template specialization,” for you C++ folk). This reduction is good for keeping web & Flutter apps small, at the expense of allowing the following:

```
<void>[1, 2, 3].toString(); // this is legal and prints [1, 2, 3]
```


And lastly, it may seem useless to ever type a parameter as `void`, especially since it’s a form of `Object`. However, `void` values can be *passed to* `void` *locations*:

```
f(void x) { … }
f(voidFn()); // this is legal
```


This is useful for *sequencing*, which is for instance used by [Mockito](https://pub.dartlang.org/packages/mockito) when mocking methods that return `void`. (Replace `f` with `when` in the above code for a closer approximation.)

In summary:

* The `void` type is a sibling of `Object`.

* Almost always, a `void` object can’t be used.

* Something marked `void` could be, in practice, absolutely anything.

* Anything can be “thrown away” into a location marked `void`, and the lint `void_checks` restricts this behavior.

* A `void` value can be passed into other `void` locations.

## The bottom type

Before I get to talking about `Null`, it’s critical we talk about the “bottom” type.

This is a naturally occurring type in type theory, which has a short academic definition with a few practical applications.

If you stop reading this section because *it’s so dang weird*, that is strong evidence of my original TLDR. Unless you want your code to be similarly dang weird, you probably want `void`. Now let’s explore this weird rabbit hole and see how far it goes, eh?

The bottom type is the subtype of all types. Put in simpler object-oriented terms, that means it’s a `Person`. And a `Car`. And an `Animal`. And every other type from every program ever written.

If this sounds absurd, that’s because it is. I like to think of it as a “placeholder” type. But “absurd” or “imaginary” type would also be a somewhat reasonable name for it. Instead, though, it’s called the *bottom* type, because it’s the bottom of the type hierarchy, which, in computer science, is upside down. ¯\_(ツ)_/¯. Formally, it may be referred to by the symbol ⊥, which you may also recognize as the symbol for “false.”

If you try to imagine a value that is a `Person` *and* a `Car` *and* an `Animal`, you won’t be able to think of anything. And surprisingly, that is where the practical usage of ⊥ comes from!

What if I write a function that never returns? There are two easy ways to do so:

```
loopForever() {
  while(true); // first way
}

alwaysThrow() {
  throw Exception(); // second way
}
```


What is the best return type for these two functions?

It depends. Because the function never returns, the return type doesn’t really matter. You can use any type — even the absurd bottom type, which can be used in various ways in various languages.

<DashImage src="images/0TkwIX5BsrbSzHfLr.jpg" />


C++ has this as `noreturn`. Rust has `!`, and Scala has `Nothing`. But my favorite example comes from Haskell, which has a very commonly used `undefined` function that aborts the program. It returns, you guessed it, the bottom type.

If we assume an `undefined` function in Dart like the one in Haskell, which merely throws an exception when called and returns ⊥, then it would look like the following:

```
Foo foo = cond ? val : undefined();
```


In the example usage line, the program can safely run and store `val` when `cond` is true. And when `cond` is false, the program will throw an exception during `undefined()`. It is safe to “store” the result of `undefined()` in foo, regardless of the type of `foo`, because that store will never actually happen!

`undefined()` ****here does not return anything. But the lesson here is not that we can make `foo` empty…it’s that the bottom type is empty like an empty promise. It’s emptier than empty. It just never happens.

One thing I must be careful to state is that you can and, depending on the usage, often should return `void` from these functions in practice. Usually code like `return loopForever()` is more likely to be a mistake than a useful pattern. However, the choice is yours to make.

The bottom type is also nice for read-only empty lists. In Dart, `List`s are covariant, so a `List&lt;int&gt;` is allowed to be used as a `List&lt;Object&gt;`. If you then attempt to stick a `String` inside that `List&lt;Object&gt;`, a runtime check will catch that for you and throw an error.

That means that if we make a `List` of ⊥, there’s nothing we can put into it, but we can treat it as a list of anything:

```
List<int> intList = <⊥>[];
  for(int i in intList) {
  print(i * 2); // valid, because this simply never happens
}
```


There are even more interesting cases when you look at what’s called “contravariant” placement of the bottom type.

<DashImage src="images/0OyVAekp1iwSQyfur.jpg" />


Let’s say we define a function that has a ⊥ parameter:

```
void f(⊥ x) {}
```


This is almost the opposite of the `undefined()` example. Rather than a function that never returns, we have declared a function that can’t be called! No actual value is assignable to that parameter `x`. You can’t pass in a `Person` because it’s *not also a* `Car`, and you can’t pass in a `Car` because it’s not also a `Person`. The only thing you could pass in is the absurd type itself:

```
f(undefined());
```


But as we just covered before, `undefined()` never returns, so `f()` is still never actually called in this case!

Typing a parameter as ⊥ may seem useless, but it has esoteric value because all functions that *can* be called are subtypes of functions that *can’t* be. **(Think about it: a function that *can* be called doesn’t *have* to be. And if a function is not called, it cannot produce runtime errors.)

If you’re still with me, take a deep breath and pat yourself on the back.

Specifically, it’s safe to cast any `Function(X)` to a `Function(⊥)`, for any `X`. This is better than using Dart’s all-encompassing `Function` type, because it’s more specific.

With this you can, for instance, store any unary function in a field and call it dynamically, to get past static errors and replace them with runtime errors if you made a mistake:

```
Function(⊥) f;
f = (int x) => x + 1;

// the validity of 123 as an argument to f is checked at runtime
(f as dynamic)(123);
```


This is a neat trick to help you in a pinch.

Now we can talk about `Null`.

## Null in Dart 2

The conceptual “bottom” type (a type which is a subtype of all types) exists in Dart, but that’s not all. Such a value also exists in Dart 2! In Dart we call it `Null`, and that value is — you guessed it — `null`.

Since I can make anything `null`(/`Null`), the absurd type is not so absurd in Dart. Which makes it a bit complicated.

Note: The value `null`, of course, is not a `Car`, and it’s not a `Person`. And we do get requests for non-nullable types in Dart. So if we do make such a change to Dart, we’ll need a new bottom type, likely named something to the effect of `Nothing`, and it will be a truer bottom type at that.

Not only does `Null` have all the same absurd usages as the bottom type, but it also has an escape hatch. If you ever really need to return from a function that can’t return, or call a function that can’t be called, we give you an out! You can pass `null` in there! It would be, honestly, a bit unfair of us to do otherwise, when you look at the whole picture.

It does give a whole lot of caveats, though, to an otherwise simple declaration:

```
Null nothing() => null;
```


`Null` is the most specific type for `foo()`, so it’s a logical choice and a good starting place. The analyzer is also kind enough to warn you if you call methods on it that don’t exist:

```
nothing().x; // error! No member x on Null
```


But this may give a false illusion of safety.

```
nothing().toString(); // no error: Null defines toString()
Foo foo = nothing(); // no error: foo will become null

// Acceptable for all parameter types in f(x),
// runtime errors if f(x) expects non-null
f(nothing());
```


If your goal is for `nothing()` to be a synonym for `null`, then this would be the behavior you want, and `Null` is the correct type for your function that returns `null`.

There were good reasons for suggesting `Future&lt;Null&gt;`, and it worked while we were coming up with the new `void` semantics. However, it has the same holes:

```
(await futureNull()).toString(); // no error!
Foo foo = await futureNull(); // no error!
```


Essentially, by making some function `f()` return a `Future&lt;Null&gt;`, you are making `await f()` a synonym of `null` in your program! That’s dangerous because you can use `null` as if it were absolutely anything, absolutely any type. I don’t think that’s what most people want.

<DashImage src="images/04NDBhLva40BBuX0f.jpg" />


Why else might you use `Future&lt;Null&gt;` instead of `Future&lt;void&gt;`? It all goes back to that mind-boggling bottom type. You might consider `Future&lt;Null&gt;` for futures that must be awaitable but that never complete, or that always complete with an error. This is directly comparable to why a function would return `Null`.

The same logic applies to `Stream&lt;Null&gt;`: Use this for a `Stream` that never sends any events. This is directly comparable to why a read-only empty list may be typed as `List&lt;Null&gt;`.

Some trickier types to provide a guideline for are `StreamController&lt;Null&gt;` and `Sink&lt;Null&gt;`. These are comparable to functions. The most sound reason to use these types is to say that they should never be used. The next most sound is that you would like them to accept only synonyms of `Null`, which is reasonable only if you don’t have `void_checks` turned on.

Imagine that Dart did not have `null` as an escape hatch for all values. Would you want to make a type `Sink&lt;⊥&gt;` that can only accept events from a `Stream&lt;⊥&gt;`, which itself never broadcasts an event? If the answer is yes, then go for it and make a `Sink&lt;Null&gt;`.

All of these usages have weak guarantees because the value `null` itself is an escape hatch for why you otherwise would be most likely to use the `Null` type itself. However, do not make the mistake of thinking that the *value* is the escape hatch itself, rather than the bunker. One is safe and sturdy and the other is to save you the effort of digging upwards through reinforced concrete when the bunker catches on fire with you in it.

<DashImage src="images/0yepcr98D1YlpsRJF.jpg" />


In summary, here are the main uses of typing something as `Null`:

* As a synonym for `null`, usable everywhere as everything

* As a placeholder for execution your program will never reach

* As a container that must stay empty so that it can masquerade as any type

* As an output with no inputs

## Final comparison

*If you reached this point of the article, you deserve some sort of recompense — reach out to me and I’ll see about buying you a beer next time you’re free in Portland OR. :)*

I talked a lot about the bottom type, but I didn’t get into its opposite at all, Top. The top type is, as you would expect, the polar opposite of the bottom type. And while Dart’s name for the bottom type is `Null`, Dart’s name for the top type is one of `dynamic`, `Object`, and `void` (three heads of the same coin).

It may seem strange that words like “nothing” and “empty” in English can mean two such dissimilar things in type theory. Both are suitable descriptions of the exact opposite top and bottom types, and therefore, of `Null` and `void`. It may seem strange that two opposite types are appealing candidates for the same job! It may seem frustrating that Dart has so many weird quirks and edge cases, now that you’re reading up on which to use.

<DashImage src="images/0ybPT9jlu0yGAnu2v.jpg" />


Our mistake, I think, was in ever recommending `Null` to be used like `void` in the first place. It would at the time have been a disservice to users to withhold what was useful advice, given Dart 1 semantics. But we accidentally made a *very* esoteric type *very* commonly used.

Well you’ve read the article now. What do you think? Do you expect to come across a valid use for `Null` any time soon? Do you have a firm understanding of where it’s useful?

And more importantly, can you help us spread the good news that `void` is here to make it all simpler?