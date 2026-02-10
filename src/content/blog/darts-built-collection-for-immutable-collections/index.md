---
title: "Dart’s built_collection for Immutable Collections"
description: "A month ago I spoke at the Dart Developer Summit about object models with source_gen (video). I mentioned some packages and techniques that…"
publishDate: 2016-11-24
author: "davidmorgan"
category: other
tags:
  - programming
  - dartlang
  - dart
  - immutability
  - clean-code
---


A month ago I spoke at the [Dart Developer Summit](https://events.dartlang.org/2016/summit/) about [object models with source_gen (video)](https://www.youtube.com/watch?v=TMeJxWltoVo). I mentioned some packages and techniques that are highly deserving of a closer look, so here I am to tell the full story.

First up: [built_collection](https://github.com/google/built_collection.dart).

The built_collection package provides SDK-like collections with immutability. Immutablity for:

* Simplicity, convenience. An immutable collection can be passed around without worrying about who might modify it.

* Performance. Mutability leads to expensive patterns like defensive copying and change detection.

The fact that built_collection is supposed to be *convenient* poses some challenges for the API. Let’s take a look. First, an immutable list:

```
var list = new BuiltList<int>([1, 2, 3]);
```


Now I’d like to add a value to it. Of course, it’s immutable, so I can’t; what I actually want is to create a *new* list with an additional value tacked onto the end.

There is where we encounter the [builder pattern](https://en.wikipedia.org/wiki/Builder_pattern) for which the package is named. You get a new list by converting to a builder, making modifications, then building:

```
var builder = list.toBuilder();
builder.add(4);
var newList = builder.build();
```


Builders are usually used inline, so let’s do that:

```
var newList = (list.toBuilder()..add(4)).build()
```


This is as far as the builder pattern usually goes, but Dart has [lambdas](https://www.dartlang.org/guides/language/language-tour#anonymous-functions), so we can do better:

```
var newList = list.rebuild((b) => b.add(4));
```


What we find is that [method cascading](https://en.wikipedia.org/wiki/Method_cascading) in Dart makes the builder pattern very powerful. You can almost always do what you want inline:

```
var newList = list.rebuild((b) => b
    ..add(4)
    ..addAll([7, 6, 5])
    ..sort()
    ..remove(1));
```


So, as hoped — built_collection is convenient.

Let’s talk about performance.

The Built Collections are currently optimized for code that has an update/publish cycle. That means: collections are converted to a builder, updated, built, then published — a reference is passed — for the rest of the code to consume.

This fits typical use in web applications, for example Angular apps. There, a user interaction or RPC response triggers an update. The data model is rebuilt before being published for rendering.

The Built Collections are not yet optimized for very frequent rebuilds, which would require implementing on top of [carefully chosen data structures](https://en.wikipedia.org/wiki/Hash_array_mapped_trie). If you have a use case for this, please get in touch — it is part of the design of Built Collections that this will be possible when it’s needed.

Beyond just immutability, built_collection helps you to write good, correct code. A whole bundle of properties helps here:

* Built Collections must be created with explicit type parameters; there is no such thing as a BuiltList&lt;dynamic&gt;.

```
new BuiltList([1, 2, 3]);     // Throws an exception!
new BuiltList<int>([1, 2, 3]); // Better.
```


* Values must be non-null; nulls cannot be added to a Built Collection.

```
new BuiltList([1, 2, null]);  // Throws an exception!
```


* Built Collections are comparable and hashable. This means you can put them in maps, sets, and multimaps, creating exactly the collections to match your data.

These properties are particularly suited to collections of *business objects*: in a shopping web application, for example, to hold the current contents of the user’s shopping cart.

That was a quick overview of what built_collection provides and why; more information is available on the [github page](https://github.com/google/built_collection.dart). To make best use of immutable collections, though, you need immutable classes. Next up: [built_value](http://github.com/google/built_value.dart)!

Edit: [next article](https://medium.com/@davidmorgan_14314/darts-built-value-for-immutable-object-models-83e2497922d4#.7uhmlrcz3).