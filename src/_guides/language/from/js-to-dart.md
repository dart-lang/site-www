---
title: Learning Dart as a JavaScript developer
description: Leverage your JavaScript knowledge when learning Dart.
---

This guide aims to leverage your JavaScript (JS)
programming knowledge when learning Dart.
It showcases key similarities and differences
in both languages, and introduces Dart concepts
that are not present in vanilla JavaScript.
As a JavaScript developer,
Dart should feel quite familiar,
as both languages share many concepts. 

Like JavaScript, Dart runs on an event loop,
so both languages execute code in a similar way.
For example, asynchronous concepts like `Futures`
(`Promises` in JS) and the `async/await` syntax are very similar.

Dart is strongly typed, unlike JavaScript.
If you are also familiar with TypeScript or tooling
that adds static typing (like Flow), then learning Dart
probably won't be much of an extra step for you.
However, if you've mostly worked with vanilla JavaScript,
it might take a bit more effort to adjust.
The good news is that since Dart is strongly typed,
many errors that might exist in JavaScript code are
caught even before compiling your Dart code.

As of Dart 2.0, null safety is enabled by default,
which JavaScript doesn't support. As a JavaScript developer,
it might take a while to learn how to write null safe code,
but the trade-off is better protection against
null reference exceptions that are detected even
before compiling Dart code. (Thereby avoiding those
dreaded `TypeErrors` that occur when doing operations
on a JS variable that turns out to be null.)

## Conventions and linting

JavaScript and Dart both have linting tools
to enforce standard conventions. However,
while JavaScript has `ESLint` as a standalone tool
(among other available tooling),
and many different standards and configurations,
Dart has official layout conventions and includes
a linter to make compliance effortless.
To customize the lint rules for your project,
follow the [Customizing static analysis][]
instructions on dart.dev.

{{site.alert.secondary}}
  **Pro tip:** Dart provides [dart fix][],
  which finds and fixes errors found by the analyzer.
{{site.alert.secondary}}

Dart also provides a code formatter,
which is similar to JS tools like [Prettier][].
Automatically format any Dart project by running
`dart format` on the command line. For Flutter,
`flutter format` acts as an alias for this command.
(Note that the IDE plugins for Dart and Flutter,
also provide this functionality.)

{{site.alert.secondary}}
  **Pro tip:** Dart supports optional trailing
  commas for any comma-separated values,
  such as function parameters or list items.
  This causes the formatter to place each item
  onto its own line, which helps with readability,
  especially when you have a lot of nested code
  (as can happen in Flutter layout code).
{{site.alert.end}}

For more information on using commas to make your code
read more like HTML, check out
[Using trailing commas][] on flutter.dev.

For more information about Dart conventions and linting,
check out [Effective Dart][] and [Linter rules][].


[Customizing static analysis]: /guides/language/analysis-options
[`dart fix`]: /tools/dart-fix
[Effective Dart]: /guides/language/effective-dart 
[Linter rules]: /tools/linter-rules
[Prettier]: https://prettier.io/
[Using trailing commas]: {{site.flutter}}/development/tools/formatting#using-trailing-commas


## Built-in types

While both JavaScript and Dart have types,
only Dart is a strongly typed language.
This means that all Dart types have to be
inferrable by the analyzer, explicitly defined,
or assigned as `dynamic`, which disables static type
checking for that identifier.

Dart supports nullable and non-nullable versions
of the the following built-in types:

* Numbers (`int`, `double`)
* Strings (String`)
* Booleans (bool`)
* Lists (`List`, also known as arrays)
* Sets (`Set`)
* Maps (`Map`)
* Symbols (`Symbols`)
* The value `null` (`Null`)

For more information, check out
[Built-in types][] in the [Dart Language Tour][].

In Dart, all types are reference types,
meaning that all variables refer to an object
(an instance of a class). However, the types
`int`, `double`, `String`, and `bool`
are implemented to be immutable (unchanging)
and are canonicalized,
which means they behave as if they are value types.

{{site.alert.note}}
  JavaScript has two equality operators,
  `==` and `===`. The `==` operator performs
  the equality test after doing any necessary
  type conversions. The `===` operator doesn't
  perform type conversions. Dart doesn't have
  an equivalent to `===`.
{{site.alert.end}}

For more information on these JavaScript operators,
check out [this question on Stack Overflow][].

[Built-in types]: /guides/language/language-tour#built-in-types
[Dart Language Tour]: /guides/language
[this question on Stack Overflow]: https://stackoverflow.com/questions/359494/which-equals-operator-vs-should-be-used-in-javascript-comparisons/359509#359509

For example, the equals operator `==` and the `identical()`
method are guaranteed to return true for the
same values of these types, as shown in the following code:

<!--skip-->
Dart
```dart
var a = 1;
var b = 1;

print(a == b); // Prints true
print(identical(a, b)); // Prints true
```

The next section covers basic types.
Other types are covered later in this page,
including collection types (lists, maps)
and types that aid asynchrony (futures, streams).

### Numbers

Dart has three data types for holding numbers:

`num`
: The equivalent to the generic number type in JavaScript.
`int`
: Any numeric value without a decimal point. 
`double`
: Any numeric value, including those with a decimal point.

All these types are also classes within the Dart API.
Both the `int` and `double` types share `num` as their parent class:

<img
  src="/assets/img/guides/number-classes.png"
  alt="num subclasses Object and int and double each subclass num">

As number values are technically class instances,
they have the convenience of exposing their own
utility functions. Because of this, a `double` can,
for example, be rounded up as follows:


Dart
```dart
var rounded = 2.5.round();
```


JavaScript
```js
let rounded = Math.round(2.5);
```

### Strings

Strings in Dart work similarly to strings in JavaScript.
String literals are defined using single quotation marks (`'`),
but can also be defined using double quotation marks
to enable use of single quotation marks within the string
without escaping. However, single quotes are preferred.

Dart
```dart
var a = 'This is a string.';
```

#### Escaping special characters

Escaping special characters in Dart is similar
to JavaScript (and most other languages).
To include special characters escape them
using the backslash character.

The following code shows some examples. 

Dart
```dart
final singleQuotes = 'I\'m learning Dart'; // I'm learning Dart
final doubleQuotes = "Escaping the \" character"; // Escaping the " character
final unicode = "\u{1F60E}"; // 😎,  Unicode scalar U+1F60E
```

Note that 4-digit hexadecimal values can also be used directly
(for example, `\u2665`), however, curly braces also work.
For more information on working with unicode characters,
check out [Runes and grapheme clusters][].

[Runes and grapheme clusters]: /guides/language/language-tour#characters

#### String interpolation

JavaScript supports template literals,
which are literals delimited with backtick (`\``) characters,
allowing for multi-line strings,
for string interpolation with embedded expressions,
and for special constructs called tagged templates.
Dart supports string concatenation and interpolation
with embedded expressions as part of standard string literals,
meaning that you aren't required to enclose the string in
backticks to enable that functionality.
For more information,
check out [Strings][] in the [Dart Language Tour][].

[Strings]: /guides/language/language-tour#strings

As in JavaScript template literals,
insert expressions into the string literal
using the ${<expression>} syntax.
Dart expands on this by allowing the curly braces
to be omitted when the expression is a single identifier:

Dart
```dart
var str = 'I eat \$food'; // "I eat $food".
var str = 'I eat \${food}'; // "I eat ${food}".
```

#### String concatenation and multiline declaration

In JavaScript, you can define multiline strings
using template literals.
Dart has two ways to define multiline strings:

<ol markdown="1">
<li markdown="1"> Using implicit string concatenation:
    Any neighboring string literals are automatically
    concatenated, even when they are spread over multiple lines:

Dart
```dart
final s1 = 'String '
    'concatenation'
    " even works over line breaks.";
```
</li>

<li markdown="1"> Using a multi line string literal:
When using three quotation marks (either single or double)
on either side of the string,
the literal is allowed to span multiple lines:

Dart
```dart
final s2 = '''You can create
multi-line strings like this one.''';

final s3 = """This is also a
multi-line string.""";
```
</li>
</ol>

#### Equality

As in JavaScript, use the equal-to operator (`==`)
to determine if two strings are equal.
Two strings are equal if they contain the same
sequence of code units.

Dart
```dart
final s1 = 'String '
    'concatenation'
    " works even over line breaks.";
assert(s1 ==
    'String concatenation works even over '
        'line breaks.');
````

### Booleans

Both Dart and JavaScript booleans represent
a binary value. Each language has two objects
that hold this type: the boolean literals `true` and `false`,
which are compile-time constants in both languages.

Dart
```dart
var a = true;
```

JavaScript
```js
let a = true;
```

## Variables

Variables in Dart are similar to variables in JavaScript,
with the following caveats:

* As Dart is a statically typed language,
  when declaring variables the type has to be
  inferrable, or you must explicitly define the
  type when initializing the variable.

* All variables in Dart are block scoped,
  as you would expect with `let` or `const` in JavaScript.

Declaring and initializing variables in Dart works
almost identically to JavaScript:

Dart
```dart
// Declare a variable
var name; 
// Initialize the variable
name = 'bob';
// Declare and initialize a variable at once
var name = 'bob';
```

JavaScript
```js
// Declare a variable
let name; 
// Initialize the variable
name = "bob";
// Declare and initialize a variable at once
let name = "bob";
```

Note that you can replace var in Dart with
an explicit type. However, by convention,
var is recommended when the analyzer can
implicitly infer the type. 

Dart
```dart
String name = 'bob'; // This is the same as 'var', 
                     // since Dart infers the type to be String.
```

When a variable without an explicit type
is initialized after its declaration,
its type is inferred as the catch-all `dynamic` type.
Likewise, when a type cannot be automatically inferred,
it defaults back to the `dynamic` type.

Unlike JavaScript, a Dart variable's type can't be changed
after initialization:

Dart
```dart
// Variable initialized later, `name` has type `dynamic`.
var name; 
name = 'bob';

name = 5; // Allowed, as `name` has type `dynamic`.

// Variable initialized immediately, `name` has type `String`.
var name = 'bob';

name = 5; // Forbidden, as `name` has type `String`.
```

### Final and const

The final modifier in Dart acts like the const
modifier in JavaScript: 

<ol markdown="1">
<li markdown="1"> The variable must be initialized
    immediately upon declaration. 

{{site.alert.note}}
  One exception to this is with class fields,
  which might be initialized in the class constructor.
  Learn more in the [Classes](#classes) section.
{{site.alert.end}}
</li>

<li markdown="1"> Once the variable has been initialized,
    its reference can't be changed later. 
</li>
</ol>

The `const` modifier in Dart acts the same as its
`final` modifier, except that its value must
be known at compile time. Since JavaScript is an
interpreted language requiring no compilation step,
it doesn’t have an equivalent.

Although you can't modify a `const` object in JS,
you can modify its fields. In comparison,
you can't change a Dart `const` object or its fields:
they're _immutable_ (they can't be changed).

In Dart, **constant variables must contain constant values**.
However, non-constant variables can still contain
constant values, and values themselves can also be marked `const`.

Dart
```dart
var foo = const []; // foo is not constant, but the value it points to is.
  // You can reassign foo to a different list value,
  // but its current list value cannot be altered. 

const baz = []; // Equivalent to `const []`
```

Likewise, classes can have their own `const` constructors
that produce immutable instances. For more information,
check out the [Classes](#classes) section.

## Null safety 

Unlike vanilla JavaScript,
Dart supports null safety, making any type non-nullable
by default (as of Dart 2.0). One key benefit of this is
that null reference exceptions are caught when writing code,
so they are unlikely to occur at runtime. 

### Nullable vs non-nullable types

For example, all the variables in the following code
are non-nullable:

Dart
```dart
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

To indicate that a variable might have the value `null`,
just add `?` to its type declaration:

Dart
```dart
int? aNullableInt = null;
```

The same goes for any other type declaration,
such as a function declaration:

Dart
```dart
String? returnsNullable() {
  return random.nextDouble() < 0.5
    ? 'Sometimes null!'
    : null;
}

String returnsNonNullable() {
  return 'Never null!';
}
```

### Null-aware operators 

Dart supports several operators to deal with nullability.
As in JavaScript, the null assignment operator (`??=`),
null coalescing operator (`??`),
and optional chaining operator (`?.`),
are all available in Dart and operate the same as in JavaScript. 

#### ! Operator

In cases where it's safe to assume that a
nullable variable or expression is in fact non-null,
it's possible to tell the compiler to repress any
compile time errors. This is done using the (`!`) operator,
by placing it as a suffix to the expression.
(Don't confuse this with Dart’s not (`!`) operator,
which uses the same symbol but is always prefixed
to the expression.)

Dart
```dart
int? a = 5;

int b = a; // Not allowed.
int b = a!; // Allowed.
```

At runtime, if a turns out to be `null`,
a runtime error occurs.

Like the `?.` operator,
use the `!` operator when accessing properties
or methods on an object:

Dart
```dart
myObject!.someProperty;
myObject!.someMethod();
```

If `myObject` is `null` at runtime,
a runtime error occurs.

### Functions
While Dart’s functions work much the same
as their counterparts in JavaScript,
they do have some additional features,
and some minor syntax differences when declaring them.
Similar to JavaScript,
you can declare functions pretty much anywhere,
whether at the top level,
as a class field, or in the local scope.

Dart
```dart
// On the top level
multiply(a, b) {
  return a * b;
}

// As a class field
class Multiplier {
  multiply(a, b) {
    return a * b;
  }
}

// In a local scope
main() {
  multiply(a, b) {
    return a * b;
  }

  print(multiply(3, 4));
}
```

JavaScript
```js
// On the top level
function multiply(a, b) {
  return a * b;
}

// As a class field
class Multiplier {
  multiply(a, b) {
    return a * b;
  }
}

// In a local scope
function main() {
  function multiply(a, b) {
    return a * b;
  }

  console.log(multiply(3, 4));
}
```

### Arrow syntax

Both Dart and JavaScript support arrow syntax (`=>`),
but they are different.
[PENDING: How are they different?]
In Dart, arrow syntax is only used when the function
contains a single expression or return statement.

For example, the following `isNoble` functions are equivalent:

Dart
```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Dart
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

### Parameters

In JavaScript,
all parameters are _optional_ positioned parameters.
In Dart, this is not the case.
By default, all standard parameters are _required_
positional parameters and must be provided when calling a function.

Dart
```dart
multiply(int a, int b) {
  return a * b;
}

main() {
  multiply(3, 5); // Valid. All parameters are provided.
  multiply(3); // Invalid. All parameters must be provided.
}
```

This can change in two situations:

1. The positional parameters are marked as optional.
1. The parameters are named and not marked as required.

Define optional positional parameters by enclosing them
in square brackets following the required positional
parameters, if they exist. You can't define required
parameters after an optional parameter.

Due to null safety, optional positional parameters
must have a default value or be marked as nullable.
Learn more in the following section about null safety. 

The following code has one valid and two invalid examples
of functions that define optional positional parameters:

Dart
```dart
// Valid: `b` has a default value of 5. `c` is marked as nullable.
multiply(int a, [int b = 5, int? c]) {
  ...
}
// Invalid: a required positional parameter follows an optional one.
multiply(int a, [int b = 5], int c) {
  ...
}
// Invalid: Neither positional parameter has a default value or has been flagged as nullable.
multiply(int a, [int b, int c]) {
  ...
}
```

Here are some examples of calling a function that has optional parameters:

Dart
```dart
multiply(int a, [int b = 5, int? c]) {
  ...
}

main() {
  // All are valid function calls.
  multiply(3);
  multiply(3, 5);
  multiply(3, 5, 7);
}
```

Dart supports **named parameters**.
These don't have to be provided in the order
they're defined, as with positional parameters.
You refer to them by name instead. By default,
these are optional, unless they’re flagged as required.
Named parameters are defined by surrounding them with curly braces.
You can combine named parameters with required
positional parameters&mdash;in this scenario,
the named parameters are always placed after positional.
When calling a function with named parameters,
pass values by prefixing the passed value with the
name of the parameter, separated by a colon.
For example, `f(namedParameter: 5)`.

Again, with null safety,
named parameters that are not flagged as required
either need to have a default value or be flagged as nullable.

The following code defines a function with named parameters:

Dart
```dart
// Valid: 
// - `a` has been flagged as required
// - `b` has a default value of 5 
// - `c` is marked as nullable
// - Named parameters follow the positional one
multiply(bool x, { required int a, int b = 5, int? c}) {
  ...
}
```

The following examples call a function with named parameters:

Dart
```dart
// All are valid function calls. 
// Beyond providing the required positional parameter:
multiply(false, a: 3); // Only provide required named parameters
multiply(false, a: 3, b: 9); // Override default value of `b`
multiply(false, c: 9, a: 3, b: 2); // Provide all named parameters out of order
```

### First-class functions

As in JavaScript,
functions are first-class citizens in Dart,
which means that they're treated as any other object.
For example, the following code shows how to
pass a function as a parameter to another function:

Dart
```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Pass printElement as a parameter.
list.forEach(printElement);
```

### Anonymous functions

JavaScript and Dart both support [_anonymous_ functions],
or functions without a name. As with named functions,
you can pass anonymous functions like any other value.
For example, store anonymous functions in a variable,
pass them as an argument to another function,
or return them from another function.

[_anonymous_ functions]: https://en.wikipedia.org/wiki/Anonymous_function

JavaScript has two ways to declare an anonymous function:

1. Use a standard function expression
2. Use arrow syntax

For example:

JavaScript
```js
// A regular function expression, assigned to a variable
let funcExpr = function(a, b) { return a * b; }
// The same anonymous function as an arrow function expression, with curly braces.
let arrowFuncExpr = (a, b) => { return a * b; }
// An arrow function with only one return statement as its contents does not require a block. 
let arrowFuncExpr2 = (a, b) => a * b;
```

Likewise, Dart also has two ways to declare
anonymous functions, though both are functionally
similar to the arrow expression in JavaScript.
The extra functionality that comes with regular
function expressions (for example,
JavaScript's support for a function expression acting
like a constructor, or creating a custom binding to this),
aren't supported in Dart's anonymous functions.
(For more information,
check out the [Classes](#classes) section). 

Dart
```dart
// Assigning an anonymous function to a variable.
var blockFunc = (int a, int b) {
  var c = a * b;
  return c;
}

// In the case of a single returned expression,
// you can shorten the syntax:
var singleFunc = (int a, int b) => a * b;
```

As with JavaScript, anonymous functions
can also be passed to other functions.
This is commonly used (in both languages)
when using the `map` function
for arrays and lists:

JavaScript
```js
[1, 2, 3].map(e => e + 3); // [4, 5, 6]
[1, 2, 3].map(e => { 
  e *= 2;
  return e + 3;
}); // [5, 7, 9]
```

Dart
```dart
[1, 2, 3].map((e) => e + 3).toList(); // [4, 5, 6]
[1, 2, 3].map((e) {
  e *= 2;
  return e + 3;
}).toList(); // [5, 7, 9]
```

{{site.alert.note}}
  The map function in these examples returns
  an `Iterable<T`>, rather than a `List<T>`.
  Therefore, the `toList` function converts the
  returned `Iterable` back to a `List`. 
{{site.alert.end}}

### Generator functions

Dart supports [_generator functions_]
that return an iterable collection of items
that are lazily built to improve the UI’s performance.
Convert a function to a generator function by adding
the `sync*` keyword after the function parameters,
and modify it to return an `Iterable`.
Add items to the final iterable using the
`yield` keyword, or add whole sets of items using `yield*`.

[_generator functions_]: /guides/language/language-tour#generators

The following example shows how to write a
basic generator function:

Dart
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) { 
    yield k++;
  }
}

print(naturalsTo(5)); // Returns an iterable with [0, 1, 2, 3, 4].

Iterable<int> doubleNaturalsTo(int n) sync* {
  int k = 0;
  while (k < n) { 
    yield* [k, k]; 
    k++;
  }
}

print(doubleNaturalsTo(3)); // Returns an iterable with [0, 0, 1, 1, 2, 2].
```

This is a synchronous generator function,
and is not available in JavaScript.
You can also define asynchronous generator functions,
which return streams instead of iterables.
Learn more in the upcoming [Asynchrony](#asynchrony) section.

## Statements

This section describes differences in statements between
JavaScript and Dart.

### Control flow (if/else, for, while, switch) 

Nearly all control statements work similarly
to their JavaScript counterparts,
although some have additional uses when it comes
to collections
(discussed in more detail in the [Collections](#collections) section).

{{site.alert.note}}
  One key difference with the `switch` statement
  in JavaScript and Dart: when a case has no `break`,
  `continue`, or `return` statement,
  JS allows execution to fall through and continue
  with the next statement. However,
  Dart only allows this when a case's body is empty.
{{site.alert.end}}

When using `continue` in a `switch` statement,
you can combine it with a label that is put on a case:

Dart
```dart
switch (testEnum) {
  case TestEnum.A:
    print('A');
    continue b;
  b:
  case TestEnum.B:
    print('B');
    break;
}
```

### Operators

Both Dart and JavaScript contain predefined operators.
Adding new operators is not supported in either language,
but Dart allows you to overload existing operators
with the `operator` keyword. For example:

Dart
```dart
class Box {
 Box({
   required this.length,
   required this.width,
   required this.height,
 });

 final double length;
 final double width;
 final double height;

 Box operator +(Box x) {
   return Box(
     length: length + x.length,
     width: width + x.width,
     height: height + x.height,
   );
 }
}
```

#### Arithmetic operators

The equality and relational operators of both languages
are almost identical, as shown in the following table:

|---------------------------------------------------+---------------+---------------|
| Meaning                                           | Dart operator | JS equivalent |
|---------------------------------------------------|---------------|---------------|
| Add                                               | `+`             | `+`         |
| Subtract                                          | `-`             | `-`         |
| Unary minus, also known as negation               | `-expr`         | `-expr`     |
| Multiply                                          | `*`             | `*`         |
| Divide                                            | `/`             | `/`         |
| Divide returning an integer result                | `~/`            |             |
| Get the remainder of an integer division (modulo) | `%`             | `%`         |
| `var = var + 1` (expression value is `var + 1`)   | `++var`         | `++var`     |
| `var = var + 1` (expression value is `var`)       | `var++`         | `var++`     |
| `var = var - 1` (expression value is `var - 1`)   | `--var`         | `--var`     |
| `var = var - 1` (expression value is `var`)       | `var--`         | `var--`     |
{:.table .table-striped}


For example:
Dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder

a = 0;
b = ++a; // Increment a before b gets its value.
assert(++a); // 1 == 1

a = 0;
b = a++; // Increment a AFTER b gets its value.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrement a before b gets its value.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrement a AFTER b gets its value.
assert(a != b); // -1 != 0


You’ve probably noticed that Dart also contains a ~/ operator (called a truncating division operator), that divides a double and outputs a floored integer:
Dart
assert(25 == 50.4 ~/ 2);
assert(25 == 50.6 ~/ 2);
assert(25 == 51.6 ~/ 2);





