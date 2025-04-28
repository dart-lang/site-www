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

Dart list literals are denoted by a comma-separated list of
elements enclosed in square brackets (`[]`). Each element
contains an expression or value. Here's a simple Dart list:

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

Lists use zero-based indexing, where 0 is the index of the first element
and `list.length - 1` is the index of the last element. 
You can get a list's length using the `.length` property
and access a list's elements using the subscript operator (`[]`):

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

A set in Dart is an unordered collection of unique elements.
Dart support for sets is provided by set literals and the
[`Set`][] type.

Here is a simple Dart set, created using a set literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

:::note
Dart infers that `halogens` has the type `Set<String>`. If you try to add the
wrong type of element to the set, the analyzer or runtime raises an error. For
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

In general, a map is an object that contains elements in the
form of key-value pairs. Each key within these pairs is
associated with a value, and both keys and values can be
any type of object. Each key can occur only once, although
the same value can be associated with multiple different
keys. Dart support for maps is provided by map literals and
the [`Map`][] type.

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

## Collection elements {: #collection-elements }

Elements represent the items in a collection. There are two
element categories: _leaf elements_ and
_control flow elements_. 

*   Leaf element: Represents an expression element or
    map entry element. A leaf element exist before and after
    run-time in a collection.
    
    *   Expression element: Contains an expression that
        produces a value.

    *   Map entry element: Contains an expression that
        produces a key-value pair.

*   Control flow element: Represents a unique type of
    element that replaces itself with zero or more
    additional leaf elements at a specific location in a
    collection at run-time. A collection only contains
    control-flow elements before run-time.

    *   Spread element: Inserts the elements from one
        collection into another.
    
    *   Null-aware spread element: Similar to the spread
        element, but won't produce an error if you attempt
        to pass in a null collection.

    *   If element: Inserts an element if a condition is
        met.

    *   For element: Inserts zero or more elements if a
        condition is met.

To learn more about collection elements, see the following
sections.

<a id="control-flow-operators" aria-hidden="true"></a>
<a id="spread-operators" aria-hidden="true"></a>
<a id="collection-operators" aria-hidden="true"></a>

### Expression elements {: #expression-element }

An expression element can contain a general expression that
produces a value. In a collection, a general expression can
include literals, variables, operators, function calls, and
constructor calls. An expression element is a
leaf element type and exists before and after run-time.

An expression element has this syntax in a collection:

```dart
<general_expression>
```

### Map entry elements {: #map-entry-element }

A map entry element contains a key-value pair for a map.
The key and the value can both contain a general expression.
A map element is a leaf element type and exists
before and after run-time.

A map entry element has this syntax in a collection:

```dart
<key_expression>: <value_expression>
```

### Spread elements {: #spread-element }

The spread element (`...`) lets you add elements in one
collection to another.
A spread element is a control flow element type that is
converted into zero or more leaf elements at run-time.

A spread element has this syntax in a collection:

```dart
...<collection_expression>
```

In the following example, the elements in a list called `a`
are added to a list called `items`.

<?code-excerpt "misc/test/language_tour/collections/spread_operator_in_collection_a.dart (code_sample)"?>
```dart
var a = [1, 2, null, 4];
var items = [0, ...a, 5]; // [0, 1, 2, null, 4, 5]
```

If you would like the spread element to ignore a null
collection that is passed into and not produce an
error, use a [null-aware spread element][]. To learn more
about the spread operator, see [Spread operator][].

[Spread operator]: /language/operators/#spread-operators
[null-aware spread element]: #null-spread-element

### Null-aware spread elements {: #null-spread-element }

The null-aware spread element (`...?`) adds elements
in a nullable collection to another collection. If the
nullable collection itself is null, it is skipped and no
element is added for it.
A null-aware spread element is a control flow element type
that is converted into zero or more leaf elements at
run-time.

A null-aware spread element has this syntax in a
collection:

```dart
...?<collection_expression>
```

In the following example, a list called `a` is ignored
because it's null, but the elements in a list called `b`
are added to a list called `items`. Notice that if a
collection itself is not null, but it contains elements that
are, those null elements are added to the result.

```dart
List<int>? a = null;
var b = [1, null, 3];
var items = [0, ...?a, ...?b, 4]; // [0, 1, null, 3, 4]
```

Because of null safety, you can't perform a
spread operation (`...`) on a value that might be null. The
following example produces a compile-time error because the 
`extraOptions` parameter is nullable and the
spread operator used on `extraOptions` is not null-aware.

<?code-excerpt "misc/test/language_tour/collections/null_spread_operator_in_collection_b.dart (code_sample)"?>
```dart tag=fails-sa
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...extraOptions, // <-- OK now.
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   [dart, run, my_script.dart]
```

If you want to spread a nullable collection, use a
null-aware spread element. The following example is valid
because the null-aware spread operator is used on `extraOptions`.

<?code-excerpt "misc/test/language_tour/collections/null_spread_operator_in_collection_a.dart (code_sample)"?>
```dart
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...?extraOptions, // <-- OK now.
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   [dart, run, my_script.dart]
```

To learn more about the null-aware spread operator, see
[Spread operator][].

[Spread operator]: /language/operators/#spread-operators

### If elements {: #if-element }

You can use an `if` element inside of a collection literal
to conditionally include elements in the collection.
An if element is a control flow element type that is
converted into zero or more leaf elements at run-time.

The `if` element has a few syntax variations:

```dart
// If the bool expression is true, include the result.
if (<bool_expression>) <result>
```

```dart
// If the expression matches the pattern, include the result.
if (<expression> case <pattern>) <result>
```

```dart
// If the operation such as '(<bool_expression>)'
// or '(<expression> case <pattern>)' resolves as true,
// include the first result, otherwise,
// include the second result.
if (<if_operation>) <result> else <result>
```

```dart
// If the first operation such as '(<bool_expression>)'
// or '(<expression> case <pattern>)' resolves as true,
// include the first result, otherwise, perform the second
// operation.
if (<if_operation>) <result> else if (<if_operation>)
```

The following examples illustrate various ways that
you can use an `if` element inside of a collection with
a boolean expression:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_e.dart (code_sample)"?>
```dart
var includeItem = true;
var items = [0, if (includeItem) 1, 2, 3]; // [0, 1, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_f.dart (code_sample)"?>
```dart
var includeItem = true;
var items = [0, if (!includeItem) 1, 2, 3]; // [0, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_g.dart (code_sample)"?>
```dart
var name = 'apple';
var items = [0, if (name == 'orange') 1 else 10, 2, 3]; // [0, 10, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_h.dart (code_sample)"?>
```dart
var name = 'apple';
var items = [
  0,
  if (name == 'kiwi') 1 else if (name == 'pear') 10,
  2,
  3,
]; // [0, 2, 3]
```

The following examples illustrate various ways that
you can use an `if` element with a `case` part inside of a
collection:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_a.dart (code_sample)"?>
```dart
dynamic data = 123;
var typeInfo = [
  if (data case int i) 'Data is an integer: $i',
  if (data case String s) 'Data is a string: $s',
  if (data case bool b) 'Data is a boolean: $b',
  if (data case double d) 'Data is a double: $d',
]; // [Data is an integer: 123, Data is a double: 123]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_d.dart (code_sample)"?>
```dart
var word = 'hello';
var items = [
  1,
  if (word case String(length: var word_length)) word_length,
  3,
]; // [1, 5, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_b.dart (code_sample)"?>
```dart
var orderDetails = ['Apples', 12, ''];
var summary = [
  'Product: ${orderDetails[0]}',
  if (orderDetails case [_, int qty, _]) 'Quantity: $qty',
  if (orderDetails case [_, _, ''])
    'Delivery: Not Started'
  else
    'Delivery: In Progress',
]; // [Product: Apples, Quantity: 12, Delivery: Not Started]
```

You can mix different `if` operations with an `else if`
part. For example:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_c.dart (code_sample)"?>
```dart
var a = 'apple';
var b = 'orange';
var c = 'mango';
var items = [
  0,
  if (a == 'apple') 1 else if (a case 'mango') 10,
  if (b case 'pear') 2 else if (b == 'mango') 20,
  if (c case 'apple') 3 else if (c case 'mango') 30,
  4,
]; // [0, 1, 30, 4]
```

To learn more about the `if` conditional, see
[`if` statement][]. To learn more about the `if-case`
conditional, see [`if-case` statement][].

[`if` statement]: /language/branches#if
[`if-case` statement]: /language/branches#if-case

### For elements {: #for-element }

You can use a `for` element inside of a collection to
insert multiple elements into that collection.
A for element is a control flow element type that is
converted into zero or more leaf elements at run-time.

A `for` element has this syntax in a collection:

```dart
for (<expression> in <collection>) <result>
```

```dart
for (<initialization_clause>; <condition_clause>; <increment_clause>) <result>
```

The following examples illustrate various ways that
you can use a `for` element inside of a collection:

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_a.dart (code_sample)"?>
```dart
var numbers = [2, 3, 4];
var items = [1, for (var n in numbers) n * n, 7]; // [1, 4, 9, 16, 7]
```

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_b.dart (code_sample)"?>
```dart
var items = [1, for (var x = 5; x > 2; x--) x, 7]; // [1, 5, 4, 3, 7]
```

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_c.dart (code_sample)"?>
```dart
var items = [1, for (var x = 2; x < 4; x++) x, 7]; // [1, 2, 3, 4, 7]
```

To learn more about the `for` loop, see
[`for` loops][].

[`for` loops]: /language/loops/#for-loops

### Nest control flow elements {: #nesting-elements }

You can nest control flow elements within each other. This
is a powerful alternative to list comprehensions in other
languages.

In the following example, only the even numbers in
`numbers` are included in `items`.

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_a.dart (code_sample)"?>
```dart
var numbers = [1, 2, 3, 4, 5, 6, 7];
var items = [
  0,
  for (var n in numbers)
    if (n.isEven) n,
  8,
]; // [0, 2, 4, 6, 8]
```

It's common and idiomatic to use a spread on a collection
literal immediately inside of an `if` or `for` element. For
example:

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_c.dart (code_sample)"?>
```dart
var items = [
  if (condition) oneThing(),
  if (condition) ...[multiple(), things()],
]; // [oneThing, [multiple_a, multiple_b], things]
```

You can nest all kinds of elements arbitrarily deep.
In the following example, `if`, `for` and spread elements
are nested within each other in a collection:

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_b.dart (code_sample)"?>
```dart
var nestItems = true;
var ys = [1, 2, 3, 4];
var items = [
  if (nestItems) ...[
    for (var x = 0; x < 3; x++)
      for (var y in ys)
        if (x < y) x + y * 10,
  ],
]; // [10, 20, 30, 40, 21, 31, 41, 32, 42]
```
