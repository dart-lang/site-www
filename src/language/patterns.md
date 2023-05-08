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
- What patterns do.
- Where patterns are allowed in Dart code.
- What the common use cases for patterns are.

To learn about the different kinds of patterns, visit the [pattern types][types]
page.

## What patterns do

In general, a pattern may **match** a value, **destructure** a value, or both,
depending on the context and shape of the pattern.

First, _pattern matching_ allows you to check whether a given value:
- Has a certain shape.
- Is a certain constant.
- Is equal to something else.
- Has a certain type.

Then, _pattern destructuring_ provides you with a convenient declarative syntax to
break that value into its constituent parts. The same pattern can also let you 
bind variables to some or all of those parts in the process.

### Matching

A pattern always tests against a value to determine if the value has the form
you expect. In other words, you are checking if the value _matches_ the pattern. 

What constitutes a match depends on [what kind of pattern][types] you are using.
For example, a constant pattern matches if the value is equal to the pattern's 
constant:

```dart
switch (number) {
  // Constant pattern matches if 1 == number.
  case 1: // ...        
}
```

Many patterns make use of subpatterns, sometimes called _outer_ and _inner_
patterns, respectively. Patterns match recursively on their subpatterns.
For example, the individual fields of any [collection-type][] pattern could be 
[variable patterns][variable] or [constant patterns][constant]:

```dart
switch (obj) {
  // List pattern [a,b] matches obj first if obj is a list wth two fields,
  // then if its fields match the constant subpatterns 'a' and 'b'.
  case [a, b]: // ...   
}                    
```

To ignore parts of a matched value, you can use a [wildcard pattern][]
as a place holder. In the case of list patterns, you can use a [rest element][].

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

You can nest [any kind of pattern][types] inside a destructuring pattern. 
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

This section describes common use cases for matching and destructuring with patterns.

### Variable declaration

You can use a _pattern variable declaration_ anywhere Dart allows local variable
declaration. 
The pattern matches against the value on the right of the declaration.
Once matched, it destructures the value and binds it to new local variables:

```dart
// Declares new variables a, b, and c.
var (a, [b, c]) = ("str", [1, 2]);
```

A pattern variable declaration must start with either `var` or `final`, followed
by a pattern. 

### Variable assignment 

A _variable assignment pattern_ falls on the left side of an assignment.
First, it destructures the matched object. Then it assigns the values to
_existing_ variables, instead of binding new ones. 

Use a variable assignment pattern to swap the values of two variables without
declaring a third temporary one:

```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b); // Swap.
print('$a $b'); // Prints "right left".
```

### Switch statements and expressions

Every case clause contains a pattern. This applies to [switch statements][switch]
and [expressions][], as well as [if-case statements][if].
You can use [any kind of pattern][types] in a case.

_Case patterns_ are [refutable][].
They allow control flow to either:
- Match and destructure the object being switched on.
- Continue execution if the object doesn't match.

```dart
switch (obj) {
  case 1: ...
    // Matches if 1 == obj.
  case >= first && <= last: ...  
    // Matches if the value of obj is between the constant values of 'first' and 'last'.
  case (var a, var b): ...
    // Matches if obj is a record with two fields, then assigns the fields to 'a' and 'b'.
  case Rect(width: var w, height: var h): ...
    // Matches if obj is an instance of Rect, and then against the properties of Rect,
    // and then assigns the properties to 'w' and 'h'.
  default: ...
}
```

The values that a pattern destructures in a case become local variables.
Their scope is only within the body of that case.

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

The [previous section](#places-patterns-can-appear)
describes _how_ patterns fit into other Dart code constructs. 
You saw some interesting uses cases as examples, like [swapping](#variable-assignment)
the values of two variables, or
[destructuring key-value pairs](#for-and-for-in-loops)
in a map. This section describes even more use cases, answering:

- _When and why_ you might want to use patterns.
- What kinds of problems they solve.
- Which idioms they best suit.

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
code in an [algebraic datatype][] style.
Use this method when:
- You have a family of related types.
- You have an operation that needs specific behavior for each type.
- You want to group that behavior in one place instead of spreading it across all
the different type definitions. 

Instead of implementing the operation as an instance method for every type,
keep the operation's variations in a single function that switches over the subtypes:

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

If you know that the JSON data has the structure you expect,
the previous example is realistic.
But data typically comes from an external source, like over the network.
You need to validate it first to confirm its structure. 

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
can achieve the same validation.
Single cases work best as [if-case][if] statements.
Patterns provide a more declarative, and much less verbose
method of validating JSON:

```dart
if (json case {'user': [String name, int age]}) 
  print('User $name is $age years old.');
```

This case pattern simultaneously validates that:

- `json` is a map, because it must first match the outer [map pattern][map] to proceed.
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