---
title: A tour of the core libraries
description: Learn about the major features in Dart's libraries.
short-title: Library tour
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

This page shows you how to use the major features in Dart's core libraries.
It's just an overview, and by no means comprehensive.
Whenever you need more details about a class,
consult the [Dart API reference.][Dart API]


[dart:core](#dartcore---numbers-collections-strings-and-more)
: Built-in types, collections, and other core functionality.
  This library is automatically imported into every Dart program.

[dart:async](#dartasync---asynchronous-programming)
: Support for asynchronous programming, with classes such as Future and Stream.

[dart:math](#dartmath---math-and-random)
: Mathematical constants and functions, plus a random number generator.

[dart:convert](#dartconvert---decoding-and-encoding-json-utf-8-and-more)
: Encoders and decoders for converting between different data representations, including JSON and UTF-8.

[dart:html](#darthtml)
: DOM and other APIs for browser-based apps.

[dart:io](#dartio)
: I/O for programs that can use the Dart VM,
  including Flutter apps, servers, and command-line scripts.

This page is just an overview;
it covers only a few dart:* libraries
and no third-party libraries.

Other places to find library information are the
[pub.dev site]({{site.pub}}) and the
[Dart web developer library guide][webdev libraries].
You can find API documentation for all dart:* libraries in the
[Dart API reference][Dart API] or, if you're using Flutter,
the [Flutter API reference.][docs.flutter]

{{site.alert.info}}
  **DartPad tip:** You can play with the code in this page by copying it into a
  [DartPad.]({{site.dartpad}})
{{site.alert.end}}


## dart:core - numbers, collections, strings, and more

The dart:core library ([API reference][dart:core])
provides a small but critical set of built-in functionality.
This library is automatically imported into every Dart program.


### Printing to the console

The top-level `print()` method takes a single argument (any Object)
and displays that object's string value (as returned by `toString()`)
in the console.

<?code-excerpt "misc/test/library_tour/core_test.dart (print)"?>
```dart
print(anObject);
print('I drink $tea.');
```

For more information on basic strings and `toString()`, see
[Strings](/language/built-in-types#strings) in the language tour.


### Numbers

The dart:core library defines the num, int, and double classes, which
have some basic utilities for working with numbers.

You can convert a string into an integer or double with the `parse()`
methods of int and double, respectively:

<?code-excerpt "misc/test/library_tour/core_test.dart (int|double.parse)"?>
```dart
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
```

Or use the parse() method of num, which creates an integer if possible
and otherwise a double:

<?code-excerpt "misc/test/library_tour/core_test.dart (num-parse)"?>
```dart
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
```

To specify the base of an integer, add a `radix` parameter:

<?code-excerpt "misc/test/library_tour/core_test.dart (radix)"?>
```dart
assert(int.parse('42', radix: 16) == 66);
```

Use the `toString()` method to convert an
int or double to a string. To specify the number of digits to the right
of the decimal, use [toStringAsFixed().][toStringAsFixed()] To specify the
number of significant digits in the string, use
[toStringAsPrecision():][toStringAsPrecision()]

<?code-excerpt "misc/test/library_tour/core_test.dart (toString())"?>
```dart
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Specify the number of significant figures.
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
```

For more information, see the API documentation for
[int,][int] [double,][double] and [num.][num] Also see
the [dart:math section](#dartmath---math-and-random).


### Strings and regular expressions

A string in Dart is an immutable sequence of UTF-16 code units.
The language tour has more information about
[strings](/language/built-in-types#strings).
You can use regular expressions (RegExp objects)
to search within strings and to
replace parts of strings.

The String class defines such methods as `split()`, `contains()`,
`startsWith()`, `endsWith()`, and more.

#### Searching inside a string

You can find particular locations within a string, as well as check
whether a string begins with or ends with a particular pattern. For
example:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains-etc)"?>
```dart
// Check whether a string contains another string.
assert('Never odd or even'.contains('odd'));

// Does a string start with another string?
assert('Never odd or even'.startsWith('Never'));

// Does a string end with another string?
assert('Never odd or even'.endsWith('even'));

// Find the location of a string inside a string.
assert('Never odd or even'.indexOf('odd') == 6);
```

#### Extracting data from a string

You can get the individual characters from a string as Strings or ints,
respectively. To be precise, you actually get individual UTF-16 code
units; high-numbered characters such as the treble clef symbol
('\\u{1D11E}') are two code units apiece.

You can also extract a substring or split a string into a list of
substrings:

<?code-excerpt "misc/test/library_tour/core_test.dart (substring-etc)"?>
```dart
// Grab a substring.
assert('Never odd or even'.substring(6, 9) == 'odd');

// Split a string using a string pattern.
var parts = 'progressive web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'progressive');

// Get a UTF-16 code unit (as a string) by index.
assert('Never odd or even'[0] == 'N');

// Use split() with an empty string parameter to get
// a list of all characters (as Strings); good for
// iterating.
for (final char in 'hello'.split('')) {
  print(char);
}

// Get all the UTF-16 code units in the string.
var codeUnitList = 'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
```

{{site.alert.note}}
  In many cases, you want to work with
  Unicode grapheme clusters
  as opposed to pure code units.
  These are characters as they are perceived
  by the user (for example, "🇬🇧" is one
  user-perceived character but several
  UTF-16 code units).
  For this, the Dart team provides the
  [`characters` package.]({{site.pub-pkg}}/characters)
{{site.alert.end}}

#### Converting to uppercase or lowercase

You can easily convert strings to their uppercase and lowercase
variants:

<?code-excerpt "misc/test/library_tour/core_test.dart (toUpperCase-toLowerCase)"?>
```dart
// Convert to uppercase.
assert('web apps'.toUpperCase() == 'WEB APPS');

// Convert to lowercase.
assert('WEB APPS'.toLowerCase() == 'web apps');
```

{{site.alert.note}}
  These methods don't work for every language. For example, the Turkish
  alphabet's dotless *I* is converted incorrectly.
{{site.alert.end}}


#### Trimming and empty strings

Remove all leading and trailing white space with `trim()`. To check
whether a string is empty (length is zero), use `isEmpty`.

<?code-excerpt "misc/test/library_tour/core_test.dart (trim-etc)"?>
```dart
// Trim a string.
assert('  hello  '.trim() == 'hello');

// Check whether a string is empty.
assert(''.isEmpty);

// Strings with only white space are not empty.
assert('  '.isNotEmpty);
```

#### Replacing part of a string

Strings are immutable objects, which means you can create them but you
can't change them. If you look closely at the [String API reference,][String]
you'll notice that
none of the methods actually changes the state of a String. For example,
the method `replaceAll()` returns a new String without changing the
original String:

<?code-excerpt "misc/test/library_tour/core_test.dart (replace)"?>
```dart
var greetingTemplate = 'Hello, NAME!';
var greeting = greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
```

#### Building a string

To programmatically generate a string, you can use StringBuffer. A
StringBuffer doesn't generate a new String object until `toString()` is
called. The `writeAll()` method has an optional second parameter that
lets you specify a separator—in this case, a space.

<?code-excerpt "misc/test/library_tour/core_test.dart (StringBuffer)"?>
```dart
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString == 'Use a StringBuffer for efficient string creation.');
```

#### Regular expressions

The RegExp class provides the same capabilities as JavaScript regular
expressions. Use regular expressions for efficient searching and pattern
matching of strings.

<?code-excerpt "misc/test/library_tour/core_test.dart (RegExp)"?>
```dart
// Here's a regular expression for one or more digits.
var numbers = RegExp(r'\d+');

var allCharacters = 'llamas live fifteen to twenty years';
var someDigits = 'llamas live 15 to 20 years';

// contains() can use a regular expression.
assert(!allCharacters.contains(numbers));
assert(someDigits.contains(numbers));

// Replace every match with another string.
var exedOut = someDigits.replaceAll(numbers, 'XX');
assert(exedOut == 'llamas live XX to XX years');
```

You can work directly with the RegExp class, too. The Match class
provides access to a regular expression match.

<?code-excerpt "misc/test/library_tour/core_test.dart (match)"?>
```dart
var numbers = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(numbers.hasMatch(someDigits));

// Loop through all matches.
for (final match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
```

#### More information

Refer to the [String API reference][String] for a full list of
methods. Also see the API reference for [StringBuffer,][StringBuffer]
[Pattern,][Pattern] [RegExp,][RegExp] and [Match.][Match]

### Collections

Dart ships with a core collections API, which includes classes for
lists, sets, and maps.

{{site.alert.tip}}
  To practice using APIs that are available to both lists and sets,
  follow the [Iterable collections codelab](/codelabs/iterables).
{{site.alert.end}}

#### Lists

As the language tour shows, you can use literals to create and
initialize [lists](#lists). Alternatively, use one of the List
constructors. The List class also defines several methods for adding
items to and removing items from lists.

<?code-excerpt "misc/test/library_tour/core_test.dart (List)"?>
```dart
// Create an empty list of strings.
var grains = <String>[];
assert(grains.isEmpty);

// Create a list using a list literal.
var fruits = ['apples', 'oranges'];

// Add to a list.
fruits.add('kiwis');

// Add multiple items to a list.
fruits.addAll(['grapes', 'bananas']);

// Get the list length.
assert(fruits.length == 5);

// Remove a single item.
var appleIndex = fruits.indexOf('apples');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// Remove all elements from a list.
fruits.clear();
assert(fruits.isEmpty);

// You can also create a List using one of the constructors.
var vegetables = List.filled(99, 'broccoli');
assert(vegetables.every((v) => v == 'broccoli'));
```

Use `indexOf()` to find the index of an object in a list:

<?code-excerpt "misc/test/library_tour/core_test.dart (indexOf)"?>
```dart
var fruits = ['apples', 'oranges'];

// Access a list item by index.
assert(fruits[0] == 'apples');

// Find an item in a list.
assert(fruits.indexOf('apples') == 0);
```

Sort a list using the `sort()` method. You can provide a sorting
function that compares two objects. This sorting function must return \<
0 for *smaller*, 0 for the *same*, and \> 0 for *bigger*. The following
example uses `compareTo()`, which is defined by
[Comparable][] and implemented by String.

<?code-excerpt "misc/test/library_tour/core_test.dart (compareTo)"?>
```dart
var fruits = ['bananas', 'apples', 'oranges'];

// Sort a list.
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'apples');
```

Lists are parameterized types
([generics](/language/generics)),
so you can specify the type that a list
should contain:

<?code-excerpt "misc/test/library_tour/core_test.dart (List-of-String)"?>
```dart
// This list should contain only strings.
var fruits = <String>[];

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);
```

{:.fails-sa}
<?code-excerpt "misc/lib/library_tour/core/collections.dart (List-of-String)"?>
```dart
fruits.add(5); // Error: 'int' can't be assigned to 'String'
```

{{site.alert.note}}
  In many cases, you don't
  need to explicitly specify generic
  types, because Dart will
  [infer](/language/type-system#type-inference)
  them for you.
  A list like `['Dash', 'Dart']` is understood
  to be a `List<String>` (read: list of strings).

  But there are times when you _should_ specify
  the generic type. Like, for example, when Dart doesn't have
  anything to infer from: `[]` could be a list of any
  combination of things.
  That's often not what you want, so you write `<String>[]`
  or `<Person>[]` or something similar.
{{site.alert.end}}

Refer to the [List API reference][List] for a full list of methods.

#### Sets

A set in Dart is an unordered collection of unique items. Because a set
is unordered, you can't get a set's items by index (position).

<?code-excerpt "misc/test/library_tour/core_test.dart (Set)"?>
```dart
// Create an empty set of strings.
var ingredients = <String>{};

// Add new items to it.
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// Adding a duplicate item has no effect.
ingredients.add('gold');
assert(ingredients.length == 3);

// Remove an item from a set.
ingredients.remove('gold');
assert(ingredients.length == 2);

// You can also create sets using
// one of the constructors.
var atomicNumbers = Set.from([79, 22, 54]);
```

Use `contains()` and `containsAll()` to check whether one or more
objects are in a set:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Check whether an item is in the set.
assert(ingredients.contains('titanium'));

// Check whether all the items are in the set.
assert(ingredients.containsAll(['titanium', 'xenon']));
```

An intersection is a set whose items are in two other sets.

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
```

Refer to the [Set API reference][Set] for a full list of methods.

#### Maps

A map, commonly known as a *dictionary* or *hash*, is an unordered
collection of key-value pairs. Maps associate a key to some value for
easy retrieval. Unlike in JavaScript, Dart objects are not maps.

You can declare a map using a terse literal syntax, or you can use a
traditional constructor:

<?code-excerpt "misc/test/library_tour/core_test.dart (Map)"?>
```dart
// Maps often use strings as keys.
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// Maps can be built from a constructor.
var searchTerms = Map();

// Maps are parameterized types; you can specify what
// types the key and value should be.
var nobleGases = Map<int, String>();
```

You add, get, and set map items using the bracket syntax. Use `remove()`
to remove a key and its value from a map.

<?code-excerpt "misc/test/library_tour/core_test.dart (remove)"?>
```dart
var nobleGases = {54: 'xenon'};

// Retrieve a value with a key.
assert(nobleGases[54] == 'xenon');

// Check whether a map contains a key.
assert(nobleGases.containsKey(54));

// Remove a key and its value.
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
```

You can retrieve all the values or all the keys from a map:

<?code-excerpt "misc/test/library_tour/core_test.dart (keys)"?>
```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// Get all the keys as an unordered collection
// (an Iterable).
var keys = hawaiianBeaches.keys;

assert(keys.length == 3);
assert(Set.from(keys).contains('Oahu'));

// Get all the values as an unordered collection
// (an Iterable of Lists).
var values = hawaiianBeaches.values;
assert(values.length == 3);
assert(values.any((v) => v.contains('Waikiki')));
```

To check whether a map contains a key, use `containsKey()`. Because map
values can be null, you cannot rely on simply getting the value for the
key and checking for null to determine the existence of a key.

<?code-excerpt "misc/test/library_tour/core_test.dart (containsKey)"?>
```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Florida'));
```

Use the `putIfAbsent()` method when you want to assign a value to a key
if and only if the key does not already exist in a map. You must provide
a function that returns the value.

<?code-excerpt "misc/test/library_tour/core_test.dart (putIfAbsent)"?>
```dart
var teamAssignments = <String, String>{};
teamAssignments.putIfAbsent('Catcher', () => pickToughestKid());
assert(teamAssignments['Catcher'] != null);
```

Refer to the [Map API reference][Map] for a full list of methods.

#### Common collection methods

List, Set, and Map share common functionality found in many collections.
Some of this common functionality is defined by the Iterable class,
which List and Set implement.

{{site.alert.note}}
  Although Map doesn't implement Iterable, you can get Iterables from it using
  the Map `keys` and `values` properties.
{{site.alert.end}}

Use `isEmpty` or `isNotEmpty` to check whether a list, set, or map has items:

<?code-excerpt "misc/test/library_tour/core_test.dart (isEmpty)"?>
```dart
var coffees = <String>[];
var teas = ['green', 'black', 'chamomile', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
```

To apply a function to each item in a list, set, or map, you can use
`forEach()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (List.forEach)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

teas.forEach((tea) => print('I drink $tea'));
```

When you invoke `forEach()` on a map, your function must take two
arguments (the key and value):

<?code-excerpt "misc/test/library_tour/core_test.dart (Map.forEach)"?>
```dart
hawaiianBeaches.forEach((k, v) {
  print('I want to visit $k and swim at $v');
  // I want to visit Oahu and swim at
  // [Waikiki, Kailua, Waimanalo], etc.
});
```

Iterables provide the `map()` method, which gives you all the results in
a single object:

<?code-excerpt "misc/test/library_tour/core_test.dart (List.map)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

var loudTeas = teas.map((tea) => tea.toUpperCase());
loudTeas.forEach(print);
```

{{site.alert.note}}
  The object returned by `map()` is an Iterable that's *lazily evaluated*: your
  function isn't called until you ask for an item from the returned object.
{{site.alert.end}}

To force your function to be called immediately on each item, use
`map().toList()` or `map().toSet()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (toList)"?>
```dart
var loudTeas = teas.map((tea) => tea.toUpperCase()).toList();
```

Use Iterable's `where()` method to get all the items that match a
condition. Use Iterable's `any()` and `every()` methods to check whether
some or all items match a condition.
{% comment %}
PENDING: Change example as suggested by floitsch to have (maybe)
cities instead of isDecaffeinated.
{% endcomment %}


<?code-excerpt "misc/test/library_tour/core_test.dart (where-etc)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

// Chamomile is not caffeinated.
bool isDecaffeinated(String teaName) => teaName == 'chamomile';

// Use where() to find only the items that return true
// from the provided function.
var decaffeinatedTeas = teas.where((tea) => isDecaffeinated(tea));
// or teas.where(isDecaffeinated)

// Use any() to check whether at least one item in the
// collection satisfies a condition.
assert(teas.any(isDecaffeinated));

// Use every() to check whether all the items in a
// collection satisfy a condition.
assert(!teas.every(isDecaffeinated));
```

For a full list of methods, refer to the [Iterable API reference,][Iterable]
as well as those for [List,][List] [Set,][Set] and [Map.][Map]


### URIs

The [Uri class][Uri] provides
functions to encode and decode strings for use in URIs (which you might
know as *URLs*). These functions handle characters that are special for
URIs, such as `&` and `=`. The Uri class also parses and exposes the
components of a URI—host, port, scheme, and so on.
{% comment %}
{PENDING: show
constructors: Uri.http, Uri.https, Uri.file, per floitsch's suggestion}
{% endcomment %}

#### Encoding and decoding fully qualified URIs

To encode and decode characters *except* those with special meaning in a
URI (such as `/`, `:`, `&`, `#`), use the `encodeFull()` and
`decodeFull()` methods. These methods are good for encoding or decoding
a fully qualified URI, leaving intact special URI characters.

<?code-excerpt "misc/test/library_tour/core_test.dart (encodeFull)"?>
```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeFull(uri);
assert(encoded == 'https://example.org/api?foo=some%20message');

var decoded = Uri.decodeFull(encoded);
assert(uri == decoded);
```

Notice how only the space between `some` and `message` was encoded.

#### Encoding and decoding URI components

To encode and decode all of a string's characters that have special
meaning in a URI, including (but not limited to) `/`, `&`, and `:`, use
the `encodeComponent()` and `decodeComponent()` methods.

<?code-excerpt "misc/test/library_tour/core_test.dart (encodeComponent)"?>
```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeComponent(uri);
assert(
    encoded == 'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message');

var decoded = Uri.decodeComponent(encoded);
assert(uri == decoded);
```

Notice how every special character is encoded. For example, `/` is
encoded to `%2F`.

#### Parsing URIs

If you have a Uri object or a URI string, you can get its parts using
Uri fields such as `path`. To create a Uri from a string, use the
`parse()` static method:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri.parse)"?>
```dart
var uri = Uri.parse('https://example.org:8080/foo/bar#frag');

assert(uri.scheme == 'https');
assert(uri.host == 'example.org');
assert(uri.path == '/foo/bar');
assert(uri.fragment == 'frag');
assert(uri.origin == 'https://example.org:8080');
```

See the [Uri API reference][Uri] for more URI components that you can get.

#### Building URIs

You can build up a URI from individual parts using the `Uri()`
constructor:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri)"?>
```dart
var uri = Uri(
    scheme: 'https',
    host: 'example.org',
    path: '/foo/bar',
    fragment: 'frag',
    queryParameters: {'lang': 'dart'});
assert(uri.toString() == 'https://example.org/foo/bar?lang=dart#frag');
```

If you don't need to specify a fragment,
to create a URI with a http or https scheme,
you can instead use the [`Uri.http`][] or [`Uri.https`][] factory constructors:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri-http)"?>
```dart
var httpUri = Uri.http('example.org', '/foo/bar', {'lang': 'dart'});
var httpsUri = Uri.https('example.org', '/foo/bar', {'lang': 'dart'});

assert(httpUri.toString() == 'http://example.org/foo/bar?lang=dart');
assert(httpsUri.toString() == 'https://example.org/foo/bar?lang=dart');
```

[`Uri.http`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri/Uri.http.html
[`Uri.https`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri/Uri.https.html

### Dates and times

A DateTime object is a point in time. The time zone is either UTC or the
local time zone.

You can create DateTime objects using several constructors and methods:

<?code-excerpt "misc/test/library_tour/core_test.dart (DateTime)"?>
```dart
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);

// Parse an ISO 8601 date in the UTC time zone.
y2k = DateTime.parse('2000-01-01T00:00:00Z');

// Create a new DateTime from an existing one, adjusting just some properties:
var sameTimeLastYear = now.copyWith(year: now.year - 1);
```
{{site.alert.warning}}
  `DateTime` operations might give unexpected results related to Daylight Savings Time and other non-standard time adjustments.  
{{site.alert.end}}
The `millisecondsSinceEpoch` property of a date returns the number of
milliseconds since the "Unix epoch"—January 1, 1970, UTC:

<?code-excerpt "misc/test/library_tour/core_test.dart (millisecondsSinceEpoch)"?>
```dart
// 1/1/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
```

Use the Duration class to calculate the difference between two dates and
to shift a date forward or backward:

<?code-excerpt "misc/test/library_tour/core_test.dart (Duration)"?>
```dart
var y2k = DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 = y2001.subtract(const Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calculate the difference between two dates.
// Returns a Duration object.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k was a leap year.
```

{{site.alert.warning}}
  Using a Duration to shift a DateTime by days can be problematic, due to clock
  shifts (to daylight saving time, for example). Use UTC dates if you must shift
  days.
{{site.alert.end}}

For a full list of methods,
refer to the API reference for [DateTime][] and [Duration.][Duration]


### Utility classes

The core library contains various utility classes, useful for sorting,
mapping values, and iterating.

#### Comparing objects

Implement the [Comparable][]
interface to indicate that an object can be compared to another object,
usually for sorting. The `compareTo()` method returns \< 0 for
*smaller*, 0 for the *same*, and \> 0 for *bigger*.

<?code-excerpt "misc/lib/library_tour/core/comparable.dart"?>
```dart
class Line implements Comparable<Line> {
  final int length;
  const Line(this.length);

  @override
  int compareTo(Line other) => length - other.length;
}

void main() {
  var short = const Line(1);
  var long = const Line(100);
  assert(short.compareTo(long) < 0);
}
```

#### Implementing map keys

Each object in Dart automatically provides an integer hash code, and
thus can be used as a key in a map. However, you can override the
`hashCode` getter to generate a custom hash code. If you do, you might
also want to override the `==` operator. Objects that are equal (via
`==`) must have identical hash codes. A hash code doesn't have to be
unique, but it should be well distributed.

{{site.alert.tip}}
  To consistently and easily implement the `hashCode` getter,
  consider using the static hashing methods provided by the `Object` class.

  To generate a single hash code for multiple properties of an object,
  you can use [`Object.hash()`][].
  To generate a hash code for a collection,
  you can use either [`Object.hashAll()`][] (if element order matters)
  or [`Object.hashAllUnordered()`][].
{{site.alert.end}}

[`Object.hash()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object/hash.html
[`Object.hashAll()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object/hashAll.html
[`Object.hashAllUnordered()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object/hashAllUnordered.html

{% comment %}
Note: There's disagreement over whether to include identical() in the ==
implementation. It might improve speed, at least when you need to
compare many fields. They don't do identical() automatically because, by
convention, NaN != NaN.
{% endcomment %}

<?code-excerpt "misc/lib/library_tour/core/hash_code.dart"?>
```dart
class Person {
  final String firstName, lastName;

  Person(this.firstName, this.lastName);

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  @override
  int get hashCode => Object.hash(firstName, lastName);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) {
    return other is Person &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }
}

void main() {
  var p1 = Person('Bob', 'Smith');
  var p2 = Person('Bob', 'Smith');
  var p3 = 'not a person';
  assert(p1.hashCode == p2.hashCode);
  assert(p1 == p2);
  assert(p1 != p3);
}
```

#### Iteration

The [Iterable][] and [Iterator][] classes
support sequential access to a collection of values.
To practice using these collections,
follow the [Iterable collections codelab](/codelabs/iterables).

If you create a class that can provide Iterators for use in for-in loops,
extend (if possible) or implement Iterable.
Implement Iterator to define the actual iteration ability.

<?code-excerpt "misc/lib/library_tour/core/iterator.dart"?>
```dart
class Process {
  // Represents a process...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => ...
  @override
  bool moveNext() => ...
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (final process in Processes()) {
    // Do something with the process.
  }
}
```

### Exceptions

The Dart core library defines many common exceptions and errors.
Exceptions are considered conditions that you can plan ahead for and
catch. Errors are conditions that you don't expect or plan for.

A couple of the most common errors are:

[NoSuchMethodError][]

:   Thrown when a receiving object (which might be null) does not
    implement a method.

[ArgumentError][]

:   Can be thrown by a method that encounters an unexpected argument.

Throwing an application-specific exception is a common way to indicate
that an error has occurred. You can define a custom exception by
implementing the Exception interface:

<?code-excerpt "misc/lib/library_tour/core/exception.dart"?>
```dart
class FooException implements Exception {
  final String? msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
```

For more information, see
[Exceptions](/language/error-handling#exceptions)
(in the language tour) and the [Exception API reference.][Exception]

### Weak references and finalizers

Dart is a [garbage-collected][] language,
which means that any Dart object
that isn't referenced
can be disposed by the garbage collector. 
This default behavior might not be desirable in
some scenarios involving native resources or 
if the target object can't be modified.

A [WeakReference][]
stores a reference to the target object
that does not affect how it is 
collected by the garbage collector.
Another option is to use an [Expando][]
to add properties to an object.

A [Finalizer][] can be used to execute a callback function
after an object is no longer referenced.
However, it is not guaranteed to execute this callback.

A [NativeFinalizer][]
provides stronger guarantees
for interacting with native code using [dart:ffi][];
its callback is invoked at least once
after the object is no longer referenced.
Also, it can be used to close native resources
such as a database connection or open files.

To ensure that an object won't be
garbage collected and finalized too early,
classes can implement the [Finalizable][] interface.
When a local variable is Finalizable, 
it won't be garbage collected
until the code block where it is declared has exited.

{{site.alert.version-note}}
  Support for weak references and finalizers was added in Dart 2.17.
{{site.alert.end}}

## dart:async - asynchronous programming

Asynchronous programming often uses callback functions, but Dart
provides alternatives: [Future][] and [Stream][] objects. A
Future is like a promise for a result to be provided sometime in the
future. A Stream is a way to get a sequence of values, such as events.
Future, Stream, and more are in the
dart:async library ([API reference][dart:async]).

{{site.alert.note}}
  You don't always need to use the Future or Stream APIs directly. The Dart
  language supports asynchronous coding using keywords such as `async` and
  `await`. See the [asynchronous programming codelab](/codelabs/async-await) for
  details.
{{site.alert.end}}

The dart:async library works in both web apps and command-line apps. To
use it, import dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
```dart
import 'dart:async';
```

{{site.alert.tip}}
  You don't need to import dart:async to use the Future and
  Stream APIs, because dart:core exports those classes.
{{site.alert.end}}

### Future

Future objects appear throughout the Dart libraries, often as the object
returned by an asynchronous method. When a future *completes*, its value
is ready to use.


#### Using await

Before you directly use the Future API, consider using `await` instead.
Code that uses `await` expressions can be easier to understand
than code that uses the Future API.

Consider the following function.  It uses Future's `then()` method
to execute three asynchronous functions in a row,
waiting for each one to complete before executing the next one.

<?code-excerpt "misc/lib/library_tour/async/future.dart (runUsingFuture)"?>
```dart
void runUsingFuture() {
  // ...
  findEntryPoint().then((entryPoint) {
    return runExecutable(entryPoint, args);
  }).then(flushThenExit);
}
```

The equivalent code with await expressions
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/future.dart (runUsingAsyncAwait)"?>
```dart
Future<void> runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
```

An `async` function can catch exceptions from Futures.
For example:

<?code-excerpt "misc/lib/library_tour/async/future.dart (catch)"?>
```dart
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
```

{{site.alert.important}}
  Async functions return Futures. If you don't want your function to return a
  future, then use a different solution. For example, you might call an `async`
  function from your function.
{{site.alert.end}}

For more information on using `await` and related Dart language features,
see the [asynchronous programming codelab](/codelabs/async-await).


#### Basic usage

{% comment %}
[PENDING: Delete much of the following content in favor of the tutorial coverage?]
{% endcomment %}

You can use `then()` to schedule code that runs when the future completes. For
example, `HttpRequest.getString()` returns a Future, since HTTP requests
can take a while. Using `then()` lets you run some code when that Future
has completed and the promised string value is available:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
```dart
HttpRequest.getString(url).then((String result) {
  print(result);
});
```

Use `catchError()` to handle any errors or exceptions that a Future
object might throw.

<?code-excerpt "misc/lib/library_tour/async/basic.dart (catchError)"?>
```dart
HttpRequest.getString(url).then((String result) {
  print(result);
}).catchError((e) {
  // Handle or ignore the error.
});
```

The `then().catchError()` pattern is the asynchronous version of
`try`-`catch`.

{{site.alert.important}}
  Be sure to invoke `catchError()` on the result of `then()`—not on the result
  of the original Future. Otherwise, the `catchError()` can handle errors only
  from the original Future's computation, but not from the handler registered by
  `then()`.
{{site.alert.end}}


#### Chaining multiple asynchronous methods

The `then()` method returns a Future, providing a useful way to run
multiple asynchronous functions in a certain order. 
If the callback registered with `then()` returns a Future, 
`then()` returns a Future that will complete
with the same result as the Future returned from the callback. 
If the callback returns a value of any other type,
`then()` creates a new Future that completes with the value.

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain)"?>
```dart
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
  /* Handle exception... */
});
```

In the preceding example, the methods run in the following order:

1.  `costlyQuery()`
2.  `expensiveWork()`
3.  `lengthyComputation()`

Here is the same code written using await:

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain-as-await)"?>
```dart
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
```


#### Waiting for multiple futures

Sometimes your algorithm needs to invoke many asynchronous functions and
wait for them all to complete before continuing. Use the [Future.wait()][]
static method to manage multiple Futures and wait for them to complete:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
```dart
Future<void> deleteLotsOfFiles() async =>  ...
Future<void> copyLotsOfFiles() async =>  ...
Future<void> checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

`Future.wait()` returns a future which completes once all the provided
futures have completed. It completes either with their results,
or with an error if any of the provided futures fail. 

#### Handling errors for multiple futures

You can also wait for parallel operations on an [iterable]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/FutureIterable/wait.html)
or [record]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/FutureRecord2/wait.html)
of futures.

These extensions return a future with the resulting values of all provided
futures. Unlike `Future.wait`, they also let you handle errors. 

If any future in the collection completes with an error, `wait` completes with a
[`ParallelWaitError`][]. This allows the caller to handle individual errors and
dispose successful results if necessary.

When you _don't_ need the result values from each individual future,
use `wait` on an _iterable_ of futures:

```dart
void main() async {
  Future<void> delete() async =>  ...
  Future<void> copy() async =>  ...
  Future<void> errorResult() async =>  ...
  
  try {
    // Wait for each future in a list, returns a list of futures:
    var results = await [delete(), copy(), errorResult()].wait;

    } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {

    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Prints null when the result is successful
    print(e.errors[1]);    // Prints null when the result is successful
    print(e.errors[2]);    // Prints error
  }

}
```

When you _do_ need the individual result values from each future,
use `wait` on a _record_ of futures.
This provides the additional benefit that the futures can be of different types:

```dart
void main() async {
  Future<int> delete() async =>  ...
  Future<String> copy() async =>  ...
  Future<bool> errorResult() async =>  ...

  try {    
    // Wait for each future in a record, returns a record of futures:
    (int, String, bool) result = await (delete(), copy(), errorResult()).wait;
  
  } on ParallelWaitError<(int?, String?, bool?),
      (AsyncError?, AsyncError?, AsyncError?)> catch (e) {
    // ...
    }

  // Do something with the results:
  var deleteInt  = result.$1;
  var copyString = result.$2;
  var errorBool  = result.$3;
}
```

### Stream

Stream objects appear throughout Dart APIs, representing sequences of
data. For example, HTML events such as button clicks are delivered using
streams. You can also read a file as a stream.


#### Using an asynchronous for loop

Sometimes you can use an asynchronous for loop (`await for`)
instead of using the Stream API.

Consider the following function.
It uses Stream's `listen()` method
to subscribe to a list of files,
passing in a function literal that searches each file or directory.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (listen)" replace="/listen/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir.list().[!listen!]((entity) {
        if (entity is File) {
          searchFile(entity, searchTerms);
        }
      });
    } else {
      searchFile(File(searchPath), searchTerms);
    }
  });
}
{% endprettify %}

The equivalent code with await expressions,
including an asynchronous for loop (`await for`),
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (await-for)" replace="/await for/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    [!await for!] (final entity in startingDir.list()) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
{% endprettify %}

{{site.alert.important}}
  Before using `await for`, make sure that it makes the code clearer and that
  you really do want to wait for all of the stream's results. For example, you
  usually should **not** use `await for` for DOM event listeners, because the
  DOM sends endless streams of events. If you use `await for` to register two
  DOM event listeners in a row, then the second kind of event is never handled.
{{site.alert.end}}

For more information on using `await` and related
Dart language features, see the
[asynchronous programming codelab](/codelabs/async-await).


#### Listening for stream data

To get each value as it arrives, either use `await for` or
subscribe to the stream using the `listen()` method:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/listen/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
// Add an event handler to a button.
submitButton.onClick.[!listen!]((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
{% endprettify %}

In this example, the `onClick` property is a `Stream` object provided by
the submit button.

If you care about only one event, you can get it using a property such
as `first`, `last`, or `single`. To test the event before handling it,
use a method such as `firstWhere()`, `lastWhere()`, or `singleWhere()`.
{% comment %}
{PENDING: example}
{% endcomment %}

If you care about a subset of events, you can use methods such as
`skip()`, `skipWhile()`, `take()`, `takeWhile()`, and `where()`.
{% comment %}
{PENDING: example}
{% endcomment %}


#### Transforming stream data

Often, you need to change the format of a stream's data before you can
use it. Use the `transform()` method to produce a stream with a
different type of data:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (transform)"?>
```dart
var lines =
    inputStream.transform(utf8.decoder).transform(const LineSplitter());
```

This example uses two transformers. First it uses utf8.decoder to
transform the stream of integers into a stream of strings. Then it uses
a LineSplitter to transform the stream of strings into a stream of
separate lines. These transformers are from the dart:convert library (see the
[dart:convert section](#dartconvert---decoding-and-encoding-json-utf-8-and-more)).
{% comment %}
  PENDING: add onDone and onError. (See "Streaming file contents".)
{% endcomment %}


#### Handling errors and completion

How you specify error and completion handling code
depends on whether you use an asynchronous for loop (`await for`)
or the Stream API.

If you use an asynchronous for loop,
then use try-catch to handle errors.
Code that executes after the stream is closed
goes after the asynchronous for loop.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (readFileAwaitFor)" replace="/try|catch/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Future<void> readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines =
      inputStream.transform(utf8.decoder).transform(const LineSplitter());
  [!try!] {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } [!catch!] (e) {
    print(e);
  }
}
{% endprettify %}

If you use the Stream API,
then handle errors by registering an `onError` listener.
Run code after the stream is closed by registering
an `onDone` listener.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (onDone)" replace="/onDone|onError/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream.transform(utf8.decoder).transform(const LineSplitter()).listen(
    (String line) {
  print('Got ${line.length} characters from stream');
}, [!onDone!]: () {
  print('file is now closed');
}, [!onError!]: (e) {
  print(e);
});
{% endprettify %}


### More information

For some examples of using Future and Stream in command-line apps,
see the [dart:io tour][dart:io tour].
Also see these articles, codelabs, and tutorials:

-   [Asynchronous programming: futures, async, await](/codelabs/async-await)
-   [Futures and error handling](/guides/libraries/futures-error-handling)
-   [Asynchronous programming: streams](/tutorials/language/streams)
-   [Creating streams in Dart](/articles/libraries/creating-streams)
-   [Dart asynchronous programming: Isolates and event loops](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a)


## dart:math - math and random

The dart:math library ([API reference][dart:math])
provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use this library in your app, import dart:math.

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
```dart
import 'dart:math';
```


### Trigonometry

The Math library provides basic trigonometric functions:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
```dart
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
```

{{site.alert.note}}
  These functions use radians, not degrees!
{{site.alert.end}}


### Maximum and minimum

The Math library provides `max()` and `min()` methods:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
```dart
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
```


### Math constants

Find your favorite constants—*pi*, *e*, and more—in the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
```dart
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
```


### Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (Random)"?>
```dart
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (Random-bool)"?>
```dart
var random = Random();
random.nextBool(); // true or false
```

{{site.alert.warning}}
  The default implementation of `Random` supplies a stream of pseudorandom bits
  that are unsuitable for cryptographic purposes.
  To create a cryptographically secure random number generator,
  use the [`Random.secure()`][] constructor.
{{site.alert.end}}

### More information

Refer to the [Math API reference][dart:math] for a full list of methods.
Also see the API reference for [num,][num] [int,][int] and [double.][double]


## dart:convert - decoding and encoding JSON, UTF-8, and more

The dart:convert library ([API reference][dart:convert])
has converters for JSON and UTF-8, as well as support for creating
additional converters. [JSON][] is a simple text format for representing
structured objects and collections. [UTF-8][] is a common variable-width
encoding that can represent every character in the Unicode character
set.

To use this library, import dart:convert.

<?code-excerpt "misc/test/library_tour/convert_test.dart (import)"?>
```dart
import 'dart:convert';
```


### Decoding and encoding JSON

Decode a JSON-encoded string into a Dart object with `jsonDecode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-decode)"?>
```dart
// NOTE: Be sure to use double quotes ("),
// not single quotes ('), inside the JSON string.
// This string is JSON, not Dart.
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
```

Encode a supported Dart object into a JSON-formatted string with
`jsonEncode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-encode)"?>
```dart
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null}
];

var jsonText = jsonEncode(scores);
assert(jsonText ==
    '[{"score":40},{"score":80},'
        '{"score":100,"overtime":true,'
        '"special_guest":null}]');
```

Only objects of type int, double, String, bool, null, List, or Map (with
string keys) are directly encodable into JSON. List and Map objects are
encoded recursively.

You have two options for encoding objects that aren't directly
encodable. The first is to invoke `jsonEncode()` with a second argument: a
function that returns an object that is directly encodable. Your second
option is to omit the second argument, in which case the encoder calls
the object's `toJson()` method.

For more examples and links to JSON-related packages, see
[Using JSON](/guides/json).


### Decoding and encoding UTF-8 characters

Use `utf8.decode()` to decode UTF8-encoded bytes to a Dart string:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-decode)" replace="/ \/\/line-br.*//g"?>
```dart
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
```

To convert a stream of UTF-8 characters into a Dart string, specify
`utf8.decoder` to the Stream `transform()` method:

<?code-excerpt "misc/test/library_tour/io_test.dart (utf8-decoder)" replace="/utf8.decoder/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
var lines = [!utf8.decoder!].bind(inputStream).transform(const LineSplitter());
try {
  await for (final line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
{% endprettify %}

Use `utf8.encode()` to encode a Dart string as a list of UTF8-encoded
bytes:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-encode)" replace="/ \/\/line-br.*//g"?>
```dart
List<int> encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
```


### Other functionality

The dart:convert library also has converters for ASCII and ISO-8859-1
(Latin1). For details, see the [API reference for the dart:convert library.][dart:convert]


## dart:html - browser-based apps {#darthtml}

{% include_relative _dart-html-tour.md %}


## dart:io - I/O for servers and command-line apps {#dartio}

{% include_relative _dart-io-tour.md %}


## Summary

This page introduced you to the most commonly used functionality in
Dart's built-in libraries. It didn't cover all the built-in
libraries, however. Others that you might want to look into include
[dart:collection][] and [dart:typed\_data,][dart:typed\_data]
as well as platform-specific libraries like the
[Dart web development libraries][webdev libraries]
and the [Flutter libraries.][docs.flutter]

You can get yet more libraries by using the [pub package manager](/guides/packages). The
[collection,]({{site.pub-pkg}}/collection)
[crypto,]({{site.pub-pkg}}/crypto)
[http,]({{site.pub-pkg}}/http)
[intl,]({{site.pub-pkg}}/intl) and
[test]({{site.pub-pkg}}/test) libraries are just a
sampling of what you can install using pub.

To learn more about the Dart language, see the
[language tour][].

[ArgumentError]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[Assert]: /language/error-handling#assert
[Comparable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Comparable-class.html
[Dart API]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}
[DateTime]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/DateTime-class.html
[Duration]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Duration-class.html
[Exception]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
[Expando]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Expando-class.html
[Finalizable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/Finalizable-class.html
[Finalizer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Finalizer-class.html
[Future.wait()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/wait.html
[Future]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[IndexedDB]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[Iterable]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterator-class.html
[JSON]: https://www.json.org/
[List]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[Map]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Match]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Match-class.html
[NativeFinalizer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-ffi/NativeFinalizer-class.html
[NoSuchMethodError]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError-class.html
[Object]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[`ParallelWaitError`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/ParallelWaitError-class.html
[Pattern]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Pattern-class.html
[Random]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random-class.html
[RegExp]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/RegExp-class.html
[Set]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[Stream]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[StringBuffer]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StringBuffer-class.html
[String]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String-class.html
[Symbol]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[Uri]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[WeakReference]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/WeakReference-class.html
[`Random.secure()`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random/Random.secure.html
[dart:async]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart:collection]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart:convert]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:core]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart:ffi]: /guides/libraries/c-interop
[dart:io tour]: #dartio
[dart:math]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart:typed\_data]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[docs.flutter]: {{site.flutter-api}}
[double]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double-class.html
[garbage-collected]: https://medium.com/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30
[int]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int-class.html
[language tour]: /language
[num]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num-class.html
[toStringAsFixed()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsPrecision.html
[weak reference]: https://en.wikipedia.org/wiki/Weak_reference
[web audio]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[webdev libraries]: /web/libraries
