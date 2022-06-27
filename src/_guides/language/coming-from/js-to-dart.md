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
For example, asynchronous concepts like futures
(promises in JS) and the `async/await` syntax are very similar.

Dart is strongly typed, unlike JavaScript.
If you are also familiar with TypeScript or tooling
that adds static typing (like Flow), then learning Dart
probably won't be much of an extra step for you.
However, if you've mostly worked with vanilla JavaScript,
it might take a bit more effort to adjust.
The good news is that since Dart is strongly typed,
many errors that might exist in JavaScript code are
caught even before compiling your Dart code.

As of Dart 2.12, null safety is enabled by default,
which JavaScript doesn't support. As a JavaScript developer,
it might take a while to learn how to write null safe code,
but the trade-off is better protection against
null reference exceptions that are detected even
before compiling Dart code. (Thereby avoiding those
dreaded `TypeError`s that occur when doing operations
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
follow the [Customizing static analysis][] instructions.

{{site.alert.secondary}}
  **Pro tip:** Dart provides [`dart fix`][],
  which finds and fixes errors found by the analyzer.
{{site.alert.end}}

Dart also provides a code formatter,
which is similar to JS tools like [Prettier][].
Automatically format any Dart project by running
[`dart format`](/tools/dart-format) on the command line. 
For Flutter, `flutter format` acts as an alias for this command.
(Note that the IDE plugins for Dart and Flutter
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
[Using trailing commas]: {{site.flutter-docs}}/development/tools/formatting#using-trailing-commas


## Built-in types

While both JavaScript and Dart have types,
only Dart is a strongly typed language.
This means that all Dart types have to be
inferrable by the analyzer, explicitly defined,
or assigned as `dynamic`, which disables static type
checking for that identifier.

Dart supports nullable and non-nullable versions
of the the following built-in types:

* Numbers (`num`, `int`, `double`)
* Strings (`String`)
* Booleans (`bool`)
* Lists (`List`, also known as arrays)
* Sets (`Set`)
* Maps (`Map`)
* Symbols (`Symbol`)
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
_Dart_
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

_Dart_
```dart
var rounded = 2.5.round();
```


_JavaScript_
```js
let rounded = Math.round(2.5);
```

### Strings

Strings in Dart work similarly to strings in JavaScript.
String literals are defined using single quotation marks (`'`),
but can also be defined using double quotation marks
to enable use of single quotation marks within the string
without escaping. However, single quotes are preferred.

_Dart_
```dart
var a = 'This is a string.';
```

#### Escaping special characters

Escaping special characters in Dart is similar
to JavaScript (and most other languages).
To include special characters escape them
using the backslash character.

The following code shows some examples. 

_Dart_
```dart
final singleQuotes = 'I\'m learning Dart'; // I'm learning Dart
final doubleQuotes = "Escaping the \" character"; // Escaping the " character
final unicode = '\u{1F60E}'; // 😎,  Unicode scalar U+1F60E
```

Note that 4-digit hexadecimal values can also be used directly
(for example, `\u2665`), however, curly braces also work.
For more information on working with unicode characters,
check out [Runes and grapheme clusters][].

[Runes and grapheme clusters]: /guides/language/language-tour#characters

#### String interpolation

JavaScript supports template literals,
which are literals delimited with backtick (`` ` ``) characters,
allowing for multiline strings,
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
using the `${<expression>}` syntax.
Dart expands on this by allowing the curly braces
to be omitted when the expression is a single identifier:

_Dart_
```dart
var food = 'bread';
var str = 'I eat $food'; // I eat bread
var str = 'I eat ${food}'; // I eat bread
```

#### String concatenation and multiline declaration

In JavaScript, you can define multiline strings
using template literals.
Dart has two ways to define multiline strings:

<ol markdown="1">
<li markdown="1"> Using implicit string concatenation:
    Any neighboring string literals are automatically
    concatenated, even when they are spread over multiple lines:

_Dart_
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

_Dart_
```dart
final s2 = '''You can create
multiline strings like this one.''';

final s3 = """This is also a
multiline string.""";
```
</li>
</ol>

#### Equality

As in JavaScript, use the equal-to operator (`==`)
to determine if two strings are equal.
Two strings are equal if they contain the same
sequence of code units.

_Dart_
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

_Dart_
```dart
var a = true;
```

_JavaScript_
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

_Dart_
```dart
// Declare a variable
var name; 
// Initialize the variable
name = 'bob';
// Declare and initialize a variable at once
var name = 'bob';
```

_JavaScript_
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

_Dart_
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

_Dart_
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

_Dart_
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
by default (as of Dart 2.12). One key benefit of this is
that null reference exceptions are caught when writing code,
so they are unlikely to occur at runtime. 

### Nullable vs non-nullable types

For example, all the variables in the following code
are non-nullable:

_Dart_
```dart
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo();
```

To indicate that a variable might have the value `null`,
just add `?` to its type declaration:

_Dart_
```dart
int? aNullableInt = null;
```

The same goes for any other type declaration,
such as a function declaration:

_Dart_
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
(Don't confuse this with Dart's not (`!`) operator,
which uses the same symbol but is always prefixed
to the expression.)

_Dart_
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

_Dart_
```dart
myObject!.someProperty;
myObject!.someMethod();
```

If `myObject` is `null` at runtime,
a runtime error occurs.

### Functions

While Dart's functions work much the same
as their counterparts in JavaScript,
they do have some additional features,
and some minor syntax differences when declaring them.
Similar to JavaScript,
you can declare functions pretty much anywhere,
whether at the top level,
as a class field, or in the local scope.

_Dart_
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

_JavaScript_
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
In Dart, arrow syntax is only used when the function
contains a single expression or return statement.

For example, the following `isNoble` functions are equivalent:

_Dart_
```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

_Dart_
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

### Parameters

In JavaScript,
all parameters are _optional_ positioned parameters.
In Dart, this is not the case.
By default, all standard parameters are _required_
positional parameters and must be provided when calling a function.

_Dart_
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
Learn more in the preceding section about [null safety](#null-safety). 

The following code has one valid and two invalid examples
of functions that define optional positional parameters:

_Dart_
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

_Dart_
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
these are optional, unless they're flagged as required.
Named parameters are defined by surrounding them with curly braces.
You can combine named parameters with required
positional parameters—in this scenario,
the named parameters are always placed after positional.
When calling a function with named parameters,
pass values by prefixing the passed value with the
name of the parameter, separated by a colon.
For example, `f(namedParameter: 5)`.

Again, with null safety,
named parameters that are not flagged as required
either need to have a default value or be flagged as nullable.

The following code defines a function with named parameters:

_Dart_
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

_Dart_
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

_Dart_
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

_JavaScript_
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

_Dart_
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

_JavaScript_
```js
[1, 2, 3].map(e => e + 3); // [4, 5, 6]
[1, 2, 3].map(e => { 
  e *= 2;
  return e + 3;
}); // [5, 7, 9]
```

_Dart_
```dart
[1, 2, 3].map((e) => e + 3).toList(); // [4, 5, 6]
[1, 2, 3].map((e) {
  e *= 2;
  return e + 3;
}).toList(); // [5, 7, 9]
```

{{site.alert.note}}
  The `map` function in these examples returns
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

_Dart_
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

#### Iteration

While both JavaScript and Dart have `for-in` loops,
their behavior is different.

JavaScript's `for-in` loop iterates over an object's properties,
so to iterate over an iterable object's elements,
you must instead `for-of` or `Array.forEach()`.
Dart's `for-in` loop does this natively.

The following example shows iterating
over a collection and printing out each element:

_Dart_
```dart
for (final element in list) {
  print(element)
}
```

_JavaScript_
```js
for (const element of list) {
  console.log(element);
}
```

#### Switch

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

_Dart_
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

_Dart_
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

| Meaning                                           | Dart operator   | JS equivalent |
|---------------------------------------------------|-----------------|---------------|
| Add                                               | `+`             | `+`           |
| Subtract                                          | `-`             | `-`           |
| Unary minus, also known as negation               | `-expr`         | `-expr`       |
| Multiply                                          | `*`             | `*`           |
| Divide                                            | `/`             | `/`           |
| Divide returning an integer result                | `~/`            |               |
| Get the remainder of an integer division (modulo) | `%`             | `%`           |
| `var = var + 1` (expression value is `var + 1`)   | `++var`         | `++var`       |
| `var = var + 1` (expression value is `var`)       | `var++`         | `var++`       |
| `var = var - 1` (expression value is `var - 1`)   | `--var`         | `--var`       |
| `var = var - 1` (expression value is `var`)       | `var--`         | `var--`       |
{:.table .table-striped}


For example:

_Dart_
```dart
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
```

You've probably noticed that Dart also contains
a `~/ `operator (called a _truncating division operator_),
that divides a double and outputs a floored integer:

_Dart_
```dart
assert(25 == 50.4 ~/ 2);
assert(25 == 50.6 ~/ 2);
assert(25 == 51.6 ~/ 2);
```

#### Equality and relational operators

The equality and relational operators of both languages
work in the same way:

| Meaning                       | Dart operator | JS equivalent |
|-------------------------------|---------------|---------------|
| Strict equal                  | `==`          | `===`         |
| Abstract equal                |               | `==`          |
| Strict not equal              | `!=`          | `!==`         |
| Abstract not equal            |               | `!=`          |
| Greater than                  | `>`           | `>`           |
| Less than                     | `<`           | `<`           |
| Greater than or equal to      | `>=`          | `>=`          |
| Less than or equal to         | `<=`          | `<=`          |
{:.table .table-striped}

Unlike JavaScript,
Dart doesn’t have the concept of abstract equality,
so the `==` and `!=` JavaScript operators have no equivalent.

For example:

_Dart_
```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```

#### Type test operators

The implementation of test operators is a bit
different between the two languages: 

| Meaning                                            | Dart operator | JS equivalent      |
|----------------------------------------------------|---------------|--------------------|
| Typecast (described below)                         | `var as T`    |                    |
| True if the object has the specified type          | `var is T`    | `typeof var === T` |
| True if the object doesn’t have the specified type | `var is! T`   | `typeof var !== T` |
{:.table .table-striped}

The result of `obj is T` is true if `obj`
implements the interface specified by `T`.
For example, `obj is Object?` is always true.

Since JavaScript makes use of type coercion,
it doesn't have an equivalent. 

Use the typecast operator to cast an object
to a particular type if—and only if—you
are sure that the object is of that type.

For example:

_Dart_
```dart
(person as Employee).employeeNumber = 4204583;
```

If you aren't sure that the object is of type `T`,
then use `is T` to check the type before using the object. 

In Dart, the types of local variables update within
the scope of the if statement.
This is not the case for instance variables. 

_Dart_
```dart
if (person is Employee) {
   person.employeeNumber = 4204583;
}
```

#### Logical operators

You can invert or combine boolean expressions
using logical operators. The logical operators
of both languages are identical.

|--------------------------------------------------------------------------+---------------+---------------|
| Meaning                                                                  | Dart operator | JS equivalent |
|--------------------------------------------------------------------------|---------------|---------------|
| Inverts the following expression (changes false to true, and vice versa) | `!var`        | `!var`        |
| Logical OR                                                               | `||`          | `||`          |
| Logical AND                                                              | `&&`          | `&&`          |
{:.table .table-striped}

Dart does not have the concept of "truthy" or "falsy"
values—only actual booleans. Because of this,
Logical OR and Logical AND expressions always resolve
to a boolean, not one of the two values like these
operators do in JavaScript.

For example:

_Dart/JS_
```dart
if (!done && (col == 0 || col == 3)) {
  // ...Do something...
}
```

#### Bitwise and shift operators

You can manipulate the individual bits of numbers
by using bitwise and shift operators with integers.
The operators of both languages are almost identical,
as shown in the following table:

|-------------------------------------------------------+---------------+---------------|
| Meaning                                               | Dart operator | JS equivalent |
|-------------------------------------------------------|---------------|---------------|
| Bitwise AND                                           | `&`           | `&`           |
| Bitwise OR                                            | `|`           | `|`           |
| Bitwise XOR                                           | `^`           | `^`           |
| Unary bitwise complement (0s become 1s; 1s become 0s) | `~expr`       | `~expr`       |
| Shift left                                            | `<<`          | `<<`          |
| Shift right                                           | `>>`          | `>>`          |
| Unsigned shift right                                  | `>>>`         | `>>>`         |
{:.table .table-striped}

For example: 

_Dart_
```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR
assert((value << 4) == 0x220); // Shift left
assert((value >> 4) == 0x02); // Shift right
assert((-value >> 4) == -0x03); // Shift right
assert((value >>> 4) == 0x02); // Unsigned shift right
assert((-value >>> 4) > 0); // Unsigned shift right
```

#### Ternary operator

Both Dart and JavaScript contain a (`?:`)
ternary operator for evaluating expressions
that might otherwise require [if-else][] statements:

_Dart_
```dart
final visibility = isPublic ? 'public' : 'private';
```

_JavaScript_
```js
let visibility = isPublic ? "public" : "private";
```

[if-else]: /guides/language/language-tour#if-and-else

### Assignment operators

As mentioned previously,
you can assign values using the (`=`) operator: 

_Dart_
```dart
// Assign value to a
a = value;
```

This operator also has a null-aware variant.
For more information,
check out the [null-assignment](#null-aware-operators) operator section.

Here are other assignment operators that directly
assign the result of an operation on a variable
back to that same variable:

| `=`  | `*=`  | `%=`  | `>>>=` | `^=` |
| `+=` | `/=`  | `<<=` | `&=`   | `|=` |
| `-=` | `~/=` | `>>=` |        |      |
{:.table} 

_Dart_
```dart
var a = 5;
a *= 2; // Multiply `a` by 2 and assign the value back to a.
print(a); // `a` is now 10.
```

### Cascades (`..` operator) 

Unlike JavaScript,
Dart supports cascading with the cascades operator.
This allows you to chain multiple method calls
or property assignments on a single object.

The following example shows setting the value
of multiple properties, then calling multiple methods
on a newly constructed object, all within a single chain
using the cascade operator:

_Dart_
```dart
var animal = Animal()
  ..name = "Bob"
  ..age = 5
  ..feed()
  ..walk();

print(animal.name); // "Bob"
print(animal.age); // 5
```

## Collections

This section covers some collection types
in Dart and how they compare to their equivalents
in JavaScript.

### Lists

List literals are defined the same way in Dart as
arrays are defined in JavaScript,
using square brackets and separated by commas: 

_Dart_
```dart
// Initialize list and specify full type
final List<String> list1 = <String>['one', 'two', 'three'];

// Initialize list using shorthand type
final list2 = <String>['one', 'two', 'three'];

// Dart can also infer the type
final list3 = ['one', 'two', 'three'];
```

The following code samples give an overview of the
basic actions that you can perform on a Dart `List`.
The first example shows how to retrieve a value
from a `List` using the index operator:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
final fruit = fruits[1];
```

Add a value to the end of the `List` using the `add` method.
Add another `List` using the `addAll` method:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
```

Insert a value at a specific position using the
`insert` method. Insert another `List` at a
specific position using the `insertAll` method:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits.insert(0, 'peach');
fruits.insertAll(0, ['kiwi', 'mango']);
```

Update a value in the `List` combining the
index and assignment operators:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits[2] = 'peach';
```

Remove items from a `List` using one of the following methods:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
// Remove the value 'pear' from the list.
fruits.remove('pear');
// Removes the last element from the list.
fruits.removeLast();
// Removes the element at position 1 from the list.
fruits.removeAt(1);
// Removes the elements with positions greater than
// or equal to start (1) and less than end (3) from the list.
fruits.removeRange(1, 3); 
// Removes all elements from the list that match the given predicate.
fruits.removeWhere((fruit) => fruit.contains('p')); 
```

Use `length` to obtain the number of values in the `List`:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
assert(fruits.length == 3);
```

Use `isEmpty` to check if the `List` is empty:

_Dart_
```dart
var fruits = [];
assert(fruits.isEmpty);
```

Use `isNotEmpty` to check if the `List` is not empty:

_Dart_
```dart
final fruits = <String>['apple', 'orange', 'pear'];
assert(fruits.isNotEmpty);
```

#### Filled

One handy feature of Dart's `List` class is the
`filled` constructor; use `filled` to quickly
create a list of size `n` with the specified default value.
The following example create a list of 3 items:

_Dart_
```dart
// Creates: [ 'a', 'a', 'a' ]
final list1 = List.filled(3, 'a');
```

#### Generate

The `List` class also provides a `generate`
constructor to quickly create a list of
size `n` with a default value builder
that creates elements.
The value builder takes the index as a parameter.

_Dart_
```dart
// Creates: [ 'a0', 'a1', 'a2' ]
final list1 = List.generate(3, (index) => 'a$index');
```

### Sets

Unlike JavaScript,
Dart supports defining `Set`s with literals.
Sets are defined in the same way as lists,
but using curly braces instead of square brackets.
Sets are unordered collections that only contain
unique items. The uniqueness of these items are
enforced using hash codes, meaning that objects
need hash values to be stored in a `Set`.

{{site.alert.note}}
  In Dart, the hash value defaults to the
  instance of an object but you can override
  it to use a set of properties. For more information,
  check out the [`hashCode`][] property page.
{{site.alert.end}}

[`hashCode`]: {{site.dart-api}}/dart-core/Object/hashCode.html

The following code snippet shows how to initialize a `Set`: 

_Dart_
```dart
final abc = {'a', 'b', 'c'};
```

The syntax for creating an empty set might seem
confusing at first, because specifying empty
curly braces (`{}`) results in creating an empty `Map`.
To create an empty `Set`, precede the `{}` declaration
with a type argument or assign `{}` to a variable of type `Set`:

_Dart_
```dart
final names = <String>{};
// Set<String> names = {}; // This works, too.
// final names = {}; // Creates an empty map, not a set.
```

The following examples provide an overview of the
basic actions that you can perform on a Dart `Set`.

Add a value to the `Set` using the `add` method. 
Use the `addAll` method to add multiple values:

_Dart_
```dart
final fruits = {'apple', 'orange', 'pear'};
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
```

Use one of the following methods in `Set`
to remove content from the set:

_Dart_
```dart
final fruits = {'apple', 'orange', 'pear'};
// Remove the value 'pear' from the set.
fruits.remove('pear');
// Remove all elements in the supplied list from the set.
fruits.removeAll(['orange', 'apple']);
// Removes all elements from the list that match the given predicate.
fruits.removeWhere((fruit) => fruit.contains('p'));
```

Use `length` to get the number of values in the `Set`:

_Dart_
```dart
final fruits = {'apple', 'orange', 'pear'};
assert(fruits.length == 3);
```

Use `isEmpty` to check if the `Set` is empty:

_Dart_
```dart
var fruits = <String>{};
assert(fruits.isEmpty);
```

Use `isNotEmpty` to check if the `Set` is not empty:

_Dart_
```dart
final fruits = {'apple', 'orange', 'pear'};
assert(fruits.isNotEmpty);
```

### Maps

The `Map` type in Dart is similar to the `Map` type
in JavaScript. Both types associate keys with values.
A key can be any object type, so long as all keys have
the same type; the same is true for values.
Each key occurs once at most, but you can use the
same value multiple times. 

In Dart, the dictionary is based on a hash table,
which means that keys need to be hashable. In Dart,
every object contains a unique hash.

{{site.alert.note}}
  In Dart, the hash value defaults to an instance
  of an object but you can override it to resemble
  a data class. For more information,
  check out the [`hashCode`][] property page.
{{site.alert.end}}

Here are a couple of simple `Map` examples,
created using literals:

_Dart_
```dart
final gifts = {
 'first': 'partridge',
 'second': 'turtle doves',
 'fifth': 'golden rings'
};

final nobleGases = {
 2: 'helium',
 10: 'neon',
 18: 'argon',
};
```

The following code samples provide an overview of the
basic actions that you can perform on a Dart `Map`.
The first example shows how to retrieve a value from
a `Map` using the index operator:

_Dart_
```dart
final gifts = {'first': 'partridge'};
final gift = gifts['first'];
```

{{site.alert.note}}
  The index operator (`[]`) returns a **nullable** value.
{{site.alert.end}}

Use the `containsKey` method to check if a key
is already present in the `Map`:

_Dart_
```dart
final gifts = {'first': 'partridge'};
assert(gifts.containsKey('fifth'));
```

Use the index assignment operator (`[]=`)
to add or update an entry in the `Map`.
If the `Map` doesn't yet contain the key,
the entry is added; if the key is already present,
its value is updated.

_Dart_
```dart
final gifts = {'first': 'partridge'};
gifts['second'] = 'turtle'; // Gets added
gifts['second'] = 'turtle doves'; // Gets updated
```

Use the `addAll` method to add another `Map`;
use the `addEntries` method to add other entries to the `Map`:

_Dart_
```dart
final gifts = {'first': 'partridge'};
gifts['second'] = 'turtle doves';
gifts.addAll({
 'second': 'turtle doves',
 'fifth': 'golden rings',
});
gifts.addEntries([
 MapEntry('second', 'turtle doves'),
 MapEntry('fifth', 'golden rings'),
]);
```

Use the `remove` method to remove an entry from the `Map`;
remove all entries that satisfy a given test using the
`removeWhere` method:

_Dart_
```dart
final gifts = {'first': 'partridge'};
gifts.remove('first');
gifts.removeWhere((key, value) => value == 'partridge');
```

Use `length` to obtain the number of key-value
pairs in the `Map`:

_Dart_
```dart
final gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

Use `isEmpty` to check if the `Map` is empty:

_Dart_
```dart
final gifts = {};
assert(gifts.isEmpty);
```

Use `isNotEmpty` to check if the `Map` is not empty:

_Dart_
```dart
final gifts = {'first': 'partridge'};
assert(gifts.isNotEmpty);
```

### Unmodifiable

Vanilla JavaScript doesn't support immutability.
Dart, however,  offers multiple ways to make
collections like arrays, sets, or dictionaries immutable:

* If the list is a compile-time constant and shouldn't
  be modified, use the `const` keyword:<br>
  `const fruits = <String>{'apple', 'orange', 'pear'};`
* Assign the `Set` to a `final` field, meaning that
  the `Set` itself doesn’t have to be a compile-time constant.
  This ensures that the field can’t be overridden with
  another `Set`, but it still allows the size or the contents
  of the `Set` to be modified:<br>
  `final fruits = <String>{'apple', 'orange', 'pear'};`
* Create a final version of your collection type
  using the `unmodifiable` constructor
  (as shown in the following example).
  This creates a collection that cannot change its size or content: 

_Dart_
```dart
final _set = Set<String>.unmodifiable(['a', 'b', 'c']);
final _list = List<String>.unmodifiable(['a', 'b', 'c']);
final _map = Map<String, String>.unmodifiable({'foo': 'bar'});
```

### Spread operator

As in JavaScript, Dart supports embedding a list
into another list using the spread operator (`...`)
and the null-aware spread operator (`...?`).

_Dart_
```dart
var list1 = [1, 2, 3];
var list2 = [0, ...list1];　// [0, 1, 2, 3]
// When the list being inserted could be null:
list1 = null;
var list2 = [0, ...?list1]; // [0]
```

This also works for sets and maps:

_Dart_
```dart
// Spread operator with maps
var map1 = {'foo': 'bar', 'key': 'value'};
var map2 = {'foo': 'baz', ...map1}; // {foo: bar, key: value}
// Spread operator with sets
var set1 = {'foo', 'bar'};
var set2 = {'foo', 'baz', ...set1}; // {foo, baz, bar}
```

### Collection if/for

In Dart, the `for` and `if` keywords have additional
functionality when it comes to collections. 

A collection `if` statement includes items from a
list literal only when the specified condition is met:

_Dart_
```dart
var nav = [
  'Home',
  'Furniture',
  'Plants',
  if (promoActive) 'Outlet',
];
```

It works similarly for maps and sets.

A collection `for` statement allows
multiple items to be mapped into another list:

_Dart_
```dart
var listOfInts = [1, 2, 3];
var listOfStrings = [
  '#0',
  for (var i in listOfInts) '#$i',
]; // [#0, #1, #2, #3]
```

This also works in the same way for maps and sets.

## Asynchrony

Like JavaScript, the Dart Virtual Machine (VM)
runs a single event loop that processes all your Dart code.
This means that similar rules for asynchrony apply here.
All of your code runs synchronously,
but you can handle it in a different order,
depending on how you use the asynchronous tools at your disposal.
Here are some of these constructs and how they relate
to their JavaScript counterparts.

### Futures

`Future` is Dart's version of a `Promise`:
an asynchronous operation that resolves at a later point. 

Functions in Dart (or in packages that you use) might
return a `Future`, rather than the value they represent
directly, as the value might not be available until later. 

The following example shows that handling a future works
in the same way in Dart as a promise works in JavaScript:

_Dart_
```dart
Future<String> httpResponseBody = func();

httpResponseBody.then((String value) {
  print('Future resolved to a value: $value');
});
```

_JavaScript_
```js
const httpResponseBody = func();

httpResponseBody.then(value => {
  console.log(`Promise resolved to a value: ${value}`);
});
```

Similarly, futures can fail like promises.
Catching errors works the same as well:

_Dart_
```dart
httpResponseBody
  .then(...)
  .catchError((err) {
    print('Future encountered an error before resolving.');
  });
```

_JavaScript_
```js
httpResponseBody
  .then(...)
  .catch(err => {
    console.log("Promise encountered an error before resolving.");
  });
```

You can also create futures manually.
The easiest way to create a `Future` is by
defining and calling an `async` function,
which is discussed below. However,
when you have a value that needs to be a `Future`,
you can convert it as follows: 

_Dart_
```dart
String str = 'String Value';
Future<String> strFuture = Future<String>.value(str);
```

#### Async/await

If you're familiar with promises in JavaScript,
you’re likely also familiar with the `async`/`await` syntax.
This syntax is identical in Dart: functions are marked `async`,
and `async` functions always return a `Future`.
If the function returns a `String` and is marked `async`,
it returns a `Future<String>` instead.
If it returns nothing, but it is `async`,
it returns `Future<void>`.

The following example shows how to write an `async` function:

_Dart_
```dart
// Returns a future of a string, as the method is async
Future<String> fetchString() async {
  // Typically some other async operations would be done here.
  return 'String Value';
}
```

_JavaScript_
```js
// Returns a Promise of a string, as the method is async
async fetchString() {
  // Typically some other async operations would be done here.
  return "String Value";
}
```

Call this `async` function as follows:

_Dart_
```dart
Future<String> stringFuture = fetchString();
stringFuture.then((String str) {
  print(str); // 'String Value'
});
```

Obtain a future’s value using the `await` keyword.
As in JavaScript, this removes the need to call `then`
on the `Future` to obtain its value,
and it allows you to write asynchronous code in a
more synchronous-like way.
As in JavaScript, awaiting futures is only possible
within an `async` context (such as another `async` function).

The following example shows how to await a future for its value:

_Dart_
```dart
// We can only await futures within an async context.
asyncFunction() async {
  var str = await fetchString();
  print(str); // 'String Value'
}
```

For more information about `Future`s and the
`async`/`await` syntax, check out the
[Asynchronous programming][] codelab.

[Asynchronous programming]: /codelabs/async-await

### Streams

Another tool in Dart’s async toolbox is `Stream`s.
While JavaScript has its own concept of streams,
Dart's are more akin to `Observable`s,
as found in the commonly used `rxjs` library.
If you happen to be familiar with this library,
Dart's streams should feel familiar. 

For those not familiar with these concepts:
`Stream`s basically act like `Future`s,
but with multiple values spread out over time,
like an event bus. Your code can listen to a stream,
and it can either complete or reach a fail state.

#### Listening

To listen to a stream, call its `listen` method
and provide a callback method. This method is
called whenever the stream emits a value:

_Dart_
```dart
Stream<int> stream = ...
stream.listen((int value) {
  print('A value has been emitted: $value');
});
```

The `listen` method also has some optional callbacks
for handling errors or for when the stream completes:

_Dart_
```dart
stream.listen(
  (int value) { ... },
  onError: (err) {
    print('Stream encountered an error! $err');
  },
  onDone: () {
    print('Stream completed!');
  },
);
```

The `listen` method returns an instance of a
`StreamSubscription`, which you can use to stop
listening to the stream:

_Dart_
```dart
StreamSubscription subscription = stream.listen(...);
subscription.cancel();
```

This is not the only way to listen to a stream.
Similar to the `async`/`await` syntax for `Future`s,
you can combine a stream with a `for-in` loop in an
`async` context. The `for` loop invokes the
callback method for each item emitted,
and it ends when the stream completes or errors out:

_Dart_
```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}
```

When an error occurs when listening to a stream
in this way, the error is rethrown at the line
containing the `await` keyword,
which you can handle with a `try-catch` statement:

_Dart_
```dart
try {
  await for (final value in stream) { ... }
} catch (err) {
  print('Stream encountered an error! $err');
}
```

#### Creating streams

As with `Future`s,
you have several different ways to create a stream.
The `Stream` class has utility constructors for
creating streams from `Future`s or `Iterable`s,
or for creating streams that emit values at a timed interval.
For more information, check out the [`Stream`][] API page.

[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

##### StreamController

Another common way to create streams is
by using a [`StreamController`][],
a utility class that builds streams.
A `StreamController` contains a `stream` property
that exposes the stream it controls,
and multiple methods for controlling the stream,
such as emitting new items using the `add` method,
or completing the stream using the `close` method.
The following example shows basic usage of a stream controller:

_Dart_
```dart
var listeners = 0;
StreamController<int>? controller;
controller = StreamController<int>(
  onListen: () {
    // Emit a new value every time the stream gets a new listener.
    controller!.add(listeners++);
    // Close the stream after the fifth listener.
    if (listeners > 5) controller.close();
  }
);
// Get the stream for the stream controller
var stream = controller.stream;
// Listen to the stream
stream.listen((int value) {
  print('$value');
});
```

[`StreamController`]: {{site.dart-api}}/dart-async/StreamController-class.html

##### Async generators

Another way to create streams is by using async generator
functions—these have the same syntax as a
synchronous generator function, but use the `async*`
keyword instead of `sync*`,
and always return a `Stream` instead of an `Iterable`.

In an async generator function, the `yield` keyword
emits the given value to the stream. The `yield*` keyword,
however, works with streams instead of other iterables.
This allows events from other streams to be emitted to this stream.
In the following example,
the function continues once the newly yielded stream has completed.

_Dart_
```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  var k = 0;
  while (k < n) yield k++;
}

Stream<int> stream = asynchronousNaturalsTo(5); 

// Prints each of 0 1 2 3 4 in succession.
stream.listen((int value) => print(value)); 
```

Learn more about futures, streams,
and other asynchronous functionality in the
[asynchronous programming][] docs.

[asynchronous programming]: /tutorials/language/streams

## Classes 

On the surface, classes in Dart are similar to classes
in JavaScript, although JavaScript classes are technically
more of a wrapper around prototypes. In Dart,
classes are a standard feature of the language.
This section covers defining and using classes in Dart
and how they differ from JavaScript. 

### “this” context

The `this` keyword in Dart is more straightforward
than in JavaScript. In Dart, you can't bind functions
to `this`, and `this` never depends on the execution
context (as it does in JavaScript). In Dart,
`this` is only used within classes,
and always refers to the current instance.

### Constructors

This section discusses how constructors differ in
Dart from JavaScript.

#### Standard constructor

A standard class constructor looks very similar to
a JavaScript constructor. In Dart,
the `constructor` keyword is replaced by the full class name,
and all parameters must be explicitly typed. In Dart,
the `new` keyword was once required for creating class instances,
but is now optional and its use is no longer recommended. 

_Dart_
```dart
class Point {
  double x = 0;
  double y = 0;

  Point(double x, double y) {
    // There's a better way to do this in Dart, stay tuned.
    this.x = x;
    this.y = y;
  }
}

// Create a new instance of the Point class
Point p = Point(3, 5);
```

#### Constructor parameters

Writing code to assign class fields in the constructor
can feel like creating boilerplate code,
so Dart has some syntactic sugar, called
[initializing parameters][] to make this easier:

_Dart_
```dart
class Point {
  double x = 0;
  double y = 0;

  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  Point(this.x, this.y);
}

// Create a new instance of the Point class
Point p = Point(3, 5);
```

[initializing parameters]: /guides/language/language-tour#constructors

Similar to functions, constructors have the
option to take positioned or named parameters:

_Dart_
```dart
class Point {
  ...
  // With an optional positioned parameter
  Point(this.x, [this.y = 5]);
  // With named parameters
  Point({ required this.y, this.x = 5 });
  // With both positional and named parameters
  Point(int x, int y, { boolean multiply }) {
    ...
  }
  ...
}
```

#### Initializer lists

You can also use initializer lists,
which run after any fields that aren't set
using initializing parameters,
but run before the constructor body:

_Dart_
```dart
class Point {
  ...
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']! {
    print('In Point.fromJson(): ($x, $y)');
  }
  ...
}
```

#### Named constructors

Unlike JavaScript, Dart allows classes to have
multiple constructors, by allowing you to name them.
You can optionally have one single unnamed constructor,
any additional constructors must be named:

_Dart_
```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  double x = 0;
  double y = 0;

  Point(this.x, this.y);

  // Named constructor
  Point.origin()
      : x = xOrigin,
        y = yOrigin;
}
```

#### Const constructors

When your class instances are always immutable,
you can enforce this by using a `const` constructor.
Defining your constructor as `const` requires all
non-static fields in your class to be flagged as `final`: 

_Dart_
```dart
class ImmutablePoint {
  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

#### Constructor redirection

You can call constructors from other constructors,
for example to prevent code duplication or
to add additional defaults for parameters:

_Dart_
```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```

#### Factory constructors

You can use a factory constructor when you
don't need to create a new class instance.
One example would be when returning a cached instance: 

_Dart_
```dart
class Logger {
  static final Map<String, Logger> _cache =
      <String, Logger>{};
  
  final String name;
  
  // Factory constructor that returns a cached copy,
  // or creates a new one if it is not yet available.
  factory Logger(String name) {
    return _cache.putIfAbsent(
        name, () => Logger._internal(name));
  }

  // Private constructor for internal use only
  Logger._internal(this.name);
}
```

### Methods

In both Dart and JavaScript, methods are
functions that provide behavior for an object.

_Dart_
```dart
void doSomething() { // This is a function
 // Implementation..
}

class Example {
 void doSomething() { // This is a method
   // Implementation..
 }
}
```

_JavaScript_
```js
doSomething() { // This is a function
  // Implementation..
}

class Example {
  doSomething() { // This is a method
    // Implementation..
  }
}
```

### Extending classes

Dart allows classes to extend another class,
in the same way that JavaScript does. 

_Dart_
```dart
class Animal {
  int eyes;
  
  Animal(this.eyes);
  
  makeNoise() {
    print('???');
  }
}
class Cat extends Animal {
  
  Cat(): super(2);

  @override
  makeNoise() {
    print('Meow');
  }
}
Animal animal = Cat();
print(animal.eyes); // 2
animal.makeNoise(); // Meow
```

When overriding a method from the parent class,
use the `@override` annotation.
While this annotation is optional,
it shows that the override is intentional.
The Dart analyzer shows a warning if the method
is not actually overriding a superclass method. 

The parent method that is being overridden can
still be called using the `super` keyword:

_Dart_
```dart
class Cat extends Animal {
  ...
  @override
  makeNoise() {
    print('Meow');
    super.makeNoise();
  }
}
Animal animal = Cat();
animal.makeNoise(); // Meow
                    // ???

```

### Classes as interfaces

Like JavaScript, Dart doesn’t have a
separate definition for interfaces. However,
unlike JavaScript, all class definitions double
as an interface; you can implement a class as
an interface using the `implements` keyword.

When a class is implemented as an interface,
its public API must be implemented by the new class.
Unlike `extends`, its method and field implementations
aren't shared with the new class.
While a class can only extend a single class,
you can implement multiple interfaces at a time,
even when the implementing class already extends another.

_Dart_
```dart
class Consumer {
  consume() {
    print('Eating food...');
  }
}
class Cat implements Consumer {
  consume() {
    print('Eating mice...');
  }
}
Consumer consumer = Cat();
consumer.consume(); // Eating mice
```

When implementing an interface,
the `super` method can't be called
as the method bodies are not inherited:

_Dart_
```dart
class Cat implements Consumer {
  @override
  consume() {
    print('Eating mice...');
    super.consume(); // Invalid, because there’s no superclass.
  }
}
```

### Abstract classes and methods

To ensure that a class can only be extended
or have its interface implemented,
but to disallow the construction of any instances,
mark it as `abstract`.

Classes marked as `abstract` can have abstract methods,
which do not require a body and are instead required
to be implemented when the class is either extended
or its interface is implemented:

_Dart_
```dart
abstract class Consumer {
  consume();
}
// Extending the full class
class Dog extends Consumer {
  consume() {
    print('Eating cookies...');
  }
}
// Just implementing the interface
class Cat implements Consumer {
  consume() {
    print('Eating mice...');
  }
}
Consumer consumer;
consumer = Dog();
consumer.consume(); // Eating cookies...
consumer = Cat();
consumer.consume(); // Eating mice...
```

### Mixins 

Mixins are used to share functionality between classes.
You can use the mixin's fields and methods in the class,
using their functionality as if it were part of the class.
A class can use multiple mixins, which is useful
when multiple classes share the same functionality,
without needing to inherit from each other or share a common ancestor.

A mixin is declared like a regular class,
as long as it doesn't extend any class other
than `Object` and has no constructors.
Use the `with` keyword to add one or more
comma-separated mixins to a class.
Although JavaScript doesn’t have an equivalent
for this keyword, the effect is similar to using
`Object.assign` to merge additional objects into
an existing object, after instantiating.

The following example shows how similar behavior
is replicated in JavaScript and how it's achieved in Dart:

_Dart_
```dart
abstract class Animal {}

// Defining the mixins
class Flyer {
  fly() => print('Flaps wings');
}
class Walker {
  walk() => print('Walks legs');
}
  
class Bat extends Animal with Flyer {}
class Goose extends Animal with Flyer, Walker {}
class Dog extends Animal with Walker {}

// Correct calls
Bat().fly();
Goose().fly();
Goose().walk(); 
Dog().walk();
// Incorrect calls
Bat().walk(); // Not using the Walker mixin
Dog().fly(); // Not using the Flyer mixin
```

_JavaScript_
```js
class Animal {}

// Defining the mixins
class Flyer {
  fly = () => console.log('Flaps wings');
}
class Walker {
  walk = () => console.log('Walks legs');
}
  
class Bat extends Animal {}
class Goose extends Animal {}
class Dog extends Animal {}

// Composing the class instances with their correct functionality.
const bat = Object.assign(new Bat(), new Flyer());
const goose = Object.assign(new Goose(), new Flyer(), new Walker());
const dog = Object.assign(new Dog(), new Walker());

// Correct calls
bat.fly();
goose.fly();
goose.walk(); 
dog.walk();
// Incorrect calls
bat.walk(); // `bat` does not have the `walk` method
dog.fly(); // `dog` does not have the `fly` method
```

Alternatively, you can replace the `class` keyword
with `mixin` to prevent the mixin from being used
as a regular class:

_Dart_
```dart
mixin Walker {
  walk() => print('Walks legs');
}
// Not possible, as Walker is no longer a class.
class Bat extends Walker {}
```

Since you can use multiple mixins,
they can have overlapping methods or fields
with each other when used on the same class.
They can even overlap with the class that uses them,
or that class's superclass.
The order in which they are added to a class matters. 

To give an example:

```dart
class Bird extends Animal with Consumer, Flyer {
```

When a method is called on an instance of `Bird`,
Dart starts with its own class, `Bird`,
which takes precedence over other implementations.
If `Bird` has no implementation,
then `Flyer` is checked, followed by `Consumer`,
until an implementation is found.
The parent class, `Animal`, is checked last.

### Extensions

Extending classes, implementing interfaces, or using
mixins all work when the affected class is editable.
However, sometimes it's useful to extend a class that
already exists or is part of another library or the Dart SDK.

In these cases, Dart offers the ability to write extensions
for existing classes. 

As an example, the following extension on the `String` class
from the Dart SDK allows parsing of integers:

_Dart_
```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
```

For the extension to become available,
it has to be present in the same file,
or its file must be imported.

Use it as follows:

_Dart_
```dart
import 'string_apis.dart'; // Import the file the extension is in
var age = '42'.parseInt(); // Use the extension method.
```

### Getters and setters

Getters and setters in Dart work exactly like
their JavaScript counterparts:

_JavaScript_
```js
class Person {
  _age = 0;

  get age() {
    return this._age;
  }

  set age(value) {
    if (value < 0) {
      throw new Error('age cannot be negative');
    }
    this._age = value;
  }
}

var person = new Person();
person.age = 10;
console.log(person.age);
```

_Dart_
```dart
class Person {
  int _age = 0;
  
  int get age {
    return _age;
  }
  
  set age(int value) {
    if (value < 0) {
      throw ArgumentError('Age cannot be negative');
    }
    _age = value;
  }
}

void main() {
  var person = Person();
  person.age = 10;
  print(person.age);
}
```

### Public and private members

Like JavaScript, Dart has no access modifier keywords:
all class members are public by default. 

While private class members are not yet officially
part of JavaScript because they are not part of any
published EcmaScript standard,
a proposal for this has been completed and is ready
to be included in the next publication of the standard.
As such, implementations for this have been available in
various browsers and runtimes for a while already. 

In JavaScript, you can indicate that a class member is private
by adding a pound symbol (`#`) as a prefix to its name:

_JavaScript_
```js
class Animal {
  eyes; // Public field 
  #paws; // Private field

  #printEyes() { // Private method
    print(this.eyes);
  }

  printPaws() { // Public method
    print(this.#paws);
  }
}
```

Similarly, Dart allows developers to make a
class member private by prefixing its name
with an underscore (`_`):

_Dart_
```dart
class Animal {
  int eyes; // Public field 
  int _paws; // Private field

  void _printEyes() { // Private method
    print(this.eyes);
  }

  void printPaws() { // Public method
    print(this._paws);
  }
}
```

In JavaScript, this is a convention,
but in Dart this is a full language feature
enforced by the compiler. 

A difference that should be noted is that in Dart,
private members are not private to the class,
but are private to the library,
meaning that private members can still be accessed
from code that is considered part of the same library.
By default, this is possible anywhere in the same file,
so private class members can still be accessed from code
in the same file. While you can expand this library scope
beyond a single file using the `part` directive,
it's generally advised to [avoid doing so][] and is usually
reserved for code generators. 

[avoid doing so]: /guides/libraries/create-library-packages#organizing-a-library-package

### Late variables

Assign the `late` keyword to class fields to
indicate they are initialized at a later point,
while remaining non-nullable. This is useful
for cases where a variable is never observed
before being initialized, allowing it to be initialized later.
This has several advantages over just labeling the field as nullable:

* (Non-nullable) late fields cannot have null assigned at a later point.

* (Non-nullable) late fields throw a runtime error when
  accessed before they are initialized.

_Dart_
```dart
// Using null safety:
class Coffee {
  late String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

In this case, `_temperature` is only initialized
after calling `heat()` or `chill()`.
If `serve()` is called before either are called,
a runtime exception occurs.
The `_temperature` field can never be assigned `null`.

You can use the `late` keyword to make initialization _lazy_,
when combined with an initializer:

_Dart_
```dart
class Weather {
  late int _temperature = _readThermometer();
}
```

In this example, `_readThermometer()` only runs
when the field is first accessed,
rather than on initialization. 

Lastly, use the `late` keyword to delay initialization
of `final` variables. While you don't need to immediately
initialize the final variable when marking it as `late`,
it still allows the variable to be initialized only once.
A second assignment results in a runtime error.

_Dart_
```dart
late final int a;
a = 1;
a = 2; // Throws a runtime exception `a` is already initialized.
```

## Generics 

While Vanilla JavaScript doesn’t offer generics,
they are available in Dart to improve type safety
and reduce code duplication. 

### Generic methods 

You can apply generics to methods.
To define a generic type, place it between `< >`
symbols after the method name.
This type can then be used within the method
(as the return type), or within the method’s parameters:

_Dart_
```dart
// Defining a method that uses generics.
T transform<T>(T param) {
  // E.g. doing some transformation on `param`...
  return param;
}
// Calling the method. Variable `str` is of type String.
var str = transform('string value'); 
```

In this case, passing `String` to the `transform` method
ensures that it returns a `String`. Likewise,
if an `int` is provided, the return value is an `int`.

Define multiple generic types by separating them with a comma:

_Dart_
```dart
// Defining a method with multiple generics.
T transform<T, Q>(T param1, Q param2) {
   ...
}
// Calling the method with explicitly defined types.
transform<int, String>(5, 'string value');
// Types are optional when the analyzer can infer them.
transform(5, 'string value');
```

### Generic classes

Generics can also be applied to classes.
You can include the type to use when calling a constructor,
which allows you to tailor reusable classes to specific types.

In the following example, the `Cache` class is for
caching specific types:

_Dart_
```dart
class Cache<T> {
  T getByKey(String key) {}
  void setByKey(String key, T value) {}
}
// Creating a cache for strings
var stringCache = Cache<String>(); // stringCache has type Cache<String>
stringCache.setByKey('Foo', 'Bar'); // Valid, setting a string value.
stringCache.setByKey('Baz', 5); // Invalid, int type does not match generic.
```

If the type declaration is omitted,
the runtime type will be `Cache<dynamic>`
and both calls to `setByKey` are valid.

### Restricting generics

You can use generics to restrict your code to
a family of types using `extends`. This ensures
that your class is instantiated with a generic type
that extends a specific type:

_Dart_
```dart
class NumberManager<T extends num> {
   ...
}
// Valid.
var manager = NumberManager<int>(); 
var manager = NumberManager<double>(); 
// Invalid, String nor its parent classes extend num.
var manager = NumberManager<String>(); 
```

### Generics in literals

`Map`, `Set`, and `List` literals can explicitly
declare generic types, which is useful when the
type isn’t inferred or is incorrectly inferred. 

For example, the `List` class has a generic definition:
`class List<E>`. Generic type `E` refers to the type of
the list’s contents. Normally, this type is automatically inferred,
which is used in some `List` class’s member types.
(For example, its first getter returns a value of type `E`.)
When defining a `List` literal,
you can explicitly define the generic type as follows:

_Dart_
```dart
// Automatic type inference
var objList = [5, 2.0]; // Type: List<num>
// Explicit type definition:
var objList = <Object>[5, 2.0]; // Type: List<Object>
// Sets work identically:
var objSet = <Object>{5, 2.0};
```

This is also true for `Map`s,
which also define their key and value types
using generics (`class Map<K, V>`):

_Dart_
```dart
// Automatic type inference
var map = {
  'foo': 'bar'
}; // Type: Map<String, String>
// Explicit type definition:
var map = <String, Object>{
  'foo': 'bar'
}; // Type: Map<String, Object>
```

## Doc comments

Regular comments work the same in Dart as they do
in JavaScript. Using `//` comments out everything beyond
it for the remaining line, and you can use `/* ... */`
to block comments spanning multiple lines.

In addition to regular comments,
Dart also has [doc comments][] that work in tandem
with [`dart doc`][]: a first party tool that generates
HTML documentation for Dart packages.
It's considered best practice to place doc comments
above all declarations for public members.

Define a doc comment by using three forward slashes
instead of two (`///`):

_Dart_
```dart
/// The number of characters in this chunk when unsplit.
int get length => ...
```

[`dart doc`]: /tools/dart-doc
[doc comments]: /guides/language/effective-dart/documentation#doc-comments

## Next steps

This guide has introduced you to the major differences
between Dart and JavaScript. At this point,
you might consider moving to the general documentation
for Dart or [Flutter]({{site.flutter}}) 
(an open-source framework that
uses Dart for building beautiful, natively compiled,
multi-platform applications from a single codebase),
where you'll find in-depth information about the
language and practical ways of getting started. 

Some possible next steps:

* [Language tour][] to learn more about the Dart language
* [Library tour][] to learn about Dart's core libraries
* [Dart codelabs][] for hands-on experience learning a variety of topics
* [Effective Dart][] to learn about common conventions
  and guidelines when writing Dart code

[Language tour]:  /guides/language/language-tour
[Library tour]:   /guides/libraries/library-tour
[Dart codelabs]:  /codelabs
[Effective Dart]: /guides/language/effective-dart
