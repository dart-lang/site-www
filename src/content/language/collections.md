---
title: Collections
description: Summary of the different types of collections in Dart.
prevpage:
  url: /language/records
  title: Records
nextpage:
  url: /language/generics
  title: Generics
---

Dart has built-in support for list, set, and map [collections][].
To learn more about configuring the types collections contain,
check out [Generics][].

[generics]: /language/generics
[collections]: /libraries/dart-core#collections

## Lists

Perhaps the most common collection in nearly every programming language
is the *array*, or ordered group of objects. In Dart, arrays are
[`List`][] objects, so most people just call them *lists*.

Dart list literals are denoted by
a comma separated list of expressions or values,
enclosed in square brackets (`[]`).
Here's a simple Dart list:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (list-literal)"?>
```dart
var list = [1, 2, 3];
```

:::note
Dart infers that `list` has type `List<int>`. If you try to add non-integer
objects to this list, the analyzer or runtime raises an error. For more
information, read about [type inference][].
:::

<a id="trailing-comma"></a>
You can add a comma after the last item in a Dart collection literal.
This _trailing comma_ doesn't affect the collection,
but it can help prevent copy-paste errors.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (trailing-commas)"?>
```dart
var list = ['Car', 'Boat', 'Plane'];
```

Lists use zero-based indexing, where 0 is the index of the first value
and `list.length - 1` is the index of the last value. 
You can get a list's length using the `.length` property
and access a list's values using the subscript operator (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-indexing)"?>
```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

To create a list that's a compile-time constant,
add `const` before the list literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-list)"?>
```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // This line will cause an error.
```

For more information about lists, refer to the Lists section of the
[`dart:core` documentation](/libraries/dart-core#lists).

[`List`]: {{site.dart-api}}/dart-core/List-class.html
[type inference]: /language/type-system#type-inference

## Sets

A set in Dart is an unordered collection of unique items.
Dart support for sets is provided by set literals and the
[`Set`][] type.

Here is a simple Dart set, created using a set literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

:::note
Dart infers that `halogens` has the type `Set<String>`. If you try to add the
wrong type of value to the set, the analyzer or runtime raises an error. For
more information, read about
[type inference.](/language/type-system#type-inference)
:::

To create an empty set, use `{}` preceded by a type argument,
or assign `{}` to a variable of type `Set`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-vs-map)"?>
```dart
var names = <String>{};
// Set<String> names = {}; // This works, too.
// var names = {}; // Creates a map, not a set.
```

:::note Set or map?
The syntax for map literals is similar to that for set
literals. Because map literals came first, `{}` defaults to the `Map` type. If
you forget the type annotation on `{}` or the variable it's assigned to, then
Dart creates an object of type `Map<dynamic, dynamic>`.
:::

Add items to an existing set using the `add()` or `addAll()` methods:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-add-items)"?>
```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
```

Use `.length` to get the number of items in the set:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (set-length)"?>
```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
assert(elements.length == 5);
```

To create a set that's a compile-time constant,
add `const` before the set literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-set)"?>
```dart
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
// constantSet.add('helium'); // This line will cause an error.
```

For more information about sets, refer to the Sets section of the
[`dart:core` documentation](/libraries/dart-core#sets).

[`Set`]: {{site.dart-api}}/dart-core/Set-class.html

## Maps

In general, a map is an object that associates keys and values. Both
keys and values can be any type of object. Each *key* occurs only once,
but you can use the same *value* multiple times. Dart support for maps
is provided by map literals and the [`Map`][] type.

Here are a couple of simple Dart maps, created using map literals:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-literal)"?>
```dart
var gifts = {
  // Key:    Value
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings',
};

var nobleGases = {2: 'helium', 10: 'neon', 18: 'argon'};
```

:::note
Dart infers that `gifts` has the type `Map<String, String>` and `nobleGases`
has the type `Map<int, String>`. If you try to add the wrong type of value to
either map, the analyzer or runtime raises an error. For more information,
read about [type inference][].
:::

You can create the same objects using a Map constructor:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-constructor)"?>
```dart
var gifts = Map<String, String>();
gifts['first'] = 'partridge';
gifts['second'] = 'turtledoves';
gifts['fifth'] = 'golden rings';

var nobleGases = Map<int, String>();
nobleGases[2] = 'helium';
nobleGases[10] = 'neon';
nobleGases[18] = 'argon';
```

:::note
If you come from a language like C# or Java, you might expect to see `new Map()` 
instead of just `Map()`. In Dart, the `new` keyword is optional.
For details, see [Using constructors][].
:::

Add a new key-value pair to an existing map
using the subscript assignment operator (`[]=`):

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-add-item)"?>
```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds'; // Add a key-value pair
```

Retrieve a value from a map using the subscript operator (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-retrieve-item)"?>
```dart
var gifts = {'first': 'partridge'};
assert(gifts['first'] == 'partridge');
```

If you look for a key that isn't in a map, you get `null` in return:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-missing-key)"?>
```dart
var gifts = {'first': 'partridge'};
assert(gifts['fifth'] == null);
```

Use `.length` to get the number of key-value pairs in the map:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-length)"?>
```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

To create a map that's a compile-time constant,
add `const` before the map literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-map)"?>
```dart
final constantMap = const {2: 'helium', 10: 'neon', 18: 'argon'};

// constantMap[2] = 'Helium'; // This line will cause an error.
```

For more information about maps, refer to the Maps section of the
[`dart:core` documentation](/libraries/dart-core#maps).

[Using constructors]: /language/classes#using-constructors
[`Map`]: {{site.dart-api}}/dart-core/Map-class.html
[type inference]: /language/type-system#type-inference

## Supplementals

The following supplemental materials can be used with
Dart's collection types.

<a id="spread-operators"></a>

### Spread operations

With a spread operation, you can
add values from one collection to another collection. Null
values inside of a  collection can be passed in, but null
collections produce an error. A spread operation has this
signature in a collection:

```dart
...<collection_name>
```

In the following example, the values in `list_a` are added
as values in `list_b`.

<?code-excerpt "misc/lib/language_tour/misc/spread_operator_in_collection_a.dart (code_sample)"?>
```dart
var list_a = [1, 2, null, 4];
var list_b = [0, ...list_a, 5]; // [0, 1, 2, null, 4, 5]
```

In the following example, an error is produced because
`list_a` is null and can't be passed into `list_b`.

<?code-excerpt "misc/lib/language_tour/misc/spread_operator_in_collection_b.dart (code_sample)"?>
```dart
var list_a = null;
var list_b = [0, ...list_a, 4]; // Error
```

To learn more about the operator used in spread operations
for collections, see [Spread operator][].

[Spread operator]: /language/operators/#spread-operators

### Null-aware spread operations

With a null-aware spread operation, you can add values from
one collection to another collection. Null values inside of
a collection can be passed in, but null collections are
ignored. A null-aware spread operation has this
signature in a collection:

```dart
...?<collection_name>
```

In the following example, `list_a` is ignored because it's
null, but `list_b` is passed into `list_c`.

<?code-excerpt "misc/lib/language_tour/misc/null_aware_spread_operator_in_collection_a.dart (code_sample)"?>
```dart
var list_a = null;
var list_b = [1, 2, null];
var list_c = [0, ...?list_a, ...?list_b, 4]; // [0, 1, 2, null, 4]
```

To learn more about the operator used in null-aware spread
operations for collections, see [Spread operator][].

[Spread operator]: /language/operators/#spread-operators

<a id="collection-operators"></a>

### If statements

You can use an `if` statement inside of a collection to
conditionally include values in the collection based on a
boolean expression. An `if` statement has this signature in
a collection:

```dart
// boolean expression must be true to include result
if (<bool_expression>) <result>
```

```dart
// boolean expression must be false to include result
if (!<bool_expression>) <result>
```

In the following example, `1` is included in `item_list`
because `include_item` is evaluates as true, but `2` is not
included because `!include_item` evaluates as false.

<?code-excerpt "misc/lib/language_tour/misc/if_operator_in_collection_a.dart (code_sample)"?>
```dart
var include_item = true;
var item_list = [
  0,
  if (include_item) 1,
  if (!include_item) 2,
  3,
]; // [0, 1, 3]
```

To learn more about the `if` statement, see
[`if` statement][].

[`if` statement]: /language/branches#if

### If case statements

You can use an `if-case` statement inside of a collection to
conditionally include values in the collection if the
matching expressions evaluate as true. An `if-case`
statement has this signature in a collection:

```dart
if (<expression> case expression_literal) <result>
```

In the following example, `1` is included because
`a == 'one'` evaluates as true but `2` is not
included because `b == 'two'` evaluates as false.

<?code-excerpt "misc/lib/language_tour/misc/if_case_operator_in_collection_a.dart (code_sample)"?>
```dart
var a = 'one';
var b = '';
var item_list = [
  0,
  if (a case 'one') 1,
  if (b case 'two') 2,
  3,
  4,
]; // [0, 1, 3, 4]
```

To learn more about the `if-case` statement, see
[`if-case` statement][].

[`if-case` statement]: /language/branches#if-case

### For loops

You can use a `for` loop inside of a collection to
programmatically generate multiple values and insert them
into the collection in a concise and readable way.
An `for` loop has this signature in a collection:

```dart
for (<expression> in <list>) <result>
```

In the following example, get the square for each value in
`numbers` and include that value in `item_list`.

<?code-excerpt "misc/lib/language_tour/misc/for_loop_in_collection_a.dart (code_sample)"?>
```dart
var numbers = [2, 3, 4];
var item_list = [1, for (var n in numbers) n * n, 7]; // [1, 4, 9, 16, 7]
```

You can include `if` statements in `for` loops.
In the following example, only the even numbers in `numbers`
are included in `item_list`.

<?code-excerpt "misc/lib/language_tour/misc/for_loop_in_collection_b.dart (code_sample)"?>
```dart
var numbers = [1, 2, 3, 4, 5, 6];
var item_list = [
  1,
  for (var n in numbers)
    if (n.isEven) n,
  7,
]; // [1, 2, 4, 6, 7]
```

To learn more about the `for` loop, see
[`for` loops][].

[`for` loops]: /language/loops/#for-loops
