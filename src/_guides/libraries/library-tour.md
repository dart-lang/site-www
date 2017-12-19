---
layout: guide
title: "A Tour of the Dart Libraries"
description: "Learn about the major features in Dart's libraries."
short-title: Library Tour
---

This page shows you how to use the major features in Dart’s
libraries. It’s just an overview, and by no means comprehensive.
Whenever you need more details about a class, consult the [Dart API
reference.][Dart API]

To learn more about the Dart language, see
[A Tour of the Dart Language](/guides/language/language-tour).

## dart:core - numbers, collections, strings, and more

The Dart core library provides a small but critical set of built-in
functionality. This library is automatically imported into every Dart
program.


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
can’t change them. If you look closely at the [String API docs,][String]
you’ll notice that
none of the methods actually changes the state of a String. For example,
the method `replaceAll()` returns a new String without changing the
original String:

<?code-excerpt "misc/test/library_tour/core_test.dart (replace)"?>
{% prettify dart %}
var greetingTemplate = 'Hello, NAME!';
var greeting =
    greetingTemplate.replaceAll(new RegExp('NAME'), 'Bob');

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
var sb = new StringBuffer();
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
var numbers = new RegExp(r'\d+');

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
var numbers = new RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(numbers.hasMatch(someDigits));

// Loop through all matches.
for (var match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
{% endprettify %}

#### More information

Refer to the [String API docs][String] for a full list of
methods. Also see the API docs for [StringBuffer,][StringBuffer]
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
var vegetables = new List();

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

<?code-excerpt "misc/test/library_tour/core_test.dart (List<T>)"?>
{% prettify dart %}
// This list should contain only strings.
var fruits = new List<String>();

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);

// Generates static analysis warning, num is not a string.
fruits.add(5); // BAD: Throws exception in checked mode.
{% endprettify %}

{% include checked-mode-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}

Refer to the [List API docs][List] for a full list of methods.

#### Sets

A set in Dart is an unordered collection of unique items. Because a set
is unordered, you can’t get a set’s items by index (position).

<?code-excerpt "misc/test/library_tour/core_test.dart (Set)"?>
{% prettify dart %}
var ingredients = new Set();
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
var ingredients = new Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Check whether an item is in the set.
assert(ingredients.contains('titanium'));

// Check whether all the items are in the set.
assert(ingredients.containsAll(['titanium', 'xenon']));
{% endprettify %}

An intersection is a set whose items are in two other sets.

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
{% prettify dart %}
var ingredients = new Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = new Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
{% endprettify %}

Refer to the [Set API docs][Set] for a full list of methods.

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
var searchTerms = new Map();

// Maps are parameterized types; you can specify what
// types the key and value should be.
var nobleGases = new Map<int, String>();
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
assert(new Set.from(keys).contains('Oahu'));

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

Refer to the [Map API docs][Map] for a full list of methods.

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

For a full list of methods, refer to the [Iterable API docs,][Iterable] as well as those
for [List,][List] [Set,][Set] and [Map.][Map]


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

See the [Uri API docs][Uri] for more URI components that you can get.

#### Building URIs

You can build up a URI from individual parts using the `Uri()`
constructor:

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri)"?>
{% prettify dart %}
var uri = new Uri(
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
var now = new DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = new DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = new DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = new DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = new DateTime.fromMillisecondsSinceEpoch(946684800000,
    isUtc: true);

// Parse an ISO 8601 date.
y2k = DateTime.parse('2000-01-01T00:00:00Z');
{% endprettify %}

The `millisecondsSinceEpoch` property of a date returns the number of
milliseconds since the “Unix epoch”—January 1, 1970, UTC:

<?code-excerpt "misc/test/library_tour/core_test.dart (millisecondsSinceEpoch)"?>
{% prettify dart %}
// 1/1/2000, UTC
var y2k = new DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = new DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
{% endprettify %}

Use the Duration class to calculate the difference between two dates and
to shift a date forward or backward:

<?code-excerpt "misc/test/library_tour/core_test.dart (Duration)"?>
{% prettify dart %}
var y2k = new DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 =
    y2001.subtract(const Duration(days: 30));
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

Refer to the API docs for [DateTime][] and [Duration][] for a full list of methods.


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
  var p1 = new Person('Bob', 'Smith');
  var p2 = new Person('Bob', 'Smith');
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
  final Iterator<Process> iterator = new ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (var process in new Processes()) {
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

For more information, see [Exceptions](#exceptions) and the [Exception API docs.][Exception]


## dart:async - asynchronous programming

Asynchronous programming often uses callback functions, but Dart
provides alternatives: [Future][] and [Stream][] objects. A
Future is like a promise for a result to be provided sometime in the
future. A Stream is a way to get a sequence of values, such as events.
Future, Stream, and more are in the [dart:async][] library.

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
      final startingDir = new Directory(searchPath);
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
      searchFile(new File(searchPath), searchTerms);
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
    final startingDir = new Directory(searchPath);
    [!await for!] (var entity in startingDir.list(
        recursive: argResults[recursive],
        followLinks: argResults[followLinks])) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(new File(searchPath), searchTerms);
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
    .transform(UTF8.decoder)
    .transform(new LineSplitter());
{% endprettify %}

This example uses two transformers. First it uses UTF8.decoder to
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
  var config = new File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(UTF8.decoder)
      .transform(new LineSplitter());
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
var config = new File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream
    .transform(UTF8.decoder)
    .transform(new LineSplitter())
    .listen((String line) {
  print('Got ${line.length} characters from stream');
}, [!onDone!]: () {
  print('file is now closed');
}, [!onError!]: (e) {
  print(e);
});
{% endprettify %}


### More information

For some examples of using Future and Stream in command-line apps, see the
[dart:io section](#dartio---io-for-command-line-apps).
Also see these articles and tutorials:

-   [Asynchronous Programming: Futures](/tutorials/language/futures)
-   [Futures and Error Handling](/guides/libraries/futures-error-handling)
-   [The Event Loop and Dart]({{site.webdev}}/articles/performance/event-loop)
-   [Asynchronous Programming: Streams](/tutorials/language/streams)
-   [Creating Streams in Dart](/articles/libraries/creating-streams)


## dart:math - math and random

The Math library provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use the Math library in your app, import dart:math. The following
examples use the prefix `math` to make clear which top-level functions
and constants are from the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
{% prettify dart %}
import 'dart:math';
{% endprettify %}


### Trigonometry

The Math library provides basic trigonometric functions:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
{% prettify dart %}
// Cosine
assert(cos(PI) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (PI / 180);
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
print(E); // 2.718281828459045
print(PI); // 3.141592653589793
print(SQRT2); // 1.4142135623730951
{% endprettify %}


### Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (Random)"?>
{% prettify dart %}
var random = new Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
{% endprettify %}

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (Random-bool)"?>
{% prettify dart %}
var random = new Random();
random.nextBool(); // true or false
{% endprettify %}


### More information

Refer to the [Math API docs][dart:math] for a full list of methods.
Also see the API docs for [num,][num] [int,][int] and [double.][double]

## dart:html - browser-based apps

Use the [dart:html library][dart:html] to
program the browser, manipulate objects and elements in the DOM, and
access HTML5 APIs. DOM stands for *Document Object Model*, which
describes the hierarchy of an HTML page.

Other common uses of dart:html are manipulating styles (*CSS*), getting
data using HTTP requests, and exchanging data using
[WebSockets](#sending-and-receiving-real-time-data-with-websockets).
HTML5 (and dart:html) has many
additional APIs that this section doesn’t cover. Only web apps can use
dart:html, not command-line apps.

<div class="alert alert-info" markdown="1">
**Note:**
For higher level approaches to web app UIs, see
[AngularDart]({{site.webdev}}/angular) and
[Polymer Dart](https://github.com/dart-lang/polymer-dart/wiki).
</div>

To use the HTML library in your web app, import dart:html:

<?code-excerpt "misc/lib/library_tour/html.dart (import)"?>
{% prettify dart %}
import 'dart:html';
{% endprettify %}

### Manipulating the DOM

To use the DOM, you need to know about *windows*, *documents*,
*elements*, and *nodes*.

A [Window][] object represents
the actual window of the web browser. Each Window has a Document object,
which points to the document that's currently loaded. The Window object
also has accessors to various APIs such as IndexedDB (for storing data),
requestAnimationFrame (for animations), and more. In tabbed browsers,
each tab has its own Window object.

With the [Document][] object, you can create and manipulate [Element][] objects
within the document. Note that the document itself is an element and can be
manipulated.

The DOM models a tree of
[Nodes.][Nodes] These nodes are often
elements, but they can also be attributes, text, comments, and other DOM
types. Except for the root node, which has no parent, each node in the
DOM has one parent and might have many children.

#### Finding elements

To manipulate an element, you first need an object that represents it.
You can get this object using a query.

Find one or more elements using the top-level functions
`querySelector()` and `querySelectorAll()`. You can query by ID, class, tag, name, or
any combination of these. The [CSS Selector Specification
guide](http://www.w3.org/TR/css3-selectors/) defines the formats of the
selectors such as using a \# prefix to specify IDs and a period (.) for
classes.

The `querySelector()` function returns the first element that matches
the selector, while `querySelectorAll()`returns a collection of elements
that match the selector.

<?code-excerpt "misc/lib/library_tour/html.dart (querySelector)"?>
{% prettify dart %}
// Find an element by id (an-id).
Element elem1 = querySelector('#an-id');

// Find an element by class (a-class).
Element elem2 = querySelector('.a-class');

// Find all elements by tag (<div>).
List<Element> elems1 = querySelectorAll('div');

// Find all text inputs.
List<Element> elems2 = querySelectorAll(
  'input[type="text"]',
);

// Find all elements with the CSS class 'class'
// inside of a <p> that is inside an element with
// the ID 'id'.
List<Element> elems3 = querySelectorAll('#id p.class');
{% endprettify %}

#### Manipulating elements

You can use properties to change the state of an element. Node and its
subtype Element define the properties that all elements have. For
example, all elements have `classes`, `hidden`, `id`, `style`, and
`title` properties that you can use to set state. Subclasses of Element
define additional properties, such as the `href` property of
[AnchorElement.][AnchorElement]

Consider this example of specifying an anchor element in HTML:

<?code-excerpt "misc/test/library_tour/html_test.dart (anchor-html)" replace="/.*'(.*?)'.*/$1/g"?>
{% prettify html %}
<a id="example" href="http://example.com">link text</a>
{% endprettify %}

This \<a\> tag specifies an element with an `href` attribute and a text
node (accessible via a `text` property) that contains the string
“linktext”. To change the URL that the link goes to, you can use
AnchorElement’s `href` property:

<?code-excerpt "misc/test/library_tour/html_test.dart (href)"?>
{% prettify dart %}
var anchor = querySelector('#example') as AnchorElement;
anchor.href = 'http://dartlang.org';
{% endprettify %}

Often you need to set properties on multiple elements. For example, the
following code sets the `hidden` property of all elements that have a
class of “mac”, “win”, or “linux”. Setting the `hidden` property to true
has the same effect as adding `display:none` to the CSS.

<?code-excerpt "misc/test/library_tour/html_test.dart (os-html)" replace="/.*? = '''|''';$//g"?>
{% prettify dart %}
<!-- In HTML: -->
<p>
  <span class="linux">Words for Linux</span>
  <span class="macos">Words for Mac</span>
  <span class="windows">Words for Windows</span>
</p>
{% endprettify %}

<?code-excerpt "misc/test/library_tour/html_test.dart (os)"?>
{% prettify dart %}
// In Dart:
final osList = ['macos', 'windows', 'linux'];
final userOs = determineUserOs();

// For each possible OS...
for (var os in osList) {
  // Matches user OS?
  bool shouldShow = (os == userOs);

  // Find all elements with class=os. For example, if
  // os == 'windows', call querySelectorAll('.windows')
  // to find all elements with the class "windows".
  // Note that '.$os' uses string interpolation.
  for (var elem in querySelectorAll('.$os')) {
    elem.hidden = !shouldShow; // Show or hide.
  }
}
{% endprettify %}

When the right property isn’t available or convenient, you can use
Element’s `attributes` property. This property is a
`Map<String, String>`, where the keys are attribute names. For a list of
attribute names and their meanings, see the [MDN Attributes
page.](https://developer.mozilla.org/en/HTML/Attributes) Here’s an
example of setting an attribute’s value:

<?code-excerpt "misc/lib/library_tour/html.dart (attributes)"?>
{% prettify dart %}
elem.attributes['someAttribute'] = 'someValue';
{% endprettify %}

#### Creating elements

You can add to existing HTML pages by creating new elements and
attaching them to the DOM. Here’s an example of creating a paragraph
(\<p\>) element:

<?code-excerpt "misc/lib/library_tour/html.dart (creating-elements)"?>
{% prettify dart %}
var elem = new ParagraphElement();
elem.text = 'Creating is easy!';
{% endprettify %}

You can also create an element by parsing HTML text. Any child elements
are also parsed and created.

<?code-excerpt "misc/lib/library_tour/html.dart (creating-from-html)"?>
{% prettify dart %}
var elem2 = new Element.html(
  '<p>Creating <em>is</em> easy!</p>',
);
{% endprettify %}

Note that `elem2` is a `ParagraphElement` in the preceding example.

Attach the newly created element to the document by assigning a parent
to the element. You can add an element to any existing element’s
children. In the following example, `body` is an element, and its child
elements are accessible (as a List\<Element\>) from the `children`
property.

<?code-excerpt "misc/lib/library_tour/html.dart (body-children-add)"?>
{% prettify dart %}
document.body.children.add(elem2);
{% endprettify %}

#### Adding, replacing, and removing nodes

Recall that elements are just a kind of node. You can find all the
children of a node using the `nodes` property of Node, which returns a
List\<Node\> (as opposed to `children`, which omits non-Element nodes).
Once you have this list, you can use the usual List methods and
operators to manipulate the children of the node.

To add a node as the last child of its parent, use the List `add()`
method:

<?code-excerpt "misc/lib/library_tour/html.dart (nodes-add)"?>
{% prettify dart %}
querySelector('#inputs').nodes.add(elem);
{% endprettify %}

To replace a node, use the Node `replaceWith()` method:

<?code-excerpt "misc/lib/library_tour/html.dart (replaceWith)"?>
{% prettify dart %}
querySelector('#status').replaceWith(elem);
{% endprettify %}

To remove a node, use the Node `remove()` method:

<?code-excerpt "misc/lib/library_tour/html.dart (remove)"?>
{% prettify dart %}
// Find a node by ID, and remove it from the DOM.
querySelector('#expendable').remove();
{% endprettify %}

#### Manipulating CSS styles

CSS, or *cascading style sheets*, defines the presentation styles of DOM
elements. You can change the appearance of an element by attaching ID
and class attributes to it.

Each element has a `classes` field, which is a list. Add and remove CSS
classes simply by adding and removing strings from this collection. For
example, the following sample adds the `warning` class to an element:

<?code-excerpt "misc/lib/library_tour/html.dart (classes-add)"?>
{% prettify dart %}
var elem = querySelector('#message');
elem.classes.add('warning');
{% endprettify %}

It’s often very efficient to find an element by ID. You can dynamically
set an element ID with the `id` property:

<?code-excerpt "misc/lib/library_tour/html.dart (set-id)"?>
{% prettify dart %}
var message = new DivElement();
message.id = 'message2';
message.text = 'Please subscribe to the Dart mailing list.';
{% endprettify %}

You can reduce the redundant text in this example by using method
cascades:

<?code-excerpt "misc/lib/library_tour/html.dart (elem-set-cascade)"?>
{% prettify dart %}
var message = new DivElement()
  ..id = 'message2'
  ..text = 'Please subscribe to the Dart mailing list.';
{% endprettify %}

While using IDs and classes to associate an element with a set of styles
is best practice, sometimes you want to attach a specific style directly
to the element:

<?code-excerpt "misc/lib/library_tour/html.dart (set-style)"?>
{% prettify dart %}
message.style
  ..fontWeight = 'bold'
  ..fontSize = '3em';
{% endprettify %}

#### Handling events

To respond to external events such as clicks, changes of focus, and
selections, add an event listener. You can add an event listener to any
element on the page. Event dispatch and propagation is a complicated
subject; [research the
details](http://www.w3.org/TR/DOM-Level-3-Events/#dom-event-architecture)
if you’re new to web programming.

Add an event handler using
<code><em>element</em>.on<em>Event</em>.listen(<em>function</em>)</code>,
where <code><em>Event</em></code> is the event
name and <code><em>function</em></code> is the event handler.

For example, here’s how you can handle clicks on a button:

<?code-excerpt "misc/lib/library_tour/html.dart (onClick)"?>
{% prettify dart %}
// Find a button by ID and add an event handler.
querySelector('#submitInfo').onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
{% endprettify %}

Events can propagate up and down through the DOM tree. To discover which
element originally fired the event, use `e.target`:

<?code-excerpt "misc/lib/library_tour/html.dart (target)"?>
{% prettify dart %}
document.body.onClick.listen((e) {
  final clickedElem = e.target;
  // ...
});
{% endprettify %}

To see all the events for which you can register an event listener, look
for "onEventType" properties in the API docs for [Element][] and its
subclasses. Some common events include:

-   change
-   blur
-   keyDown
-   keyUp
-   mouseDown
-   mouseUp


### Using HTTP resources with HttpRequest

Formerly known as XMLHttpRequest, the [HttpRequest][] class
gives you access to HTTP resources from within your browser-based app.
Traditionally, AJAX-style apps make heavy use of HttpRequest. Use
HttpRequest to dynamically load JSON data or any other resource from a
web server. You can also dynamically send data to a web server.


#### Getting data from the server

The HttpRequest static method `getString()` is an easy way to get data
from a web server. Use `await` with the `getString()` call
to ensure that you have the data before continuing execution.

<?code-excerpt "misc/test/library_tour/html_test.dart (getString)" replace="/await.*;/[!$&!]/g"?>
{% prettify dart %}
Future main() async {
  String pageHtml = [!await HttpRequest.getString(url);!]
  // Do something with pageHtml...
}
{% endprettify %}

Use try-catch to specify an error handler:

<?code-excerpt "misc/lib/library_tour/html.dart (try-getString)"?>
{% prettify dart %}
try {
  var data = await HttpRequest.getString(jsonUri);
  // Process data...
} catch (e) {
  // Handle exception...
}
{% endprettify %}

If you need access to the HttpRequest, not just the text data it
retrieves, you can use the `request()` static method instead of
`getString()`. Here’s an example of reading XML data:

<?code-excerpt "misc/test/library_tour/html_test.dart (request)" replace="/await.*;/[!$&!]/g"?>
{% prettify dart %}
Future main() async {
  HttpRequest req = await HttpRequest.request(
    url,
    method: 'HEAD',
  );
  if (req.status == 200) {
    // Successful URL access...
  }
  // ...
}
{% endprettify %}

You can also use the full API to handle more interesting cases. For
example, you can set arbitrary headers.

The general flow for using the full API of HttpRequest is as follows:

1.  Create the HttpRequest object.
2.  Open the URL with either `GET` or `POST`.
3.  Attach event handlers.
4.  Send the request.

For example:

{% comment %}
TODO: use original source from dart-tutorials-samples/web/portmanteaux/portmanteaux.dart
{% endcomment %}

<?code-excerpt "misc/lib/library_tour/html.dart (new-HttpRequest)"?>
{% prettify dart %}
var request = new HttpRequest();
request
  ..open('POST', url)
  ..onLoadEnd.listen((e) => requestComplete(request))
  ..send(encodedData);
{% endprettify %}

#### Sending data to the server

HttpRequest can send data to the server using the HTTP method POST. For
example, you might want to dynamically submit data to a form handler.
Sending JSON data to a RESTful web service is another common example.

Submitting data to a form handler requires you to provide name-value
pairs as URI-encoded strings. (Information about the URI class is in
the [URIs section](#uris).)
You must also set the `Content-type` header to
`application/x-www-form-urlencode` if you wish to send data to a form
handler.

<?code-excerpt "misc/test/library_tour/html_test.dart (POST)"?>
{% prettify dart %}
String encodeMap(Map data) => data.keys
    .map((k) =>
        '${Uri.encodeComponent(k)}=${Uri.encodeComponent(data[k])}')
    .join('&');

Future main() async {
  var data = {'dart': 'fun', 'angular': 'productive'};

  var request = new HttpRequest();
  request
    ..open('POST', url)
    ..setRequestHeader(
      'Content-type',
      'application/x-www-form-urlencoded',
    )
    ..send(encodeMap(data));

  await request.onLoadEnd.first;

  if (request.status == 200) {
    // Successful URL access...
  }
  // ...
}
{% endprettify %}


### Sending and receiving real-time data with WebSockets

A WebSocket allows your web app to exchange data with a server
interactively—no polling necessary. A server creates the WebSocket and
listens for requests on a URL that starts with **ws://**—for example,
ws://127.0.0.1:1337/ws. The data transmitted over a WebSocket can be a
string or a blob.  Often, the data is a JSON-formatted string.

To use a WebSocket in your web app, first create a [WebSocket][] object, passing
the WebSocket URL as an argument:

{% comment %}
Code inspired by:
https://github.com/dart-lang/dart-samples/blob/master/html5/web/websockets/basics/websocket_sample.dart

Once tests are written for the samples, consider getting code excerpts from
the websocket sample app.
{% endcomment %}

<?code-excerpt "misc/test/library_tour/html_test.dart (WebSocket)"?>
{% prettify dart %}
var ws = new WebSocket('ws://echo.websocket.org');
{% endprettify %}

#### Sending data

To send string data on the WebSocket, use the `send()` method:

<?code-excerpt "misc/test/library_tour/html_test.dart (send)"?>
{% prettify dart %}
ws.send('Hello from Dart!');
{% endprettify %}

#### Receiving data

To receive data on the WebSocket, register a listener for message
events:

<?code-excerpt "misc/test/library_tour/html_test.dart (onMessage)"?>
{% prettify dart %}
ws.onMessage.listen((MessageEvent e) {
  print('Received message: ${e.data}');
});
{% endprettify %}

The message event handler receives a [MessageEvent][] object.
This object’s `data` field has the data from the server.

#### Handling WebSocket events

Your app can handle the following WebSocket events: open, close, error,
and (as shown earlier) message. Here’s an example of a method that
creates a WebSocket object and registers handlers for open, close,
error, and message events:

<?code-excerpt "misc/test/library_tour/html_test.dart (initWebSocket)"?>
{% prettify dart %}
void initWebSocket([int retrySeconds = 1]) {
  var reconnectScheduled = false;

  print("Connecting to websocket");

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(seconds: retrySeconds),
          () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    print('Connected');
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    print('Websocket closed, retrying in ' +
        '$retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    print("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    print('Received message: ${e.data}');
  });
}
{% endprettify %}


### More information

This section barely scratched the surface of using the dart:html
library. For more information, see the documentation for [dart:html][].
Dart has additional libraries for more specialized web APIs, such as
[web audio,][web audio] [IndexedDB,][IndexedDB] and [WebGL.][WebGL]


## dart:io - I/O for command-line apps

The [dart:io library][dart:io] provides APIs to
deal with files, directories, processes, sockets, WebSockets, and HTTP
clients and servers.

<div class="alert alert-warning" markdown="1">
  **Important:**
  Only [Flutter mobile apps]({{site.flutter}}), command-line scripts, and servers
  can import and use `dart:io`, not web apps.
</div>

In general, the dart:io library implements and promotes an asynchronous
API. Synchronous methods can easily block an application, making it
difficult to scale. Therefore, most operations return results via Future
or Stream objects, a pattern common with modern server platforms such as
Node.js.

The few synchronous methods in the dart:io library are clearly marked
with a Sync suffix on the method name. Synchronous methods aren't covered here.

To use the dart:io library you must import it:
<?code-excerpt "misc/test/library_tour/io_test.dart (import)"?>
{% prettify dart %}
import 'dart:io';
{% endprettify %}

### Files and directories

The I/O library enables command-line apps to read and write files and
browse directories. You have two choices for reading the contents of a
file: all at once, or streaming. Reading a file all at once requires
enough memory to store all the contents of the file. If the file is very
large or you want to process it while reading it, you should use a
Stream, as described in
[Streaming file contents](#streaming-file-contents).

#### Reading a file as text

When reading a text file encoded using UTF-8, you can read the entire
file contents with `readAsString()`. When the individual lines are
important, you can use `readAsLines()`. In both cases, a Future object
is returned that provides the contents of the file as one or more
strings.

<?code-excerpt "misc/test/library_tour/io_test.dart (readAsString)" replace="/\btest_data\///g"?>
{% prettify dart %}
Future main() async {
  var config = new File('config.txt');
  var contents;

  // Put the whole file in a single string.
  contents = await config.readAsString();
  print('The file is ${contents.length} characters long.');

  // Put each line of the file into its own string.
  contents = await config.readAsLines();
  print('The file is ${contents.length} lines long.');
}
{% endprettify %}


#### Reading a file as binary

The following code reads an entire file as bytes into a list of ints.
The call to `readAsBytes()` returns a Future, which provides the result
when it’s available.

<?code-excerpt "misc/test/library_tour/io_test.dart (readAsBytes)" replace="/\btest_data\///g"?>
{% prettify dart %}
Future main() async {
  var config = new File('config.txt');

  var contents = await config.readAsBytes();
  print('The file is ${contents.length} bytes long.');
}
{% endprettify %}

#### Handling errors

To capture errors so they don't result in uncaught exceptions, you can
register a `catchError` handler on the Future,
or (in an async function) use try-catch:

<?code-excerpt "misc/test/library_tour/io_test.dart (try-catch)" replace="/does-not-exist/config/g"?>
{% prettify dart %}
Future main() async {
  var config = new File('config.txt');
  try {
    var contents = await config.readAsString();
    print(contents);
  } catch (e) {
    print(e);
  }
}
{% endprettify %}

#### Streaming file contents

Use a Stream to read a file, a little at a time.
You can use either the [Stream API](#stream) or `await for`,
part of Dart's [asynchrony support](/guides/language/language-tour#asynchrony-support).

<?code-excerpt "misc/test/library_tour/io_test.dart (read-from-stream)" replace="/_?test_\w*\/?//g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future main() async {
  var config = new File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(UTF8.decoder)
      .transform(new LineSplitter());
  try {
    await for (var line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
{% endprettify %}

#### Writing file contents

You can use an [IOSink][] to
write data to a file. Use the File `openWrite()` method to get an IOSink
that you can write to. The default mode, `FileMode.WRITE`, completely
overwrites existing data in the file.

<?code-excerpt "misc/test/library_tour/io_test.dart (write-file)" replace="/\btest_data\///g"?>
{% prettify dart %}
var logFile = new File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${new DateTime.now()}\n');
await sink.flush();
await sink.close();
{% endprettify %}

To add to the end of the file, use the optional `mode` parameter to
specify `FileMode.APPEND`:

<?code-excerpt "misc/test/library_tour/io_test.dart (append)" replace="/_?test_\w*\/?//g"?>
{% prettify dart %}
var sink = logFile.openWrite(mode: FileMode.APPEND);
{% endprettify %}

To write binary data, use `add(List<int> data)`.


#### Listing files in a directory

Finding all files and subdirectories for a directory is an asynchronous
operation. The `list()` method returns a Stream that emits an object
when a file or directory is encountered.

<?code-excerpt "misc/test/library_tour/io_test.dart (list-dir)" replace="/\btest_data\b/tmp/g"?>
{% prettify dart %}
Future main() async {
  var dir = new Directory('tmp');

  try {
    var dirList = dir.list();
    await for (FileSystemEntity f in dirList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
{% endprettify %}


#### Other common functionality

The File and Directory classes contain other functionality, including
but not limited to:

-   Creating a file or directory: `create()` in File and Directory
-   Deleting a file or directory: `delete()` in File and Directory
-   Getting the length of a file: `length()` in File
-   Getting random access to a file: `open()` in File

Refer to the API docs for [File][] and [Directory][] for a full
list of methods.


### HTTP clients and servers

The dart:io library provides classes that command-line apps can use for
accessing HTTP resources, as well as running HTTP servers.

#### HTTP server

The [HttpServer][] class
provides the low-level functionality for building web servers. You can
match request handlers, set headers, stream data, and more.

The following sample web server returns simple text information.
This server listens on port 8888 and address 127.0.0.1 (localhost),
responding to requests for the path `/dart`. For any other path,
the response is status code 404 (page not found).

<?code-excerpt "misc/lib/library_tour/io/http_server.dart"?>
{% prettify dart %}
Future main() async {
  var requests = await HttpServer.bind('localhost', 8888);
  await for (var request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = new ContentType(
        'text',
        'plain',
      )
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.NOT_FOUND;
  }
  response.close();
}
{% endprettify %}

#### HTTP client

The [HttpClient][] class
helps you connect to HTTP resources from your Dart command-line or
server-side application. You can set headers, use HTTP methods, and read
and write data. The HttpClient class does not work in browser-based
apps. When programming in the browser, use the [HttpRequest
class](#using-http-resources-with-httprequest).
Here’s an example of using HttpClient:

<?code-excerpt "misc/test/library_tour/io_test.dart (client)"?>
{% prettify dart %}
Future main() async {
  var url = Uri.parse('http://localhost:8888/dart');
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(url);
  var response = await request.close();
  var data = await response.transform(UTF8.decoder).toList();
  print('Response ${response.statusCode}: $data');
  httpClient.close();
}
{% endprettify %}


### More information

Besides the APIs discussed in this section, the dart:io library also
provides APIs for [processes,][Process] [sockets,][Socket] and
[web sockets.][WebSocket]

## dart:convert - decoding and encoding JSON, UTF-8, and more

The [dart:convert library][dart:convert]
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

Decode a JSON-encoded string into a Dart object with `JSON.decode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (JSON-decode)"?>
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

var scores = JSON.decode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
{% endprettify %}

Encode a supported Dart object into a JSON-formatted string with
`JSON.encode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (JSON-encode)"?>
{% prettify dart %}
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null}
];

var jsonText = JSON.encode(scores);
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


### Decoding and encoding UTF-8 characters

Use `UTF8.decode()` to decode UTF8-encoded bytes to a Dart string:

<?code-excerpt "misc/test/library_tour/convert_test.dart (UTF8-decode)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1
];

var funnyWord = UTF8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
{% endprettify %}

To convert a stream of UTF-8 characters into a Dart string, specify
`UTF8.decoder` to the Stream `transform()` method:

<?code-excerpt "misc/test/library_tour/io_test.dart (UTF8-decoder)" replace="/UTF8.decoder/[!$&!]/g"?>
{% prettify dart %}
var lines = inputStream
    .transform([!UTF8.decoder!])
    .transform(new LineSplitter());
try {
  await for (var line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
{% endprettify %}

Use `UTF8.encode()` to encode a Dart string as a list of UTF8-encoded
bytes:

<?code-excerpt "misc/test/library_tour/convert_test.dart (UTF8-encode)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
List<int> encoded = UTF8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
{% endprettify %}


### Other functionality

The dart:convert library also has converters for ASCII and ISO-8859-1
(Latin1). For details, see the [API docs for the dart:convert library.][dart:convert]


## dart:mirrors - reflection

The dart:mirrors library provides basic reflection abilities to Dart.
Use mirrors to query the structure of your program and to dynamically
invoke functions or methods at runtime.

The dart:mirrors library works in both web apps and command-line apps.
To use it, import dart:mirrors.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (import)"?>
{% prettify dart %}
import 'dart:mirrors';
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Warning:**
Using dart:mirrors can cause dart2js to generate very large JavaScript
files.

The current workaround is to add a `@MirrorsUsed` annotation before
the import of dart:mirrors. For details, see the [MirrorsUsed][]
API documentation. This workaround is very likely to change, as the
dart:mirrors library is still under development.
</div>


### Symbols

The mirror system represents the names of Dart declarations (classes,
fields, and so on) by instances of the class [Symbol][]. Symbols work
even in code where names have changed due to minification.

When you know the name of the symbol ahead of time, use a symbol
literal. This way, repeated uses of the same symbol can use the same
canonicalized instance. If the name of the symbol is determined
dynamically at runtime, use the Symbol constructor.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (Symbol)"?>
{% prettify dart %}
// If the symbol name is known at compile time.
const className = #MyClass;

// If the symbol name is dynamically determined.
var userInput = askUserForNameOfFunction();
var functionName = new Symbol(userInput);
{% endprettify %}

During minification, a compiler might replace a symbol name with a
different (often smaller) name. To convert from a symbol back to a
string, use `MirrorSystem.getName()`. This function returns the correct
name, even if the code was minified.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (getName)"?>
{% prettify dart %}
const className = #MyClass;
assert('MyClass' == MirrorSystem.getName(className));
{% endprettify %}


### Introspection

Use mirrors to introspect the running program's structure. You can
inspect classes, libraries, instances, and more.

The examples in this section use the following Person class:

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (Person)"?>
{% prettify dart %}
class Person {
  String firstName;
  String lastName;
  int age;

  Person(this.firstName, this.lastName, this.age);

  String get fullName => '$firstName $lastName';

  void greet(String other) {
    print('Hello there, $other!');
  }
}
{% endprettify %}

To begin, you need to *reflect* on a class or object to get its
*mirror*.

#### Class mirrors

Reflect on a Type to get its ClassMirror.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (ClassMirror)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
ClassMirror mirror = reflectClass(Person);

assert('Person' == MirrorSystem.getName(mirror.simpleName));
{% endprettify %}

You can also call `runtimeType` to get a Type from an instance.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (runtimeType)"?>
{% prettify dart %}
var person = new Person('Bob', 'Smith', 33);
ClassMirror mirror = reflectClass(person.runtimeType);
assert('Person' == MirrorSystem.getName(mirror.simpleName));
{% endprettify %}

Once you have a ClassMirror, you can get a class's constructors, fields,
and more. Here is an example of listing the constructors of a class.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (showConstructors)"?>
{% prettify dart %}
void showConstructors(ClassMirror mirror) {
  var constructors = mirror.declarations.values
      .where((m) => m is MethodMirror && m.isConstructor);

  constructors.forEach((m) {
    MethodMirror mm = m as MethodMirror;
    print('The constructor ${mm.simpleName} has '
        '${mm.parameters.length} parameters.');
  });
}
{% endprettify %}

Here is an example of listing all of the fields declared by a class.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (showFields)"?>
{% prettify dart %}
void showFields(ClassMirror mirror) {
  var fields = mirror.declarations.values
      .where((m) => m is VariableMirror);

  fields.forEach((m) {
    final v = m as VariableMirror;
    var finalStatus = v.isFinal ? 'final' : 'not final';
    var privateStatus =
        v.isPrivate ? 'private' : 'not private';
    var typeAnnotation = v.type.simpleName;

    print('The field ${v.simpleName} is $privateStatus ' +
        'and $finalStatus and is annotated as ' +
        '$typeAnnotation.');
  });
}
{% endprettify %}

For a full list of methods, consult the [API docs for ClassMirror][ClassMirror].

#### Instance mirrors

Reflect on an object to get an InstanceMirror.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (InstanceMirror)"?>
{% prettify dart %}
var p = new Person('Bob', 'Smith', 42);
InstanceMirror mirror = reflect(p);
{% endprettify %}

If you have an InstanceMirror and you want to get the object that it
reflects, use `reflectee`.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (reflectee)"?>
{% prettify dart %}
var person = mirror.reflectee;
assert(identical(p, person));
{% endprettify %}


### Invocation

Once you have an InstanceMirror, you can invoke methods and call getters
and setters. For a full list of methods, consult the [API docs for InstanceMirror][InstanceMirror].

#### Invoke methods

Use InstanceMirror's `invoke()` method to invoke a method on an object.
The first parameter specifies the method to be invoked, and the second
is a list of positional arguments to the method. An optional third
parameter lets you specify named arguments.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (invoke)"?>
{% prettify dart %}
var p = new Person('Bob', 'Smith', 42);
InstanceMirror mirror = reflect(p);

mirror.invoke(#greet, ['Sundar']);
{% endprettify %}

#### Invoke getters and setters

Use InstanceMirror's `getField()` and `setField()` methods to get and
set properties of an object.

<?code-excerpt "misc/test/library_tour/mirrors_test.dart (getField-setField)"?>
{% prettify dart %}
var p = new Person('Bob', 'Smith', 42);
InstanceMirror mirror = reflect(p);

// Get the value of a property.
var fullName = mirror.getField(#fullName).reflectee;
assert(fullName == 'Bob Smith');

// Set the value of a property.
mirror.setField(#firstName, 'Mary');
assert(p.firstName == 'Mary');
assert(p.fullName == 'Mary Smith');
{% endprettify %}


### More information

The article [Reflection in Dart with
Mirrors](/articles/libraries/reflection-with-mirrors) has
more information and examples. Also see the API docs for
[dart:mirror,][dart:mirror] especially [MirrorsUsed,][MirrorsUsed]
[ClassMirror,][ClassMirror] and [InstanceMirror.][InstanceMirror]


## Summary

This page introduced you to the most commonly used functionality in
many of Dart’s built-in libraries. It didn’t cover all the built-in
libraries, however. Others that you might want to look into include
[dart:collection,][dart:collection] [dart:isolate,][dart:isolate] and
[dart:typed\_data.][dart:typed\_data] You
can get yet more libraries by using the pub tool, discussed in the next
page. The [args,](https://pub.dartlang.org/packages/args)
[logging,](https://pub.dartlang.org/packages/logging)
[polymer,](https://pub.dartlang.org/packages/polymer) and
[test](https://pub.dartlang.org/packages/test) libraries are just a
sampling of what you can install using pub.

To learn more about the Dart language, see
[A Tour of the Dart Language](/guides/language/language-tour).

[AnchorElement]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/AnchorElement-class.html
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[ClassMirror]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/ClassMirror-class.html
[Comparable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Comparable-class.html
[dart:async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart:collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart:convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:html]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html
[dart:io]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html
[dart:isolate]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-isolate/dart-isolate-library.html
[dart:math]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart:mirror]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/dart-mirrors-library.html
[dart:typed\_data]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[Dart API]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}
[DateTime]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/DateTime-class.html
[Directory]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Directory-class.html
[Document]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Document-class.html
[double]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double-class.html
[Duration]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Duration-class.html
[Element]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Element-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
[File]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File-class.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[Future.wait()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/wait.html
[HttpClient]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpClient-class.html
[HttpRequest]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/HttpRequest-class.html
[HttpServer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/HttpServer-class.html
[IndexedDB]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[IOSink]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/IOSink-class.html
[InstanceMirror]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/InstanceMirror-class.html
[int]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int-class.html
[Iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterator-class.html
[JSON]: https://www.json.org/
[List]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[Map]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Match]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Match-class.html
[MessageEvent]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/MessageEvent-class.html
[MirrorsUsed]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/MirrorsUsed-class.html
[Nodes]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Node-class.html
[NoSuchMethodError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError-class.html
[num]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num-class.html
[Object]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[Pattern]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Pattern-class.html
[Process]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Process-class.html
[Random]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random-class.html
[RegExp]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/RegExp-class.html
[Set]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[Socket]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/Socket-class.html
[Stream]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[String]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String-class.html
[StringBuffer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StringBuffer-class.html
[Symbol]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html
[toStringAsFixed()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsPrecision.html
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[web audio]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[Uri]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[WebGL]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_gl/dart-web_gl-library.html
[WebSocket]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/WebSocket-class.html
[Window]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/Window-class.html
