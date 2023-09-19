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

{{site.alert.note}}
  Dart infers that `list` has type `List<int>`. If you try to add non-integer
  objects to this list, the analyzer or runtime raises an error. For more
  information, read about [type inference][].
{{site.alert.end}}

<a id="trailing-comma"></a>
You can add a comma after the last item in a Dart collection literal.
This _trailing comma_ doesn't affect the collection,
but it can help prevent copy-paste errors.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (trailing-commas)"?>
```dart
var list = [
  'Car',
  'Boat',
  'Plane',
];
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
[Library tour](/guides/libraries/library-tour#lists).

## Sets

A set in Dart is an unordered collection of unique items.
Dart support for sets is provided by set literals and the
[`Set`][] type.

Here is a simple Dart set, created using a set literal:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

{{site.alert.note}}
  Dart infers that `halogens` has the type `Set<String>`. If you try to add the
  wrong type of value to the set, the analyzer or runtime raises an error. For
  more information, read about
  [type inference.](/language/type-system#type-inference)
{{site.alert.end}}

To create an empty set, use `{}` preceded by a type argument,
or assign `{}` to a variable of type `Set`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-vs-map)"?>
```dart
var names = <String>{};
// Set<String> names = {}; // This works, too.
// var names = {}; // Creates a map, not a set.
```

{{site.alert.info}}
  **Set or map?** The syntax for map literals is similar to that for set
  literals. Because map literals came first, `{}` defaults to the `Map` type. If
  you forget the type annotation on `{}` or the variable it's assigned to, then
  Dart creates an object of type `Map<dynamic, dynamic>`.
{{site.alert.end}}

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
[Library tour](/guides/libraries/library-tour#sets).

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
  'fifth': 'golden rings'
};

var nobleGases = {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};
```

{{site.alert.note}}
  Dart infers that `gifts` has the type `Map<String, String>` and `nobleGases`
  has the type `Map<int, String>`. If you try to add the wrong type of value to
  either map, the analyzer or runtime raises an error. For more information,
  read about [type inference][].
{{site.alert.end}}

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

{{site.alert.note}}
  If you come from a language like C# or Java, you might expect to see `new Map()` 
  instead of just `Map()`. In Dart, the `new` keyword is optional.
  For details, see [Using constructors][].
{{site.alert.end}}

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
final constantMap = const {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};

// constantMap[2] = 'Helium'; // This line will cause an error.
```

For more information about maps, refer to the Maps section of the
[Library tour](/guides/libraries/library-tour#maps).

## Operators

### Spread operators

Dart supports the **spread operator** (`...`) and the
**null-aware spread operator** (`...?`) in list, map, and set literals.
Spread operators provide a concise way to insert multiple values into a collection.

For example, you can use the spread operator (`...`) to insert
all the values of a list into another list:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-spread)"?>
```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

If the expression to the right of the spread operator might be null,
you can avoid exceptions by using a null-aware spread operator (`...?`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-null-spread)"?>
```dart
var list2 = [0, ...?list];
assert(list2.length == 1);
```

For more details and examples of using the spread operator, see the
[spread operator proposal.][spread proposal]

<a id="collection-operators"></a>
### Control-flow operators

Dart offers **collection if** and **collection for** for use in list, map,
and set literals. You can use these operators to build collections using
conditionals (`if`) and repetition (`for`).

Here's an example of using **collection if**
to create a list with three or four items in it:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-if)"?>
```dart
var nav = ['Home', 'Furniture', 'Plants', if (promoActive) 'Outlet'];
```

Dart also supports [if-case][] inside collection literals:

```dart
var nav = ['Home', 'Furniture', 'Plants', if (login case 'Manager') 'Inventory'];
```

Here's an example of using **collection for**
to manipulate the items of a list before
adding them to another list:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-for)"?>
```dart
var listOfInts = [1, 2, 3];
var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
assert(listOfStrings[1] == '#1');
```

For more details and examples of using collection `if` and `for`, see the
[control flow collections proposal.][collections proposal]

[collections]: /guides/libraries/library-tour#collections
[type inference]: /language/type-system#type-inference
[`List`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[`Map`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Using constructors]: /language/classes#using-constructors
[collections proposal]: https://github.com/dart-lang/language/blob/main/accepted/2.3/control-flow-collections/feature-specification.md
[spread proposal]: https://github.com/dart-lang/language/blob/main/accepted/2.3/spread-collections/feature-specification.md
[generics]: /language/generics
[`Set`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[if-case]: /language/branches#if-case
