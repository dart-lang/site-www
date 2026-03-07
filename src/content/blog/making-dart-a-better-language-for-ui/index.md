---
title: "Making Dart a Better Language for UI"
description: "On the Dart team, we are busy implementing a handful of language changes that I’m really excited about. They all relate to collection…"
publishDate: 2019-03-19
author: munificent
image: images/14PIeARfthvxtn0cvBB5MPw.jpeg
category: other
tags:
  - programming
  - dart
  - flutter
  - programming-languages
  - ui
layout: blog
---


<DashImage src="images/14PIeARfthvxtn0cvBB5MPw.jpeg" />


On the [Dart](https://www.dartlang.org/) team, we are busy implementing a handful of language changes that I’m really excited about. They all relate to collection literals, the built-in syntax for creating lists, maps, and sets:

```dart
var someList = [1, 2, 3, 4];
var someMap = {key: 1, another: 2};
var someSet = {1, 2, 3, 4};
```

If you aren’t writing Dart code today, this may not be super relevant to you and your Life Goals, but I hope you’ll keep reading anyway. I think the features are interesting in their own right, and the execution model that underlies them might stretch your brain in useful and/or engaging ways. I always find it fun to learn about new language stuff, even in languages I don’t currently use.

## How Flutter Users Build Their UI

If you heard anything about Dart in the past year, it was probably in the context of [Flutter](https://flutter.dev/). If that name doesn’t ring a bell, Flutter is a UI framework for building multi-platform mobile apps. I can’t do it justice here, but click the link and it will answer every question in your heart. (Well, at least every question regarding Flutter. It won’t tell you why that high school crush never called you back.)

A key choice any UI framework makes is how the basic visual UI elements — buttons, colors, text, layout, etc. — are defined. Do you author these in some sort of separate “template” or “markup” format or right in the executable code where the UI’s behavior is defined? Every fifteen years or so, the industry flips on which answer is the right one.

[Angular](https://angular.io/) and most web frameworks follow in the footsteps of HTML and use templates. [React](https://reactjs.org/) puts the UI inside your JavaScript, but also adds an embedded DSL called [JSX](https://reactjs.org/docs/introducing-jsx.html) to make it look like HTML. Trying to have its cake and eat it too, I guess, though not everyone would describe HTML as particularly dessert-like.

Flutter puts the UI right into your Dart code, using normal Dart expression syntax. Behold:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(title: Text('Welcome to Flutter')),
        body: Column(
          children: [
            Text('Hello World'),
            Text('This is Flutter'),
            Text('Written in Dart')
          ]
        )
      )
    );
  }
}
```

Everything after that `return` keyword is one big nested expression that produces a chunk of user interface. Using Dart for this has a handful of material benefits:

* **There’s only one language to learn: Dart.** Since Dart was designed to be familiar to people coming from other languages, that’s hopefully not too difficult.

* **You can use all of the abstraction features of a general-purpose programming language when building your UI.** Hoist pieces out into reusable functions. Give those functions parameters to vary the generated UI. Store things in local variables. You do you.

* **You never hit an expressiveness wall and have to port to a different language.** If you’ve ever used a declarative language, you’ve probably run into the situation where you hit the limit of what it can actually express. At that point, you either abandon what you were trying to do, or laboriously rewrite the whole thing in a lower level, usually imperative language. Since you’re already *in* a full-featured language with Dart, you never hit that wall and your UI code smoothly grows in sophistication.

The main challenge, of course, and the reason why people make declarative languages in the first place, is that defining stuff in an imperative language can be really tedious and difficult to read.

Imagine that instead of this little bit of HTML:

```html
<p>I am an <strong>exciting</strong> paragraph!</p>
```

You had to write something like:

```java
doc.beginTag("p");
doc.appendText("I am an ");
doc.beginTag("strong");
doc.appendText("exciting");
doc.endTag("strong");
doc.appendText("paragraph!");
doc.endTag("p");
```

Fortunately, modern languages and APIs aren’t quite *that* low level. Even though statements are imperative, *expressions* are pretty declarative. While the above code is gnarly, this one is about on par with HTML:

```java
p("I am an ", strong("exciting"), " paragraph!")
```

The modern reactive paradigm where you “build” your UI by constructing it from scratch as a single expression gets you pretty far. The relevant part of the Flutter example up there is just:

```dart
MaterialApp(
  title: 'Welcome to Flutter',
  home: Scaffold(
    appBar: AppBar(title: Text('Welcome to Flutter')),
    body: Column(
      children: [
        Text('Hello World'),
        Text('This is Flutter'),
        Text('Written in Dart')
      ]
    )
  )
)
```

It’s got parentheses and square brackets instead of angle brackets, but is otherwise not too far from a “markup” language. It’s surprising how well this works. Dart’s syntax is based on JavaScript, which got it from Java, which got it from C. Along the way, we added the square bracket list literal syntax and named parameters, but those are fairly minor.

C was designed for implementing command-line operating systems on the PDP-11. The fact that its notation scales not *too* badly to building graphical UIs on mobile devices is either a testament to Ritchie’s design taste, or our collective Stockholm Syndrome around C syntax. Either way, it works… mostly.

In the example here, there’s no interesting runtime *logic* required to build the UI. Everything fits nicely into a single nested expression. But let’s say, for whatever reason, you don’t want to show the “This is Flutter” part of the text on Tuesdays. (Perhaps you need to make room on screen for the “Taco Tuesday!” banner.)

There are a few ways to express that, but none of them feel as nice and declarative as the above example. Here’s one:

```dart
Widget build(BuildContext context) {
  var texts = [Text('Hello World')];
  if (!isTuesday) {
    texts.add(Text('This is Flutter'));
  }
  texts.add(Text('Written in Dart'));

  return MaterialApp(
    title: 'Welcome to Flutter',
    home: Scaffold(
      appBar: AppBar(title: Text('Welcome to Flutter')),
      body: Column(children: texts)
    )
  );
}
```

We’re a lot closer to the nasty low-level imperative code that drives people to using templates. When we looked at real Flutter code, we were sad to see a lot that looked like this. So, about a year ago, the Flutter team asked us on Dart to come up with language changes to make UI code written in Dart easier to write, read, and maintain.

## “UI as Code”

We called this initiative “[UI as code](https://github.com/munificent/ui-as-code)”, since it’s about building your UI using code. But the ultimate goal is language features that are generally applicable to as many Dart programs, Flutter or not, as possible. (If you want a lot more background, here’s [a long motivation doc](https://github.com/munificent/ui-as-code/blob/master/Motivation.md) I wrote.)

After exploring [a bunch of options](https://github.com/munificent/ui-as-code/blob/master/Choices.md), we decided to focus on a few targeted improvements around collection literals. This may not seem as sexy as jamming something like JSX into Dart (not that I’m entirely ruling that out), but it has the advantage of being much easier for users to incrementally take advantage of in their code.

Just making list literals groovier might seem to have, uh, limited impact. But, if you look at Flutter UI code like the above, it’s basically a big tree of constructor calls and list literals. List literals are a large fraction of the territory. (Heck, [entire languages](https://en.wikipedia.org/wiki/Lisp_(programming_language)) have been designed around them.) If you dig into examples where it feels like you should be able to write something declaratively but instead have to do a bunch of gross imperative mutation, it’s very often around lists.

If we can make collections better, we can make a *lot* of Dart code better. To that end, we’re adding three new features:

## Spreads

Often, when you build a list of widgets, some of those widgets are already in some *other* list. Here’s a bit of Flutter code:

```dart
Widget build(BuildContext context) {
  var conversation = buildTab2Conversation();
  var listItems = [Tab2Header()];
  listItems.addAll(conversation);
  listItems.add(buildFooter());

  return CupertinoPageScaffold(
    child: ListView(children: conversation),
  );
}
```

The `buildTab2Conversation()` method returns a list of widgets that we want to surround with the header and footer. Having to build the resulting list imperatively is a real drag. It forces the code to read "backwards" where you see a bunch of stuff mucking around with the children before you get to the code to see what they are the children *of*.

Dart has this feature called [method cascades](https://news.dartlang.org/2012/02/method-cascades-in-dart-posted-by-gilad.html) that helps somewhat. Those let you stuff a mutating method call in the middle of an expression while yielding the original object. With that, you get:

```dart
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: ListView(children: [
      Tab2Header()
    ]..addAll(buildTab2Conversation())
      ..add(buildFooter())),
  );
}
```

That’s kind of better, but it’s still pretty awkward. That trailing `..add()` to append a single item is particularly egregious. You can probably guess how we fixed this since a number of other languages already have the same solution. (&gt;90% of language design is figuring out which features to borrow from other languages.) We’re adding [a new syntax called *spreads*](https://github.com/dart-lang/language/blob/master/accepted/future-releases/spread-collections/feature-specification.md).

Inside a collection literal, a spread unpacks another collection and inserts its contents directly in place. For example:

```dart
var a = [2, 3];
var b = [5, 6];
var c = [1, ...a, 4, ...b]; // [1, 2, 3, 4, 5, 6].
```

The `...` before the list element causes its elements to be interpolated into the surrounding list. This is the same syntax JavaScript uses. Python, Ruby, and a few others use a prefix `*` for the same thing, but we felt that didn't stand out visually enough. With this feature, the Flutter example becomes:

```dart
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: ListView(children: [
      Tab2Header(),
      ...buildTab2Conversation(),
      buildFooter()
    ]),
  );
}
```

I believe this is a real improvement. All of the children of the list view are nestled snug in the one list literal. This looks nicer, and also plays nicer with type inference. With all of the elements inside the list, we can use all of them when inferring the list’s type.

I’m showing a Flutter example here, but I spent a lot of time combing through a huge corpus of Dart code to see where this syntax would be useful and it comes into play all over the place. In particular, code that builds lists of command line arguments for invoking other programs really benefits from spreads.

## Elements

Before I get into the last two features, I want to dig into what a spread actually *is*. It will seem like I’m belaboring the point, but I promise being clear on this will be helpful later. Here’s a leading question: *is a spread an expression?*

It seems like one, because it appears in a list literal in a place where an expression is expected:

```dart
var stuff = [1, ...things, 4];
```

Like an expression, you evaluate it and it produces some data. Maybe it’s an expression that evaluates to an [Iterable](https://api.dartlang.org/stable/2.2.0/dart-core/Iterable-class.html) object? But, wait, that doesn’t make sense. That’s what the expression *inside* the spread does. If you just want an expression that evaluates to an Iterable, there’s no need to put the `...` before it.

A spread doesn’t evaluate to a single Iterable object, it *unpacks* that object and evaluates to the *series* of objects produced by the Iterable. It wouldn’t be useful to then *repack* that back into some new object. But an expression always evaluates to a *single* object.

If a spread was an expression, what would it mean to use one in other places where an expression is allowed?

```dart
var wat = ...things;
```

What would this do? It doesn’t make sense to store the entire Iterable as an object in `wat`. If you wanted that, you could just omit the `...` entirely. The answer is that spreads *aren't* expressions. They are a different kind of syntactic category. Dart, like many languages, already has two big syntax groups: statements and expressions.

Statements are executed but don’t produce any result value. Instead, they are expected to have some useful side effect. They can’t be used in any context where a value is needed because it won’t give you one. That’s why, say, this is forbidden:

```dart
var wat = for (var i = 0; i < 10; i++) print(i);
```

A `for` statement doesn't produce a value, so it doesn't make sense to stuff one in a variable initializer. There *are* [languages that unify expressions and statements](https://en.wikipedia.org/wiki/Expression-oriented_programming_language) and allow code like this. They define each statement to execute in some way and *also* produce a value. But Dart isn't one of those languages.

Expressions evaluate to a single result value. You can use them in places where a value is useful. There are also “[expression statements](https://www.eskimo.com/~scs/cclass/notes/sx3a.html)” — an expression followed by a semicolon — which are statements that contain a single expression. Handy since many expressions do also happen to have side effects and are useful even when their result isn’t needed.

A spread is neither of those. A spread can evaluate to zero values (if you spread an empty collection), one value, or many. It’s its own kind of thing. A good name for this category would be “generator”. My model for this comes from [Icon](https://en.wikipedia.org/wiki/Icon_(programming_language)#Generators) where *every* expression can be a generator. But Dart already has [generator functions](https://www.dartlang.org/articles/language/beyond-async#generators) so I didn’t want to overload the term.

A spread can only appear in a place that can gracefully handle receiving zero or more values. Without completely overhauling the language’s execution model and turning it into Icon (which I find strangely appealing, but probably not practical…), there aren’t too many places that fit that constraint. Basically collection literals and maybe positional argument lists. (I wrote [a proposal for the latter](https://github.com/munificent/ui-as-code/blob/master/in-progress/parameter-freedom.md), but it’s quite complex so we aren’t doing it, at least not right now.)

That leaves inside the body of collection literals. Based on that, I call these “elements”. An element is a piece of code that when evaluated produces zero or more values. Those values are then interpolated in place into the surrounding context where they appear. So, in a list, they become a series of elements in the new list. In a map, they become a series of key/value pairs. You get the idea.

The body of a collection literal can thus contain either expressions or elements. Allowing two categories is a little confusing, but fortunately we can simplify this by saying that a collection only contains elements. Then we define an “expression element” to be an element containing a single expression. The element always produces one result — the value of the expression. Sort of like the element equivalent of an expression statement.

Right, so that’s where we are. We’ve changed collections to contain elements instead of expressions and defined two kinds of elements, spreads and expression elements. To evaluate a collection literal, you walk the elements, evaluate each one, and concatenate (or union in the case of a set) all of the resulting objects.

With that model in mind, we can walk through the other two new features:

## Collection If

Write any Flutter code and you pretty quickly run into cases where the tree of widgets you want to build changes based on some condition. Say we have:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Later, we decide that we want to use a different search button on Android. You can already do that using a conditional expression:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      isAndroid
          ? TextButton("Search")
          : IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

This works OK, though I’ve never found C’s conditional operator very easy to read. Often, though, you don’t want to *swap out* a widget based on a condition, you want to simply *omit* one. Let’s say you don’t want to show a search box on Android at all. Today, Flutter users tend to use one of two patterns. This is one:

```dart
Widget build(BuildContext context) {
  var children = [
    IconButton(icon: Icon(Icons.menu)),
    Expanded(child: title)
  ];

  if (!isAndroid) {
    children.add(IconButton(icon: Icon(Icons.search)));
  }

  return Row(children: children);
}
```

It forces you to rearrange the entire function by hoisting the child list out and building it imperatively before you use it. The other pattern looks like:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      !isAndroid ? IconButton(icon: Icon(Icons.search)) : null,
    ].where((widget) => widget != null).toList(),
  );
}
```

This uses a conditional expression which sometimes produces a `null` and then filters that `null` out of the resulting list. Props to whoever came up with this, but it's not something any user should have to write to accomplish such a simple task. Simple problems should have simple solutions, and small conceptual changes to your program shouldn't require large textual changes.

Here’s the new thing. For the first example where we want a different button on Android, it looks like this:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      if (isAndroid)
        TextButton("Search")
      else
        IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Instead of `?:`, it uses the familiar `if` and `else` syntax. This is literally just a few tokens different from the existing conditional expression, so it doesn't seem to carry its weight. The more interesting case is when we want to *omit* the button on Android:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      if (!isAndroid)
        IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Note there’s no `else` clause. Both of these examples look pretty similar to languages like Ruby where `if` is an expression. But an expression must always evaluate to a value, even when the condition is false. In Ruby, in that case, it implicitly evaluates to `nil`.

But that’s *not* what you want here. You don’t want to end up with a `null` element in your list of child widgets. That's why the conditional expression example up there had to use the annoying `where()` to filter it out. Fortunately, that's not a problem here. Because `if` inside a collection isn't an *expression*. It's an *element*.

Now you see why I was dragging you through all that stuff with spreads. Elements give us the foundation to have an `if`syntax that lets you completely omit an element from a collection. The `if` element produces a single value if the condition is true, or if there is an `else` case. If the condition is false and there is no `else` clause, it simply produces no values at all.

I think this behavior is really useful, but it’s also confusing if you look at the code and expect `if` to act like a simple expression.

## Collection For

The previous feature takes an existing bit of Dart statement syntax and repurposes it to do something useful in the context of a collection. Are there any other statement forms worth taking?

Most don’t make sense. Sticking a `return` statement in there wouldn't do anything useful since it would just exit the surrounding function. `while` isn't very useful either. In order to exit a `while` loop, the body typically contains a `break`, `return`, or some kind of side effect like an assignment. But that implies the body contains *statements*, which isn't what we want. The goal is to make collections more *expressive*, not more *imperative*.

I dug through a bunch of collection literals in existing code looking for patterns I thought could be improved by new syntax. The main one, by far, was `if`. But I saw a number of places that I thought could be improved by `for`. Here's a slightly cleaned up example of some code I found:

```dart
var command = [
  engineDartPath,
  frontendServer,
];
for (var root in fileSystemRoots) {
  command.add("--filesystem-root=$root");
}
for (var entryPoint in entryPoints) {
  command.add("$entryPoint.json");
}
command.add(mainPath);
```

All of the `command.add()` stuff feels needlessly imperative. If we allow `for` loops inside a collection literal, this becomes:

```dart
var command = [
  engineDartPath,
  frontendServer,
  for (var root in fileSystemRoots) "--filesystem-root=$root",
  for (var entryPoint in entryPoints) "lib/$entryPoint",
  mainPath
];
```

## Composing Elements

Given that we are already adding spreads, the `for` syntax doesn't seem very compelling. Couldn't you accomplish the same thing using spread with some combination of higher-order methods on iterables? Yes, you can. You'd get something like:

```dart
var command = [
  engineDartPath,
  frontendServer,
  ...fileSystemRoots.map((root) => "--filesystem-root=$root"),
  ...entryPoints.map((entryPoint) => "lib/$entryPoint"),
  mainPath
];
```

This does work and is fine for some use cases. Let’s consider a slightly different example. Say we only want to include an entry point if a corresponding JSON file exists. That means we’re not doing a simple 1–1 mapping. Using only spreads, we get something like:

```dart
var command = [
  engineDartPath,
  frontendServer,
  ...fileSystemRoots.map((root) => "--filesystem-root=$root"),
  ...entryPoints
      .where((entryPoint) => fileExists("lib/$entryPoint.json"))
      .map((entryPoint) => "lib/$entryPoint"),
  mainPath
];
```

This works too. But it starts to get harder and harder to translate the simple “if the file exists, do this” logic to a stream-based, higher-order functional style. There’s always some combination of `map()`, `where()` and maybe `transform()` that does the job, but it can feel like translating a haiku into Reverse Polish Notation.

There is a cleaner solution, and it involves a key question: What is the *body* of these new `if` and `for` elements? In the examples I've shown you so far, it's always an expression. But there's no need to restrict it to just that. Instead, we allow any element to go there. In other words, all three of these new features can be composed freely. The above code can be expressed like:

```dart
var command = [
  engineDartPath,
  frontendServer,
  for (var root in fileSystemRoots) "--filesystem-root=$root",
  for (var entryPoint in entryPoints)
    if (fileExists("lib/$entryPoint.json")) "lib/$entryPoint",
  mainPath
];
```

A simple `if` inside a `for`, just like you'd do if you were writing imperative statements. The semantics for composing elements turn out to be pretty obvious:

* An `if` element produces all of the values produced by its then clause if the condition is true, otherwise it produces all of the elements of the "else" clause. If there is no "else", it produces no elements.

* A `for` element produces the concatenation of all of the values produced by its body element each time the body is executed.

This enables some patterns that I think are cool. An obvious problem you run into is wanting to include or omit *multiple* values based on a single condition. So, say in our previous example we wanted to skip both the title and the search box on Android. You can do that by wrapping a spread in an `if`:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      if (!isAndroid) ...[
        Expanded(child: title),
        IconButton(icon: Icon(Icons.search)),
      ]
    ],
  );
}
```

The spread is necessary here to unpack the inner list. Otherwise, when not on Android, you’d include the entire inner list as a single value. (We considered implicitly flattening in cases like this based on static types, but that gets really dubious when you think about how things like a `List&lt;Object&gt;` should behave.)

You can think of spreading a list literal as the element equivalent of a curly block for statements — it lets you put multiple elements in a place where only one is expected. (If you’re familiar with the [comma operator](https://en.wikipedia.org/wiki/Comma_operator), that’s essentially the analogous form for expressions. Parallels everywhere.)

Using `for` and `if` in an empty collection literal gives you a syntax not too far from the special "list comprehension" syntax supported by some other languages like Python:

```dart
[for (var i = 1; i <= 5; i++) if (i.isOdd) i * i] // [1, 9, 25].
```

You can even nest `for`:

```dart
[for (var x in hor) for (var y in vert) Point(x, y)]
```

This builds a list containing the [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product) of all of the points in the given `hor` and `vert` rectangle.

Also, these new features compose across collection types. I’ve been using lists as the example because they come up most often, but all of these features work inside maps and sets too. The only difference is that with sets, duplicates get implicitly discarded. And in maps, instead of having primitive expression elements, the basic element is a key/value pair. For example, this:

```dart
Map<String, WidgetBuilder>.fromIterable(
  allGalleryDemos.where((demo) => demo.exists),
  key: (demo) => '${demo.routeName}',
  value: (demo) => demo.buildRoute,
);
```

Can be rewritten as:

```dart
{
  for (var demo in allGalleryDemos)
    if (demo.exists) '${demo.routeName}': demo.buildRoute,
};
```

One real concern we have with all of these features is that we’re essentially giving you new ways to express things you can already express today. This has a cost because it means users need to spend brain juice [deciding *which* feature to use](https://en.wikipedia.org/wiki/Hick%27s_law), and when reading others’ code, they may spend time questioning why one option was chosen over the other. There are simply more features to learn and the language is bigger.

We spent a lot of time [agonizing over this](https://github.com/munificent/ui-as-code/blob/master/Choices.md). Sometimes, simply doing nothing is the best design. Simplicity has a lot of value, and it’s rare that you get the chance to make a language simpler over time. However, after looking at a lot of code and working with a delightful UX researcher on a study, we’re fairly confident that these features are lightweight and useful enough to carry their weight.

As with any language change, you never really know how it will work out until it gets into the hands of users. These features should fall into your grasp in the upcoming Dart 2.3 release, and I’m really excited to see what you make of them.