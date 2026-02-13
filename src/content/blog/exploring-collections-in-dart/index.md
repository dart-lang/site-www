---
title: "Exploring collections in Dart"
description: "If you have ever called add(), addAll(), map(), or toList() to build a list or map, you might want to check out collection if, collection…"
publishDate: 2020-09-15
author: "johnpryan"
image: images/1NLasdGsxG6bBzWYfe_9UJA.jpeg
category: other
tags:
  - dart
  - data-structures
  - programming-languages
---


<DashImage src="images/1NLasdGsxG6bBzWYfe_9UJA.jpeg" />


If you have ever called `add()`, `addAll()`, `map()`, or `toList()` to build a list or map, you might want to check out *collection if*, *collection for*, and *spreads*. Last year, Dart [added these features in version 2.3](https://medium.com/dartlang/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff).

In this article, we’ll look at collections, explore these new features, and see some interesting examples. By mastering these features, you can make your code more succinct and easier to read.

## Collections

First, we need to understand what a collection is. A [collection](https://api.dart.dev/stable/dart-core/dart-core-library.html#collections) is an object that contains other objects. For example:

* **List**: an ordered collection of objects with a length (also called an *array*)

* **Set**: an unordered collection of unique objects

* **Map**: an unordered collection of key-value pairs

* **Queue**: an ordered collection that can add/remove objects on both ends

* **SplayTreeMap**: an ordered collection of key-value pairs based on a self-balancing binary tree

These types are available in the [dart:collection](https://api.dart.dev/stable/dart-collection/dart-collection-library.html) package. For even more collection types, check out [package:collection](https://pub.dev/packages/collection) on pub.dev.

Each of these collection types implements [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html), which provides common behavior like running a function on each object in the collection, getting the first object, determining the length of the collection, and more.

## Collection literals

Dart supports syntax for constructing three types of collections: list literals (`[]`), map literals (`{}`) and set literals (also `{}`).

Here’s a list literal:

```
List<String> getArtists() {
  return [
    'Picasso',
    'Warhol',
    'Monet',
  ];
}
```


Here’s a map literal:

```
Map<String, String> getArtistsByPainting {
  return {
    'The Old Guitarist': 'Picasso',
    'Orange Prince': 'Warhol',
    'The Water Lily Pond': 'Monet',
  };
}
```


And here’s a set literal, added in Dart 2.3:

```
Set<String> getArtistsSet() {
  return {
    'Picasso',
    'Warhol',
    'Monet',
  };
}
```


If you’re wondering why maps and sets can use the same `{}` syntax, it’s because Dart uses [type inference](https://dart.dev/guides/language/type-system#type-inference) to differentiate. The type system determines the type based on the type of parameters `a` and `b`. It can usually determine this based on the contents—for example, `{1}` is obviously a `Set`, and `{1: 2}` is obviously a `Map`.
> **Note:** Using `{}` constructs a map by default. To create a set, you can use a generic type annotation: `&lt;String&gt;{}`. Using two generic type parameters creates a map: `&lt;String, String&gt;{}`.

## Types of elements

Each item in a collection literal is usually a value or an expression, but can also be one of these new features: a *collection if*, *collection for*, or *spread*. All of these are called *elements*.

Each element unpacks zero or more items and puts them in the surrounding collection. For example, a string literal (say, `"oatmeal"`) results in one item, but a *collection for* unpacks 0 or more items. These features can also be combined in interesting ways, as we’ll explore below.

### Spreads

A *spread* takes a collection (for example, a list) and puts its contents into the surrounding collection:

```
List<String> combineLists(List<String> a, List<String> b) {
  return [
    ...a,
    ...b,
  ];
}
```


The preceding code is equivalent to this:

```
List<String> combineLists(List<String> a, List<String> b) {
  var list = [];
  list.addAll(a);
  list.addAll(b);
  return list;
}
```


You can also use spreads in map and set literals:

```
Map<String, String> combineMaps(Map<String, String> a, Map<String, String> b) {
  return {
    ...a,
    ...b,
  };
}

Set<String> combineSets(Set<String> a, Set<String> b) {
  return {
    ...a,
    ...b,
  };
}
```


In both maps and sets, the contents of `b` overwrite the contents in `a` when there’s a conflict. For example, calling `combineMaps({'foo': 'bar'}, {'foo': 'baz'})` results in a map containing `{'foo': 'baz'}`.

### Null-aware spreads (`…?`)

A *null-aware spread* adds the contents to the collection only if the expression after the operator is non-null:

```
List<String> combineIfExists(List<String> a, List<String> b) {
  return [
    ...?a,
    ...?b,
  ];
}

void main() {
  var result = combineIfExists(['foo'], null);
  print(result); // [foo]
}
```


### Collection if

Use the `if`, `else`, and `else if` keywords to add something to a collection based on a condition. Here’s an example of using *collection if*:

```
class Article {
  String title;
  DateTime date;

  Article(this.title, this.date);

  String toString() {
    return [
      if (title != null) title,
      date.toString(),
    ].join(', ');
  }
}
```


The `else` keyword can be added on the end:

```
String toString() {
  return [
     if (title != null) title else '(no title)',
  ].join(', ');
}
```


Notice where the comma is. The comma can’t be after `title` because the `else` is part of the same element. Keeping the `if` and `else` together before the comma is what keeps them separate from the next element in the collection.

Adding an `else if` works too:

```
String toString() {
  return [
    if (title != null) title else '(no title)',
    if (date == null)
      '(no date)'
    else if (date.year == DateTime.now().year)
      'this year'
    else
      '${date.year}',
  ].join(', ');
}
```


### Collection for

Lastly, use the `for` keyword to insert a sequence into the collection:

```
class Article {
  String title;
  DateTime date;
  List<String> tags;

  Article(this.title, this.date, this.tags);

  String toString() {
    return [
      title,
      date.toString(),
      for (var tag in tags) 'tag: $tag'
    ].join(', ');
  }
}
```


In this example, the `for` expression adds a string for each item in the `tags` list. Just like a normal `for` loop in Dart, the `tags` expression can be any `Iterable`.

## Collections in Flutter code

If you’re using Dart, there’s a good chance you’re [using it to build Flutter apps](https://www.zdnet.com/article/googles-flutter-2-million-developers-uptick-in-enterprise-use-new-release-model-revealed/). Since the features described here were [designed with Flutter in mind](https://github.com/munificent/ui-as-code/blob/master/Motivation.md), let’s take a look at some Flutter code.

### Refactoring a build() method

In Flutter, it’s common to build up a list of widgets in a `build()` method:

```
[@override](http://twitter.com/override)
Widget build(BuildContext context) {
  var articleWidgets = articles
      .map<Widget>((article) => ArticleWidget(article: article))
      .toList();

  return ListView(
    children: articleWidgets,
  );
}
```


This could be rewritten with a spread:

```
Widget build(BuildContext context) {

  return ListView(
    children: [
      ...articles.map((article) => ArticleWidget(article:article))
    ],
  );
}
```


Or with a *collection for*:

```
Widget build(BuildContext context) {
  return ListView(
    children: [
      for (var article in articles)
        ArticleWidget(article: article)
    ],
  );
}
```


The first snippet converts the `Article` class into a collection of `ArticleWidget` objects using `map()`, and then applies the spread operator to expand them into the surrounding list. In the second example, the *collection for* operator lets you express this a little more succinctly.

### A larger build() method

Here’s a more complex example:

```
Widget build(BuildContext context) {
  var headerStyle = Theme.of(context).textTheme.headline4;

  return Column(
    children: [
      if (article.title != null)
        Text(article.title, style: headerStyle),
      if (article.date != null)
        Text(article.date.toString()),
      Text('Tags:'),
      for (var tag in article.tags)
        Text(tag),
    ],
  );
}
```


The logic to place widgets in the `Column` is right where a reader might expect, and saves a lot of code. Before these features, the most common way to achieve the same behavior was to create a variable and use normal `if` statements that call `add()`.

## Combining these features

These features can be combined in interesting ways, as the examples in this section show. Here are a few things to keep in mind:

* Syntactically a *collection if*, *collection for*, or *spread* is a *single element* — even if it ends up creating multiple objects.

* Any expression can go in the body of a *collection if* or *collection for*.

* Any *element* can go in the body of a *collection if* or *collection for*.

### Using if and for together

Here’s some code that creates a list using a *collection if* inside of a *collection for*. Here, each article is added to the list if it’s after a certain date:

```
List<Article> recentArticles(List<Article> allArticles) {
  var ninetyDaysAgo = DateTime.now().subtract(Duration(days: 90));
  return [
    for (var article in allArticles)
      if (article.date.isAfter(ninetyDaysAgo))
        article
  ];
}
```


If you prefer spreads, the return value could instead be written as `...allArticles.where((article) =&gt; article.date.isAfter(ninetyDaysAgo))`.

### Using collection if and spreads together

A *collection if* takes a single element, but if you want to include more than one you can use a spread:

```
Widget build(BuildContext context) {
  return Column(
    children: [
      if (article.date != null) ...[
        Icon(Icons.calendar_today),
        Text('${article.date}'),
      ],
    ],
  );
}
```


### Using collection features with async-await

You can also combine asynchronous calls with collection literals. For example, a common pattern is to use `Future.wait()` to trigger a group of asynchronous calls:

```
Future<Article> fetchArticle(String id);

Future<List<Article>> fetchArticles() async {
  return Future.wait([
    fetchArticle('1'),
    fetchArticle('2'),
    fetchArticle('3'),
  ]);
}
```


That code can be improved using a *collection for*:

```
Future<List<Article>> fetchArticles(List<String> ids) async {
  return Future.wait([
    for (var id in ids)
      fetchArticle(id),
  ]);
}
```


It’s also possible to put an `await` in a collection literal, although it will wait for each future in sequence:

```
Future<List<Article>> fetchArticles(List<String> ids) async {
  return [
    // fetches one at a time
    for (var id in ids)
      await fetchArticle(id),
  ];
}
```


The preceding code waits in sequence because it’s equivalent to the following:

```
Future<List<Article>> fetchArticles() async {
  return <Article>[
    // fetches one at a time
    await fetchArticle('1'),
    await fetchArticle('2'),
    await fetchArticle('3'),
  ];
}
```


You can also expand a Stream using `await for`:

```
Stream<String> get idStream => Stream.fromIterable(['1','2','3']);
Future<List<String>> gatherIds(Stream<String> ids) async {
  return [
    await for (var id in ids)
      id
  ];
}

void main() async {
  print(await gatherIds(idStream)); // [1, 2, 3]
}
```


This is another example of how *collection if*, *collection for*, and spreads work with other parts of the language. If you’ve used an `await for` statement, you might be able to guess the behavior: it listens to the stream for new values and puts the body into the surrounding list.

## Exploring further

Hopefully these tips help you write cleaner Dart code. There are even more ways to use these features than are mentioned here. If you find a nice technique, [share it with the community](https://dart.dev/community) or [mention *@dart_lang* on Twitter](https://twitter.com/dart_lang). For more details, check out [Making Dart a Better Language for UI](https://medium.com/dartlang/making-dart-a-better-language-for-ui-f1ccaf9f546c) or the initial [language proposal on GitHub](https://github.com/dart-lang/language/blob/master/accepted/2.3/unified-collections/feature-specification.md).