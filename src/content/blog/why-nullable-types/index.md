---
title: "Why nullable types?"
description: "Null in Dart code indicates that a variable has no value, but some languages don’t allow null. Learn why both approaches work."
publishDate: 2020-12-07
author: "munificent"
image: images/1ihpy1Ngzg7SczCKkuh_WhQ.jpeg
category: other
tags:
  - dart
  - programming-languages
  - developer-experience
---


A few weeks ago, we announced Dart null safety beta, a major productivity feature intended to help you avoid null errors. Speaking of null values, in the /r/dart_lang subreddit [a user recently asked](https://www.reddit.com/r/dartlang/comments/jruhji/why_does_nnbd_dart_still_have_null/gbwi364/):
> But why do we even still have/want null values? Why not get rid of it completely? I’m currently also playing around with Rust and it doesn’t have null at all. So it seems to be possible to live without it.

I love this question. Why *not* get rid of `null` completely? This article is an expanded version of what I answered on that thread.

The short answer is that, yes, it is entirely possible to live without `null`, and languages like Rust do. But programmers *do* use `null`, so before we can take it away, we need to understand why it’s used. What is `null` usually *doing* when we use it in languages that do have it?

It turns out that `null` is typically used to represent the *absence* of a value, which is eminently useful. Some people don’t have middle names. Some mailing addresses don’t have apartment numbers. Some monsters don’t have any treasure to drop when you slay them.

In cases like that, we want a way to express, “This variable could have a value of type X, or it may have no value at all.” The question then is how do we model that?

One option is to say that a variable can contain a value of the expected type, or it can contain the magic value `null`. If we try to use the value when it’s `null`, we get a runtime failure. This is what Dart did before null safety, what SQL does, what Java does for non-primitive types, and what C# does for class types.

But failing at runtime sucks. It means our users experience the bug. We programmers would rather find those failures before they do. In fact, we’d be happy if we could find the bugs even before *we* ran our program. So how do we model the absence of a value in a way that the type system understands? In other words, how do we give “potentially absent” values and “definitely present” values different static types?

There are two main solutions:

1. Use an option or maybe type

1. Use a nullable type

## Solution 1: Option types

This is what [ML](https://en.wikipedia.org/wiki/ML_(programming_language)) and most functional languages derived from ML (including Rust, Scala, and Swift) do. When we know we will definitely have a value, we just use the underlying type. If we write `int` it means, “There is definitely an integer here.”

To express a potentially absent value, we *wrap* the underlying type in an [option type](https://en.wikipedia.org/wiki/Option_type). So `Option&lt;int&gt;` represents a value that might be an integer or might be nothing at all. It’s like a collection type that can contain zero or one item.

From the type system’s perspective, there is no direction relationship between `int` and `Option&lt;int&gt;`. Treating these as distinct types means we can’t accidentally pass a potentially-absent `Option&lt;int&gt;` to something expecting a real `int`. We also can’t accidentally try to use an `Option&lt;int&gt;` as if it were an integer since it doesn’t support any of those operations. We can’t perform arithmetic on an `Option&lt;int&gt;` any more than we could on a `List&lt;int&gt;`.

To create a value of an option type from a present value of the underlying type (say `3`), you construct the option like `Some(3)`. To create an option type when the value is absent, you write something like `None()`.

In order to use a potentially absent integer stored in an `Option&lt;int&gt;`, we have to first check and see if the value is there. If so, we can extract the integer from the option and use it, just like reading a value out of a collection. Languages that have option types usually also have nice [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching) syntax, which gives us an elegant way to check if the value is there and use it if so.

## Solution 2: Nullable types

The other option (heh), is what Kotlin, TypeScript, and now Dart do. [Nullable types](https://en.wikipedia.org/wiki/Nullable_type) are a special case of [union types](https://en.wikipedia.org/wiki/Union_type).

(Tangent: The naming gets really confusing here. Option types — what ML and friends do above — are a special case of [algebraic datatypes](https://en.wikipedia.org/wiki/Algebraic_data_type). Another name for algebraic datatypes is “discriminated unions”. But, despite “union” being in the name, “discriminated unions” are quite different from “union types”. As Phil Karlton said, there are only two hard problems in computer science: cache invalidation and naming things.)

Similar to the option type approach, we use the underlying type to represent a definitely present value. So `int` again means we absolutely have an integer. If we want a potentially absent integer, we instead use the `int?` nullable type. The little question mark is syntactic sugar for writing what is essentially a union type like `int | Null`.

Just like with option types, a nullable type does not support the same operations as the underlying type. The type system won’t let us try to perform arithmetic on a nullable `int` because that isn’t safe. Likewise, we can’t pass a nullable integer to something that requires an actual integer.

However, the type system is a little more flexible than with option types. The type system understands that a union type is a supertype of its branches. In other words, `int` is a subtype of `int?`. That means we *can* pass a definitely-present-integer to something that expects a maybe-present-integer since that’s safe to do. It’s an upcast, just like we can pass a `String` to a function that takes `Object`. Dart only prohibits us from going the other way—from nullable to non-nullable—because that would be a downcast and those could fail.

When we have a value of a nullable type and we want to see if there is an actual value or `null` there, we check the value imperatively just like we would naturally do in C or Java:

```
`foo(int? i) {
  if (i != null) {
    print(i + 1);
  }
}`
```


The language then uses [flow analysis](https://en.wikipedia.org/wiki/Control-flow_graph) to determine which parts of the program are guarded behind those checks. The analysis determines that code can only be reached if the variable is not `null`, so inside those regions, the type system tightens the variable’s type to be non-nullable. So, here, it treats `i` as having type `int` inside the `if` statement.

## Which solution should a language take?

So when we on the Dart team decide to make the language handle null in a safer way, how should we go about choosing solution 1 or 2? We can start by observing our users. How do they want to write code that checks for absent values? In functional languages, pattern matching is one of the primary control flow structures, and users there are very comfortable with it. Using option types and pattern matching is natural in that style.

In imperative languages derived from C, code like my previous example is the idiomatic way to check for `null`. Using flow analysis and nullable types makes that familiar code work correctly and safely. In fact, with Dart, we’ve found that *most existing code is already statically null safe with the new type system* because the new flow analysis correctly analyzes the already written code.

(This is in some ways not a surprise. *Most* code is already *dynamically* correct with regards to handling `null`. If it wasn’t, it would be crashing all the time. Much of the job is simply making the type system smart enough to see that that code is already correct, so that the user’s attention is drawn to the few bits that are *not*.)

So if our goal is to maximize familiarity and user comfort (which *are* important criteria in language design), we should just follow the path that our language’s control flow structures lay out for us.

## Representing absence and presence

There is a deeper way to approach this question based on differences between how option types and nullable types are represented. That representation difference forces a few key trade-offs on us, and those might lean us in one direction or the other.

With the first approach, a value of option type has a runtime representation distinct from the underlying value. Say we chose option types in Dart, and you created one and then upcast it to `Object`:

```
`var optionalInt = Some(3);
Object obj = optionalInt;
print(obj is int); // false`
```


Note the last line. An `Option&lt;int&gt;` value, even when present, is *not* the same kind of thing as a value of the underlying type. `Some(3)` and `3` are distinct, distinguishable values.

That’s not how nullable types work:

```
`var nullableInt = 3 as int?;
Object obj = nullableInt;
print(obj is int); // true`
```


Nullable types exist in the *static type system*, but the runtime representation of values uses the underlying type. If you have a “nullable 3”, at runtime it’s just the number `3`. If you have an absent value of some nullable type, at runtime you just have the solitary magic value `null`.

You can ask if a value is of a nullable type:

```
`print(obj is int?);`
```


But the `is int?` expression is equivalent to:

```
`print(obj is int || obj is Null);`
```


## Nested optionals

Since values of option types are different from the underlying type, this gives us an important capability: Option types can nest.

Let’s say we have some network service that gives out resource strings when given a request with some integer ID. Some resources are not present and the server will respond with no data for that ID. Since hitting the network is slow, we want to locally cache the results of requests we’ve already performed.

In Dart before null safety, we might use a map like so:

```
`Map<int, String> cache;`
```


So before making a network request for some ID, we use the subscript operator on the cache map to look up the resource’s ID. That operator is defined on `Map` to return `null` if the key is not present. But the key could also be present and associated with a `null` value. If we do a lookup and get back `null`, it could mean either:

* The key was not present in the map. This means we haven’t done the request yet, so we should ask the server to look up the resource.

* The key was present and associated with `null`. This means we already did ask the server, found that the resource wasn’t present, and stored that in the cache. We should use that result and not query the server again.

Because there’s only a single `null` value in the entire system, we don’t have a runtime representation that can distinguish these two cases. This is why the `Map` class has a separate `containsKey()` method. That API provides a way to distinguish these two cases.

Now, if Dart were built around option types, the cache would look like:

```
`Map<int, Option<String>> cache;`
```


And the subscript operator would return an optional value:

```
`class Map<K, V> {
  Option<V> operator [](K key) => ...
  ...
}`
```


In the case of our `Map&lt;int, Option&lt;String&gt;&gt;`, that means the return type is `Option&lt;Option&lt;String&gt;&gt;`. Note the nesting! Now, when we look up a key in the cache, we can get a few different results:

* A `Some(Some(string))` means the resource did exist on the server, and we have it in the cache now.

* A `Some(None())` means we did ask the server and the resource was not there, so we have cached the fact that the resource doesn’t exist.

* A `None()` means the cache does not contain this ID at all.

We can distinguish the last two cases because options always wrap their underlying value in some extra state. At runtime, we can determine how many layers there are and peel them off individually.

Nullable types, since they have no explicit runtime representation, are implicitly flattened. So `int?` and `int??` are equivalent types to the type system and have equivalent sets of values at runtime. This is why fans of option types describe them as “more expressive”: because optional types give you a way to represent more kinds of values than nullable types do.

## Nullable substitution

Another way of thinking about “expressiveness” is how much *effort* it takes for the user to express what they actually want to express. A language is more expressive if the user can reach their goal while jumping through fewer hoops.

An advantage of having no distinct representation for nullable types is that values can flow from non-nullable to nullable contexts much more easily. Let’s say you have a function that accepts an optional integer parameter. With option types, the signature would look something like:

```
`takesMaybeInt(Option<int> optionalInt) {}`
```


To call this function with a known integer, it must be wrapped in an option first:

```
`takesMaybeInt(Some(3));`
```


With nullable types, since there is no representation difference, you can pass a value of the underlying type directly:

```
`takesMaybeInt(3);`
```


You get this flexibility everywhere in the type system. You can override a method that returns a nullable type to return a non-nullable type. You can pass a `List&lt;int&gt;` to a function that wants a `List&lt;int?&gt;`.

So while nullable types lose the ability to nest and represent multiple distinct *kinds* of “absence”, in return they make it much easier to work with the one blessed notion of `null`.

## Nullability for Dart

Dart is an imperative language where people already use `if` statements to check for absent values at runtime. It’s also an object-oriented language where we already have a special `null` value with its own runtime representation. So solution 2, nullable types, was the natural answer for us. It lets our users write the kind of code they are familiar with, and takes advantage of how the runtime already represents values.

For more information about nullability in Dart, check out the [Where to learn more](https://dart.dev/null-safety#where-to-learn-more) section of the [Dart null safety docs](https://dart.dev/null-safety).

<DashImage src="images/1ihpy1Ngzg7SczCKkuh_WhQ.jpeg" alt="One of these puzzle pieces is null." caption="One of these puzzle pieces is null." />
