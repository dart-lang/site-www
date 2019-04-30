---
title: A tour of the core libraries
description: Learn about the major features in Dart's libraries.
short-title: Library tour
---
<?code-excerpt plaster="none"?>

This page shows you how to use the major features in Dart’s core libraries.
It’s just an overview, and by no means comprehensive.
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
[Pub site][pub.dartlang] and the
[Dart web developer library guide][webdev libraries].
You can find API documentation for all dart:* libraries in the
[Dart API reference][Dart API] or, if you're using Flutter,
the [Flutter API reference.][docs.flutter]

<aside class="alert alert-info" markdown="1">
  **DartPad tip:** You can play with the code in this page by copying it into a
  [DartPad.][DartPad]
</aside>


## dart:core - numbers, collections, strings, and more

The dart:core library ([API reference][dart:core])
provides a small but critical set of built-in functionality.
This library is automatically imported into every Dart program.


### Printing to the console

The top-level `print()` method takes a single argument (any Object)
and displays that object's string value (as returned by `toString()`)
in the console.

<?code-excerpt "misc/test/library_tour/core_test.dart (print)"?>
{% prettify dart %}
print(anObject);
print('I drink $tea.');
{% endprettify %}

For more information on basic strings and `toString()`, see
[Strings](/guides/language/language-tour#strings) in the language tour.


### Numbers

The dart:core library defines the num, int, and double classes, which
have some basic utilities for working with numbers.

You can convert a string into an integer or double with the `parse()`
methods of int and double, respectively:

<?code-excerpt "misc/test/library_tour/core_test.dart (int|double.parse)"?>
{% prettify dart %}
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
{% endprettify %}

Or use the parse() method of num, which creates an integer if possible
and otherwise a double:

<?code-excerpt "misc/test/library_tour/core_test.dart (num-parse)"?>
{% prettify dart %}
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
{% endprettify %}

To specify the base of an integer, add a `radix` parameter:

<?code-excerpt "misc/test/library_tour/core_test.dart (radix)"?>
{% prettify dart %}
assert(int.parse('42', radix: 16) == 66);
{% endprettify %}

Use the `toString()` method to convert an
int or double to a string. To specify the number of digits to the right
of the decimal, use [toStringAsFixed().][toStringAsFixed()] To specify the
number of significant digits in the string, use
[toStringAsPrecision():][toStringAsPrecision()]

<?code-excerpt "misc/test/library_tour/core_test.dart (toString())"?>
{% prettify dart %}
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Specify the number of significant figures.
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
{% endprettify %}

For more information, see the API documentation for
[int,][int] [double,][double] and [num.][num] Also see
the [dart:math section](#dartmath---math-and-random).


### Strings and regular expressions

A string in Dart is an immutable sequence of UTF-16 code units.
The language tour has more information about
[strings](/guides/language/language-tour#strings).
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
{% prettify dart %}
// Check whether a string contains another string.
assert('Never odd or even'.contains('odd'));

// Does a string start with another string?
assert('Never odd or even'.startsWith('Never'));

// Does a string end with another string?
assert('Never odd or even'.endsWith('even'));

// Find the location of a string inside a string.
assert('Never odd or even'.indexOf('odd') == 6);
{% endprettify %}

#### Extracting data from a string

You can get the individual characters from a string as Strings or ints,
respectively. To be precise, you actually get individual UTF-16 code
units; high-numbered characters such as the treble clef symbol
('\\u{1D11E}') are two code units apiece.

You can also extract a substring or split a string into a list of
substrings:

<?code-excerpt "misc/test/library_tour/core_test.dart (substring-etc)"?>
{% prettify dart %}
// Grab a substring.
assert('Never odd or even'.substring(6, 9) == 'odd');

// Split a string using a string pattern.
var parts = 'structured web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'structured');

// Get a UTF-16 code unit (as a string) by index.
assert('Never odd or even'[0] == 'N');

// Use split() with an empty string parameter to get
// a list of all characters (as Strings); good for
// iterating.
for (var char in 'hello'.split('')) {
  print(char);
}

// Get all the UTF-16 code units in the string.
var codeUnitList =
    'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
{% endprettify %}

#### Converting to uppercase or lowercase

You can easily convert strings to their uppercase and lowercase
variants:

<?code-excerpt "misc/test/library_tour/core_test.dart (toUpperCase-toLowerCase)"?>
{% prettify dart %}
// Convert to uppercase.
assert('structured web apps'.toUpperCase() ==
    'STRUCTURED WEB APPS');

// Convert to lowercase.
assert('STRUCTURED WEB APPS'.toLowerCase() ==
    'structured web apps');
{% endprettify %}

<div class="alert alert-info" markdown="1">
**Note:**
These methods don't work for every language. For example, the Turkish
alphabet's dotless *I* is converted incorrectly.
</div>


#### Trimming and empty strings

Remove all leading and trailing white space with `trim()`. To check
whether a string is empty (length is zero), use `isEmpty`.

<?code-excerpt "misc/test/library_tour/core_test.dart (trim-etc)"?>
{% prettify dart %}
// Trim a string.
assert('  hello  '.trim() == 'hello');

// Check whether a string is empty.
assert(''.isEmpty);

// Strings with only white space are not empty.
assert('  '.isNotEmpty);
{% endprettify %}

#### Replacing part of a string

Strings are immutable objects, which means you can create them but you
can’t change them. If you look closely at the [String API reference,][String]
you’ll notice that
none of the methods actually changes the state of a String. For example,
the method `replaceAll()` returns a new String without changing the
original String:

<?code-excerpt "misc/test/library_tour/core_test.dart (replace)"?>
{% prettify dart %}
var greetingTemplate = 'Hello, NAME!';
var greeting =
    greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
{% endprettify %}

#### Building a string

To programmatically generate a string, you can use StringBuffer. A
StringBuffer doesn’t generate a new String object until `toString()` is
called. The `writeAll()` method has an optional second parameter that
lets you specify a separator—in this case, a space.

<?code-excerpt "misc/test/library_tour/core_test.dart (StringBuffer)"?>
{% prettify dart %}
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString ==
    'Use a StringBuffer for efficient string creation.');
{% endprettify %}

#### Regular expressions

The RegExp class provides the same capabilities as JavaScript regular
expressions. Use regular expressions for efficient searching and pattern
matching of strings.

<?code-excerpt "misc/test/library_tour/core_test.dart (RegExp)"?>
{% prettify dart %}
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
{% endprettify %}

You can work directly with the RegExp class, too. The Match class
provides access to a regular expression match.

<?code-excerpt "misc/test/library_tour/core_test.dart (match)"?>
{% prettify dart %}
var numbers = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(numbers.hasMatch(someDigits));

// Loop through all matches.
for (var match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
{% endprettify %}

#### More information

Refer to the [String API reference][String] for a full list of
methods. Also see the API reference for [StringBuffer,][StringBuffer]
[Pattern,][Pattern] [RegExp,][RegExp] and [Match.][Match]

### Collections

Dart ships with a core collections API, which includes classes for
lists, sets, and maps.

#### Lists

As the language tour shows, you can use literals to create and
initialize [lists](#lists). Alternatively, use one of the List
constructors. The List class also defines several methods for adding
items to and removing items from lists.

<?code-excerpt "misc/test/library_tour/core_test.dart (List)"?>
{% prettify dart %}
// Use a List constructor.
var vegetables = List();

// Or simply use a list literal.
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
assert(fruits.length == 0);
{% endprettify %}

Use `indexOf()` to find the index of an object in a list:

<?code-excerpt "misc/test/library_tour/core_test.dart (indexOf)"?>
{% prettify dart %}
var fruits = ['apples', 'oranges'];

// Access a list item by index.
assert(fruits[0] == 'apples');

// Find an item in a list.
assert(fruits.indexOf('apples') == 0);
{% endprettify %}

Sort a list using the `sort()` method. You can provide a sorting
function that compares two objects. This sorting function must return \<
0 for *smaller*, 0 for the *same*, and \> 0 for *bigger*. The following
example uses `compareTo()`, which is defined by
[Comparable][] and implemented by String.

<?code-excerpt "misc/test/library_tour/core_test.dart (compareTo)"?>
{% prettify dart %}
var fruits = ['bananas', 'apples', 'oranges'];

// Sort a list.
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'apples');
{% endprettify %}

Lists are parameterized types, so you can specify the type that a list
should contain:

<?code-excerpt "misc/test/library_tour/core_test.dart (List-of-String)"?>
{% prettify dart %}
// This list should contain only strings.
var fruits = List<String>();

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);
{% endprettify %}

{:.fails-sa}
<?code-excerpt "misc/lib/library_tour/core/collections.dart (List-of-String)"?>
{% prettify dart %}
fruits.add(5); // Error: 'int' can't be assigned to 'String'
{% endprettify %}

Refer to the [List API reference][List] for a full list of methods.

#### Sets

A set in Dart is an unordered collection of unique items. Because a set
is unordered, you can’t get a set’s items by index (position).

<?code-excerpt "misc/test/library_tour/core_test.dart (Set)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// Adding a duplicate item has no effect.
ingredients.add('gold');
assert(ingredients.length == 3);

// Remove an item from a set.
ingredients.remove('gold');
assert(ingredients.length == 2);
{% endprettify %}

Use `contains()` and `containsAll()` to check whether one or more
objects are in a set:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Check whether an item is in the set.
assert(ingredients.contains('titanium'));

// Check whether all the items are in the set.
assert(ingredients.containsAll(['titanium', 'xenon']));
{% endprettify %}

An intersection is a set whose items are in two other sets.

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
{% endprettify %}

Refer to the [Set API reference][Set] for a full list of methods.

#### Maps

A map, commonly known as a *dictionary* or *hash*, is an unordered
collection of key-value pairs. Maps associate a key to some value for
easy retrieval. Unlike in JavaScript, Dart objects are not maps.

You can declare a map using a terse literal syntax, or you can use a
traditional constructor:

<?code-excerpt "misc/test/library_tour/core_test.dart (Map)"?>
{% prettify dart %}
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
{% endprettify %}

You add, get, and set map items using the bracket syntax. Use `remove()`
to remove a key and its value from a map.

<?code-excerpt "misc/test/library_tour/core_test.dart (remove)"?>
{% prettify dart %}
var nobleGases = {54: 'xenon'};

// Retrieve a value with a key.
assert(nobleGases[54] == 'xenon');

// Check whether a map contains a key.
assert(nobleGases.containsKey(54));

// Remove a key and its value.
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
{% endprettify %}

You can retrieve all the values or all the keys from a map:

<?code-excerpt "misc/test/library_tour/core_test.dart (keys)"?>
{% prettify dart %}
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
{% endprettify %}

To check whether a map contains a key, use `containsKey()`. Because map
values can be null, you cannot rely on simply getting the value for the
key and checking for null to determine the existence of a key.

<?code-excerpt "misc/test/library_tour/core_test.dart (containsKey)"?>
{% prettify dart %}
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Florida'));
{% endprettify %}

Use the `putIfAbsent()` method when you want to assign a value to a key
if and only if the key does not already exist in a map. You must provide
a function that returns the value.

<?code-excerpt "misc/test/library_tour/core_test.dart (putIfAbsent)"?>
{% prettify dart %}
var teamAssignments = {};
teamAssignments.putIfAbsent(
    'Catcher', () => pickToughestKid());
assert(teamAssignments['Catcher'] != null);
{% endprettify %}

Refer to the [Map API reference][Map] for a full list of methods.

#### Common collection methods

List, Set, and Map share common functionality found in many collections.
Some of this common functionality is defined by the Iterable class,
which List and Set implement.

<div class="alert alert-info" markdown="1">
**Note:**
Although Map doesn’t implement Iterable, you can get Iterables from it
using the Map `keys` and `values` properties.
</div>

Use `isEmpty` or `isNotEmpty` to check whether a list, set, or map has items:

<?code-excerpt "misc/test/library_tour/core_test.dart (isEmpty)"?>
{% prettify dart %}
var coffees = [];
var teas = ['green', 'black', 'chamomile', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
{% endprettify %}

To apply a function to each item in a list, set, or map, you can use
`forEach()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (List.forEach)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

teas.forEach((tea) => print('I drink $tea'));
{% endprettify %}

When you invoke `forEach()` on a map, your function must take two
arguments (the key and value):

<?code-excerpt "misc/test/library_tour/core_test.dart (Map.forEach)"?>
{% prettify dart %}
hawaiianBeaches.forEach((k, v) {
  print('I want to visit $k and swim at $v');
  // I want to visit Oahu and swim at
  // [Waikiki, Kailua, Waimanalo], etc.
});
{% endprettify %}

Iterables provide the `map()` method, which gives you all the results in
a single object:

<?code-excerpt "misc/test/library_tour/core_test.dart (List.map)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

var loudTeas = teas.map((tea) => tea.toUpperCase());
loudTeas.forEach(print);
{% endprettify %}

<div class="alert alert-info" markdown="1">
**Note:**
The object returned by `map()` is an Iterable that’s *lazily
evaluated*: your function isn’t called until you ask for an item from
the returned object.
</div>

To force your function to be called immediately on each item, use
`map().toList()` or `map().toSet()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (toList)"?>
{% prettify dart %}
var loudTeas =
    teas.map((tea) => tea.toUpperCase()).toList();
{% endprettify %}

Use Iterable’s `where()` method to get all the items that match a
condition. Use Iterable’s `any()` and `every()` methods to check whether
some or all items match a condition.
{% comment %}
PENDING: Change example as suggested by floitsch to have (maybe)
cities instead of isDecaffeinated.
{% endcomment %}


<?code-excerpt "misc/test/library_tour/core_test.dart (where-etc)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

// Chamomile is not caffeinated.
bool isDecaffeinated(String teaName) =>
    teaName == 'chamomile';

// Use where() to find only the items that return true
// from the provided function.
var decaffeinatedTeas =
    teas.where((tea) => isDecaffeinated(tea));
// or teas.where(isDecaffeinated)

// Use any() to check whether at least one item in the
// collection satisfies a condition.
assert(teas.any(isDecaffeinated));

// Use every() to check whether all the items in a
// collection satisfy a condition.
assert(!teas.every(isDecaffeinated));
{% endprettify %}

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
{% prettify dart %}
var uri = 'http://example.org/api?foo=some message';

var encoded = Uri.encodeFull(uri);
assert(encoded ==
    'http://example.org/api?foo=some%20message');

var decoded = Uri.decodeFull(encoded);
assert(uri == decoded);
{% endprettify %}

Notice how only the space between `some` and `message` was encoded.

#### Encoding and decoding URI components

To encode and decode all of a string’s characters that have special
meaning in a URI, including (but not limited to) `/`, `&`, and `:`, use
the `encodeComponent()` and `decodeComponent()` methods.

<?code-excerpt "misc/test/library_tour/core_test.dart (encodeComponent)"?>
{% prettify dart %}
var uri = 'http://example.org/api?foo=some message';

var encoded = Uri.encodeComponent(uri);
assert(encoded ==
    'http%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message');

var decoded = Uri.decodeComponent(encoded);
assert(uri == decoded);
{% endprettify %}

Notice how every special character is encoded. For example, `/` is
encoded to `%2F`.

#### Parsing URIs

If you have a Uri object or a URI string, you can get its parts using
Uri fields such as `path`. To create a Uri from a string, use the
`parse()` static method:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri.parse)"?>
{% prettify dart %}
var uri =
    Uri.parse('http://example.org:8080/foo/bar#frag');

assert(uri.scheme == 'http');
assert(uri.host == 'example.org');
assert(uri.path == '/foo/bar');
assert(uri.fragment == 'frag');
assert(uri.origin == 'http://example.org:8080');
{% endprettify %}

See the [Uri API reference][Uri] for more URI components that you can get.

#### Building URIs

You can build up a URI from individual parts using the `Uri()`
constructor:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri)"?>
{% prettify dart %}
var uri = Uri(
    scheme: 'http',
    host: 'example.org',
    path: '/foo/bar',
    fragment: 'frag');
assert(
    uri.toString() == 'http://example.org/foo/bar#frag');
{% endprettify %}


### Dates and times

A DateTime object is a point in time. The time zone is either UTC or the
local time zone.

You can create DateTime objects using several constructors:

<?code-excerpt "misc/test/library_tour/core_test.dart (DateTime)"?>
{% prettify dart %}
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000,
    isUtc: true);

// Parse an ISO 8601 date.
y2k = DateTime.parse('2000-01-01T00:00:00Z');
{% endprettify %}

The `millisecondsSinceEpoch` property of a date returns the number of
milliseconds since the “Unix epoch”—January 1, 1970, UTC:

<?code-excerpt "misc/test/library_tour/core_test.dart (millisecondsSinceEpoch)"?>
{% prettify dart %}
// 1/1/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
{% endprettify %}

Use the Duration class to calculate the difference between two dates and
to shift a date forward or backward:

<?code-excerpt "misc/test/library_tour/core_test.dart (Duration)"?>
{% prettify dart %}
var y2k = DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 = y2001.subtract(Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calculate the difference between two dates.
// Returns a Duration object.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k was a leap year.
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Warning:**
Using a Duration to shift a DateTime by days can be problematic, due
to clock shifts (to daylight saving time, for example). Use UTC dates
if you must shift days.
</div>

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
{% prettify dart %}
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
{% endprettify %}

#### Implementing map keys

Each object in Dart automatically provides an integer hash code, and
thus can be used as a key in a map. However, you can override the
`hashCode` getter to generate a custom hash code. If you do, you might
also want to override the `==` operator. Objects that are equal (via
`==`) must have identical hash codes. A hash code doesn’t have to be
unique, but it should be well distributed.

{% comment %}
Note: There’s disagreement over whether to include identical() in the ==
implementation. It might improve speed, at least when you need to
compare many fields. They don’t do identical() automatically because, by
convention, NaN != NaN.
{% endcomment %}

<?code-excerpt "misc/lib/library_tour/core/hash_code.dart"?>
{% prettify dart %}
class Person {
  final String firstName, lastName;

  Person(this.firstName, this.lastName);

  // Override hashCode using strategy from Effective Java,
  // Chapter 11.
  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + firstName.hashCode;
    result = 37 * result + lastName.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! Person) return false;
    Person person = other;
    return (person.firstName == firstName &&
        person.lastName == lastName);
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
{% endprettify %}

#### Iteration

The [Iterable][] and [Iterator][] classes
support for-in loops. Extend (if possible) or implement Iterable
whenever you create a class that can provide Iterators for use in for-in
loops. Implement Iterator to define the actual iteration ability.

<?code-excerpt "misc/lib/library_tour/core/iterator.dart"?>
{% prettify dart %}
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
  for (var process in Processes()) {
    // Do something with the process.
  }
}
{% endprettify %}


### Exceptions

The Dart core library defines many common exceptions and errors.
Exceptions are considered conditions that you can plan ahead for and
catch. Errors are conditions that you don’t expect or plan for.

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
{% prettify dart %}
class FooException implements Exception {
  final String msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
{% endprettify %}

For more information, see
[Exceptions](/guides/language/language-tour#exceptions) 
(in the language tour) and the [Exception API reference.][Exception]


## dart:async - asynchronous programming

Asynchronous programming often uses callback functions, but Dart
provides alternatives: [Future][] and [Stream][] objects. A
Future is like a promise for a result to be provided sometime in the
future. A Stream is a way to get a sequence of values, such as events.
Future, Stream, and more are in the
dart:async library ([API reference][dart:async]).

<div class="alert alert-info" markdown="1">
**Note:**
You don't always need to use the Future or Stream APIs directly.
The Dart language supports asynchronous coding
using keywords such as `async` and `await`.
See [Asynchrony support](/guides/language/language-tour#asynchrony-support)
in the language tour for details.
</div>

The dart:async library works in both web apps and command-line apps. To
use it, import dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
{% prettify dart %}
import 'dart:async';
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **Version note:**
  As of Dart 2.1, you don't need to import dart:async to
  use the Future and Stream APIs, because dart:core exports those classes.
</aside>

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
{% prettify dart %}
runUsingFuture() {
  // ...
  findEntryPoint().then((entryPoint) {
    return runExecutable(entryPoint, args);
  }).then(flushThenExit);
}
{% endprettify %}

The equivalent code with await expressions
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/future.dart (runUsingAsyncAwait)"?>
{% prettify dart %}
runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
{% endprettify %}

An async function can catch exceptions from Futures.
For example:

<?code-excerpt "misc/lib/library_tour/async/future.dart (catch)"?>
{% prettify dart %}
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Important:**
Async functions return Futures.
If you don't want your function to return a future,
then use a different solution.
For example, you might call an async function from your function.
</div>

For more information on using `await` and related Dart language features,
see [Asynchrony support](/guides/language/language-tour#asynchrony-support).


#### Basic usage

{% comment %}
[PENDING: Delete much of the following content in favor of the tutorial coverage?]
{% endcomment %}

You can use `then()` to schedule code that runs when the future completes. For
example, `HttpRequest.getString()` returns a Future, since HTTP requests
can take a while. Using `then()` lets you run some code when that Future
has completed and the promised string value is available:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
{% prettify dart %}
HttpRequest.getString(url).then((String result) {
  print(result);
});
{% endprettify %}

Use `catchError()` to handle any errors or exceptions that a Future
object might throw.

<?code-excerpt "misc/lib/library_tour/async/basic.dart (catchError)"?>
{% prettify dart %}
HttpRequest.getString(url).then((String result) {
  print(result);
}).catchError((e) {
  // Handle or ignore the error.
});
{% endprettify %}

The `then().catchError()` pattern is the asynchronous version of
`try`-`catch`.

<div class="alert alert-warning" markdown="1">
**Important:**
Be sure to invoke `catchError()` on the result of `then()`—not on the
result of the original Future. Otherwise, the `catchError()` can
handle errors only from the original Future's computation, but not
from the handler registered by `then()`.
</div>


#### Chaining multiple asynchronous methods

The `then()` method returns a Future, providing a useful way to run
multiple asynchronous functions in a certain order. If the callback
registered with `then()` returns a Future, `then()` returns an
equivalent Future. If the callback returns a value of any other type,
`then()` creates a new Future that completes with the value.

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain)"?>
{% prettify dart %}
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
  /* Handle exception... */
});
{% endprettify %}

In the preceding example, the methods run in the following order:

1.  `costlyQuery()`
2.  `expensiveWork()`
3.  `lengthyComputation()`

Here is the same code written using await:

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain-as-await)"?>
{% prettify dart %}
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
{% endprettify %}


#### Waiting for multiple futures

Sometimes your algorithm needs to invoke many asynchronous functions and
wait for them all to complete before continuing. Use the [Future.wait()][]
static method to manage multiple Futures and wait for them to complete:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
{% prettify dart %}
Future deleteLotsOfFiles() async =>  ...
Future copyLotsOfFiles() async =>  ...
Future checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
{% endprettify %}


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

<!-- OLD dart-tutorials-samples/cmdline/bin/dgrep.dart -->
<?code-excerpt "misc/lib/library_tour/async/stream.dart (listen)" replace="/listen/[!$&!]/g"?>
{% prettify dart %}
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir
          .list(
              recursive: argResults[recursive],
              followLinks: argResults[followLinks])
          .[!listen!]((entity) {
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
{% prettify dart %}
Future main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    [!await for!] (var entity in startingDir.list(
        recursive: argResults[recursive],
        followLinks: argResults[followLinks])) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Important:**
Before using `await for`, make sure that it makes the code clearer
and that you really do want to wait for all of the stream's results.
For example, you usually should **not** use `await for` for DOM event listeners,
because the DOM sends endless streams of events.
If you use `await for` to register two DOM event listeners in a row,
then the second kind of event is never handled.
</div>

For more information on using `await` and related
Dart language features, see
[Asynchrony support](/guides/language/language-tour#asynchrony-support).


#### Listening for stream data

To get each value as it arrives, either use `await for` or
subscribe to the stream using the `listen()` method:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/await for/[!$&!]/g"?>
{% prettify dart %}
// Find a button by ID and add an event handler.
querySelector('#submitInfo').onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
{% endprettify %}

In this example, the `onClick` property is a Stream object provided by
the "submitInfo" button.

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
{% prettify dart %}
var lines = inputStream
    .transform(utf8.decoder)
    .transform(LineSplitter());
{% endprettify %}

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
{% prettify dart %}
Future readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(utf8.decoder)
      .transform(LineSplitter());
  [!try!] {
    await for (var line in lines) {
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
{% prettify dart %}
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .listen((String line) {
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
Also see these articles and tutorials:

-   [Asynchronous Programming: Futures](/tutorials/language/futures)
-   [Futures and Error Handling](/guides/libraries/futures-error-handling)
-   [Asynchronous Programming: Streams](/tutorials/language/streams)
-   [Creating Streams in Dart](/articles/libraries/creating-streams)
{% comment %}
[PENDING: update/remove article link]
-   [The Event Loop and Dart](/articles/performance/event-loop)
{% endcomment %}


## dart:math - math and random

The dart:math library ([API reference][dart:math])
provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use this library in your app, import dart:math.

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
{% prettify dart %}
import 'dart:math';
{% endprettify %}


### Trigonometry

The Math library provides basic trigonometric functions:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
{% prettify dart %}
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
{% endprettify %}

<div class="alert alert-info" markdown="1">
**Note:**
These functions use radians, not degrees!
</div>


### Maximum and minimum

The Math library provides `max()` and `min()` methods:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
{% prettify dart %}
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
{% endprettify %}


### Math constants

Find your favorite constants—*pi*, *e*, and more—in the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
{% prettify dart %}
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
{% endprettify %}


### Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (Random)"?>
{% prettify dart %}
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
{% endprettify %}

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (Random-bool)"?>
{% prettify dart %}
var random = Random();
random.nextBool(); // true or false
{% endprettify %}


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

The dart:convert library works in both web apps and command-line apps.
To use it, import dart:convert.

<?code-excerpt "misc/test/library_tour/convert_test.dart (import)"?>
{% prettify dart %}
import 'dart:convert';
{% endprettify %}


### Decoding and encoding JSON

Decode a JSON-encoded string into a Dart object with `jsonDecode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-decode)"?>
{% prettify dart %}
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
{% endprettify %}

Encode a supported Dart object into a JSON-formatted string with
`jsonEncode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-encode)"?>
{% prettify dart %}
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
{% endprettify %}

Only objects of type int, double, String, bool, null, List, or Map (with
string keys) are directly encodable into JSON. List and Map objects are
encoded recursively.

You have two options for encoding objects that aren't directly
encodable. The first is to invoke `encode()` with a second argument: a
function that returns an object that is directly encodable. Your second
option is to omit the second argument, in which case the encoder calls
the object's `toJson()` method.

For more examples and links to JSON-related packages, see
[JSON Support](/guides/json).


### Decoding and encoding UTF-8 characters

Use `utf8.decode()` to decode UTF8-encoded bytes to a Dart string:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-decode)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
{% endprettify %}

To convert a stream of UTF-8 characters into a Dart string, specify
`utf8.decoder` to the Stream `transform()` method:

<?code-excerpt "misc/test/library_tour/io_test.dart (utf8-decoder)" replace="/utf8.decoder/[!$&!]/g"?>
{% prettify dart %}
var lines = inputStream
    .transform([!utf8.decoder!])
    .transform(LineSplitter());
try {
  await for (var line in lines) {
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
{% prettify dart %}
List<int> encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
{% endprettify %}


### Other functionality

The dart:convert library also has converters for ASCII and ISO-8859-1
(Latin1). For details, see the [API reference for the dart:convert library.][dart:convert]


## dart:html - browser-based apps {#darthtml}

{% include dart-html-tour.md %}


## dart:io - I/O for servers and command-line apps {#dartio}

{% include dart-io-tour.md %}


## Summary

This page introduced you to the most commonly used functionality in
Dart’s built-in libraries. It didn’t cover all the built-in
libraries, however. Others that you might want to look into include
[dart:collection][] and [dart:typed\_data,][dart:typed\_data]
as well as platform-specific libaries like the
[Dart web development libraries][webdev libraries]
and the [Flutter libraries.][docs.flutter]

You can get yet more libraries by using the [pub package manager](/guides/packages). The
[collection,]({{site.pub}}/packages/collection)
[crypto,]({{site.pub}}/packages/crypto)
[http,]({{site.pub}}/packages/http)
[intl,]({{site.pub}}/packages/intl) and
[test]({{site.pub}}/packages/test) libraries are just a
sampling of what you can install using pub.

To learn more about the Dart language, see the
[language tour][].

[language tour]: /guides/language/language-tour
[docs.flutter]: {{site.flutter_api}}
[pub.dartlang]: {{site.pub}}
[DartPad]: {{site.dartpad}}
[Assert]: /guides/language/language-tour#assert
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[Comparable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Comparable-class.html
[dart:core]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart:async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart:collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart:convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:io tour]: #dartio
[dart:math]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart:typed\_data]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[Dart API]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}
[DateTime]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/DateTime-class.html
[double]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double-class.html
[Duration]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Duration-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[Future.wait()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/wait.html
[IndexedDB]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[int]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int-class.html
[Iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterator-class.html
[JSON]: https://www.json.org/
[List]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[Map]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Match]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Match-class.html
[NoSuchMethodError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError-class.html
[num]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num-class.html
[Object]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[Pattern]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Pattern-class.html
[Random]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random-class.html
[RegExp]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/RegExp-class.html
[Set]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[Stream]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[String]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String-class.html
[StringBuffer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StringBuffer-class.html
[Symbol]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html
[toStringAsFixed()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsPrecision.html
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[web audio]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[Uri]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[webdev libraries]: /web/libraries
