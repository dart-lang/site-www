---
title: Patterns
description: Summary of patterns in Dart.
---

{{site.alert.version-note}}
  Patterns require a [language version][] of at least 3.0.
{{site.alert.end}}

Patterns are a syntactic category in the Dart language, like statements and expressions.
A pattern represents the shape of a set of values that it may match against actual
values.

This page describes:
- What patterns do
- Where patterns are allowed in Dart code
- Common use cases for patterns

To learn about the different kinds of patterns, visit the [pattern types][types]
page.

## What patterns do

In general, a pattern may **match** a value, **destructure** a value, or both,
depending on the context and shape of the pattern.

First, given a value, pattern matching allows you to check whether the value has
a certain shape, or is a certain constant, or is equal to something else, or has
a certain type.

Then, destructuring provides you with a convenient declarative syntax to break
that value into its constituent parts, possibly binding variables to some or all
of those parts in the process.

### Matching

A pattern is always tested against a value to determine if the value has the form
you expect, or in other words, if the value _matches_ the pattern. 

What constitutes a match depends on [what kind of pattern][types] is being used.
For example, a constant pattern matches if the value is equal to the pattern's 
constant:

```dart
switch (number) {
  // Constant pattern matches if 1 == number.
  case 1: // ...        
}
```

Many patterns make use of subpatterns (sometimes called outer and inner patterns,
respectively). Patterns match recursively on their subpatterns.
For example, the individual fields of any [collection-type][] pattern could be 
[variable patterns][variable] or [constant patterns][constant]:

```dart
switch (obj) {
  // List pattern [a,b] matches obj first if obj is a list wth two fields,
  // then if its fields match the constant subpatterns 'a' and 'b'.
  case [a, b]: // ...   
}                    
```

Patterns can ignore parts of a matched value by using a [wildcard pattern][]
as a place holder, or a [rest element][] in the case of list patterns.

### Destructuring

When an object and pattern match, the pattern can then access the object's data 
and extract it in parts. In other words, the pattern _destructures_ the object:

```dart
var numList = [1, 2, 3];
// List pattern [a, b, c] destructures the three elements from numList...
var [a, b, c] = numList;
// ...and assigns them to new variables.
print(a + b + c);          
```

You can nest [any kind of pattern][types] inside a destructuring pattern, 
For example, this case pattern matches and destructures a two-element
list whose first element is `a` or `b`:

```dart
switch (list) {
  case ['a' || 'b', var c]: 
  // ...
}
```

## Places patterns can appear

You can use patterns in several places in the Dart language:

<a id="pattern-uses"></a>

- Local variable [declarations](#variable-declaration) and [assignments](#variable-assignment)
- [for and for-in loops][for]
- [if-case][if] and [switch-case][switch]
- Control flow in [collection literals][]

This section describes common use cases for matching and destructuring with patterns, 
combining various contexts, pattern types, and surrounding code constructs.

### Variable declaration

Anywhere Dart allows local variable declaration, like in the body of a function,
you can also use a _pattern variable declaration_. The pattern matches against
and destructures the value on the right of the declaration, binding it to
new local variables:

```dart
// Declares new variables a, b, and c.
var (a, [b, c]) = ("str", [1, 2]);
```

A pattern variable declaration must start with either `var` or `final`, followed
by a pattern. 

### Variable assignment 

A _variable assignment pattern_ on the left side of an assignment destructures the
matched object and assigns the values to _existing_ variables,
instead of binding new ones. 

One convenient use case is swapping the values of two variables without needing
to declare a third temporary one:

```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b); // Swap.
print('$a $b'); // Prints "right left".
```

### Switch statements and expressions

Every case clause contains a pattern. This applies to [switch statements][switch]
and [expressions][], as well as [if-case statements][if].

_Case patterns_ are [refutable][];
they allow control flow to either match and destructure the object being switched
on, or continue execution if the object doesn't match. Case patterns can be
[any kind of pattern][types]:

```dart
switch (obj) {
  case 1: ...
    // Matches if 1 == obj.
  case >= first && <= last: ...  
    // Matches if the value of obj is between the constant values of 'first' and 'last'.
  case (var a, var b): ...
    // Matches if obj is a record with two fields, then assigns the fields to 'a' and 'b'.
  case Rect(width: var w, height: var h): ...
    // Matches if obj is an instance of Rect, and then against the properties of Rect.
  default: ...
}
```


Values destructured by a pattern in a case become local variables,
only available in the body of that case. 

### For and for-in loops

You can use patterns in [for and for-in loops][for] to iterate-over and destructure
values in a collection.

This example uses [object destructuring][object] in a for-in loop to destructure
the [`MapEntry`][] objects that a `<Map>.entries` call returns:

```dart
Map<String, int> hist = // ...

for (var MapEntry(key: key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

The object pattern checks that `hist.entries` has the named type `MapEntry`,
and then recurses into the named field subpatterns `key` and `value`.
It calls the `key` getter and `value` getter on the `MapEntry` in each iteration,
and binds the results to local variables `key` and `count`, respectively.

Binding the result of a getter call to a variable of the same name is a common
use case, so object patterns can also infer the getter name from the
[variable subpattern][variable]. This allows you to simplify the variable pattern
from something redundant like `key: key` to just `:key`:

```dart
for (var MapEntry(:key, value: count) in hist.entries) { 
  print('$key occurred $count times');
}
```

## Uses cases for patterns

The [section above](#places-patterns-can-appear)
describes _how_ you can use patterns in Dart code constructs, 
sometimes with interesting uses cases as examples (like [swapping](#variable-assignment)
the values of two variables, or
[destructuring key-value pairs](#for-and-for-in-loops)
in a map). 

This section describes even more use cases, answering _when and why_ you might
want to use patterns, the kinds of problems they solve, and the idioms they're 
best suited for.

### Destructuring multiple returns

[Records][] allow aggregating and returning multiple values from a single function
call. Patterns add the ability to destructure a record's fields
directly into local variables, inline with the function call.

Instead of individually declaring new local variables for each record field,
like this:

```dart
main() {
  var info = userInfo(json);
  var name = info.$1;
  var age = info.$2;
}
```

You can destructure the fields of a record that a function returns into local
variables using a [variable declaration](#variable-declaration) or
[assigment pattern](#variable-assignment), and a record pattern as its subpattern:

```dart
main() {
  var (name, age) = userInfo(json);
}
```

### Destructuring class instances

[Object patterns][object] match against named object types, allowing
you to destructure their data using the getters the object's class already exposes.

To destructure an instance of a class, use the named type, followed by the properties
to destructure enclosed in parenthesis:

```dart
main() {
  final Foo myFoo = Foo(one: 'one', two: 2);
  var Foo(:one, :two) = myFoo;
  print('one $one, two $two');
}
```

### Algebraic datatypes 

Object destructuring and switch cases are conducive to writing
code in an [algebraic datatype][] style: 
when you have a family of related types and an operation that needs
specific behavior for each type.

Instead of implementing the operation as an instance method for every respective type,
you can keep the operations in a single function, switching over subtypes for
variations in behavior:

```dart
sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) =>
  switch (shape) {
    Square(length: var l) => l * l,
    Circle(radius: var r) => math.pi * r * r
  };
```

### Validating incoming JSON

[Map][] and [list][] patterns work well for destructuring key-value pairs in
JSON data:

```dart 
var json = {'user': ['Lily', 13]};
var {'user': [name, age]} = json;
```

The example above makes sense when you already know that the JSON
data has the structure you expect.
If the data comes from an external source, like over the network as is commonly
the case, you can't be sure of it's structure and
should validate it first. 

Without patterns, validation is verbose:

```dart
if (json is Map<String, dynamic> &&
    json.length == 1 && json.containsKey('user')) {
  var user = json[user];
  if (user is List<dynamic> && user.length == 2 &&
      user[0] is String && user[1] is int) {
    var name = user[2] as String;
    var age = user[1] as int;
    print('User $name is $age years old.');
  }
}
```

A single [case pattern](#switch-statements-and-expressions)
(conducive to an [if-case][if] statement)
achieves the same validation as above, but is much clearer, more declarative,
and much shorter:

```dart
if (json case {'user': [String name, int age]}) 
  print('User $name is $age years old.');
```

This case pattern simultaneously validates that:

- `json` is a map (because it must first match the outer [map pattern][map] to proceed).
  - And, since it's a map, it also confirms `json` is not null.
- `json` contains a key `user`.
- The key `user` pairs with a list of two values.
- The types of the list values are `String` and `int`.
- The new local variables to hold the values are `String` and `int`. 


[language version]: /guides/language/evolution#language-versioning
[types]: /language/pattern-types
[collection-type]: /language/collections
[wildcard pattern]: /language/pattern-types#wildcard
[rest element]: /language/pattern-types#rest-element
[null-check pattern]: /language/pattern-types#null-check
[for]: /
[if]: /
[switch]: /
[expressions]: /
[collection literals]: /language/collections#control-flow-operators
[null-assert pattern]: /language/pattern-types#null-assert
[record]: /language/pattern-types#record
[Records]: /
[refutable]: /resources/glossary#refutable-pattern
[constant]: /language/pattern-types#constant
[list]: /language/pattern-types#list
[map]: /language/pattern-types#map
[variable]: /language/pattern-types#variable
[logical]: /language/pattern-types#logical-and
[relational]: /language/pattern-types#relational
[check]: /language/pattern-types#null-check
[assert]: /language/pattern-types#null-assert
[object]: /language/pattern-types#object
[`MapEntry`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/MapEntry-class.html
[algebraic datatype]: https://en.wikipedia.org/wiki/Algebraic_data_type