---
title: Patterns
description: Summary of patterns in Dart.
---

{{site.alert.version-note}}
  Patterns require a [language version][] of at least 3.0.
{{site.alert.end}}

Patterns are a syntactic category in the Dart language, like statements and expressions.
They represent the form of a value, not an actual value.

This page describes:
- What patterns do (match and destructure)
- Where patterns are allowed in Dart code
- Common use cases for patterns

To learn about the different types of patterns, visit the [pattern type reference][types].

## Matching

A pattern is always tested against a value to determine if the value has the form
you expect, or in other words, if the value _matches_ the pattern. 

What constitutes a match depends on the [pattern type][types].
For example, matching a constant pattern means the value is equivalent to the pattern:

```dart
switch (number) {
  case 1: ...        // Constant pattern 1 matches if number == 1
}
```

Many patterns make use of subpatterns (sometimes called outer and inner patterns,
respectively). Patterns match recursively on their subpatterns.
For example, the individual fields of any [collection-type][] pattern could be 
[variable patterns][variable] or [constant patterns][constant]:

```dart
switch (obj) {       // List pattern [a,b] matches obj first if obj
  case [a, b]: ...   // is a list wth two fields, then if its  
}                    // fields match the constant subpatterns a and b  
```

Patterns can also _partially_ match, by using a [wildcard pattern][] as a place holder,
or a [rest element][] in the case of list patterns.

If you need to ensure `null` values aren't silently treated as match failures,
use the [null-check pattern][] while matching.

## Destructuring

When an object and pattern match, the pattern can then access the object's data 
and extract it in parts. In other words, the pattern _destructures_ the object:

```dart
var numList = [1, 2, 3];
var [a, b, c] = numList;   // List pattern [a, b, c] destructures the list object
print(a + b + c);          // numList into individual new parts. Prints 6.
```

You can use the [null-check pattern][] to check for `null` while destructuring. 

All patterns attempt to match the objects they're compared against, but not all
patterns destructure.
Whether a pattern destructures depends on the [type of pattern][types]
and the [context](#pattern-uses) in which it's being used.

## Pattern uses

Patterns integrate into several code constructs across the Dart language:

- Local variable [declarations](#variable-declaration) and [assignments](#variable-assignment)
- [for and for-in loops][for]
- [if-cases] and [switch-cases]
- [Collection literals][]

This section describes common use cases for matching and destructuring with patterns, 
combining various contexts, pattern types, and surrounding code constructs.

### Variable declaration

Anywhere Dart allows regular, single-name local variable declaration, you can also
use a _pattern variable declaration_. If the pattern matches the value on the right
of the declaration, it destructures the value, binding it to new local variables:

```dart
var (a, [b, c]) = ("str", [1, 2]);   // Declares new variables a, b, and c.
```

A pattern variable declaration must start with either `var` or `final`, followed
by a pattern. 

Use the [null-assert pattern][] to eliminate `null` in variable declarations.

### Variable assignment 

A _variable assignment pattern_ on the left side of an assignment destructures the
matched object and assigns the values to _existing_ variables,
instead of binding new ones. 

One convenient use case is swapping the values of two variables without needing
to declare a third temporary one:

```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b);                   // Swap
print('$a $b');                    // Prints "right left".
```

### Destrcuturing multiple returns

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
You can call the function directly into a [variable declaration](#variable-declaration)
or [assigment pattern](#variable-assignment),
with a [record subpattern][record] and fields for each value in the return:

```dart
main() {
  var (name, age) = userInfo(json);
}
```

### Switch cases

The `case` keyword is always followed by a pattern. _Case patterns_ are [refutable][];
they allow control flow to either match and destructure the object being switched
on, or continue execution if the object doesn't match. Case patterns can be any
kind of pattern:

- [**Constant patterns**][constant]: the object's value has to be equivalent to match.
  ```dart
  switch (number) {
    case 1: ...          // Matches if number == 1  
  }
  ```
- [**List**][list], [**map**][map], or [**record**][record] **patterns**: the elements are destructured if matched.
  ```dart
  switch (obj) {
    case [a, b]: ...     // Matches if obj is a list with two elements  
  }
  ```  
- [**Variable patterns**][variable]: the matched value binds to a new variable.
  ```dart
  switch ((1, 2)) {
    case (var a, var b): ...    // Matches if 1 and 2 can be assigned to a and b
  }
  ```  
- [**Logical**][logical] or [**relational**][relational] **patterns**: the object matches if the comparison to
a constant returns `true`.
  ```dart
  switch (code) {
    case >= first && <= last: ...    
    // Matches if the value of code is between the constant values of first and last
  }
  ```  
- [**Null-check**][check] or [**null-assert**][assert] **patterns**: the match is first on whether the object is not null, then on the value.
  ```dart
  switch (maybe) {
    case var s?: ... 
    // Matches if maybe is not null, and then against the inner pattern "var s"
  }
  ```  
- [**Object patterns**][object]: the match exposes getters on the object type.
  ```dart
  switch (Shape shape) {
    case Rect(width: var w, height: var h): ...
    // Matches if shape is of type Rect, and then against the properties of Rect
  }
  ```  

Values destructured by a pattern in a case become local variables,
only available in the body of that case. 

### Object destructuring

[Object patterns][object] match against named object types, allowing
you to destructure their data using the getters the object's class already exposes.

For example, you can use object destructuring in a [for-in loop][for] to iterate-over
and destructure the [`MapEntry`][] objects that a `<Map>.entries` call
returns:

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

### Algebraic datatypes 

Object destructuring and switch cases are conducive to writing
code in an [algebraic datatype][] style: 
when you have a family of related types and an operation that needs
specific behavior for each type.

Instead of implementing the operation as an instance method for every respective type,
you can keep the operations in a single function, switching over subtypes for
variations in behavior:

```dart
abstract class Shape {
  double calculateArea();
}

class Square implements Shape {
  final double length;
  Square(this.length);

  double calculateArea() => length * length;
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);

  double calculateArea() => math.pi * radius * radius;
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

A single [case pattern](#switch-cases) in a switch achieves the same validation
as above, but is much clearer, more declarative, and much shorter:

```dart
switch (json) {
  case {'user': [String name, int age]}:
    print('User $name is $age years old.');
  default: // ...
}
```

This case clause simultaneously validates that:

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
[if-cases]: /
[switch-cases]: /
[Collection literals]: /language/collections#control-flow-operators
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