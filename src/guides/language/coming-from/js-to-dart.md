---
title: Learning Dart as a JavaScript developer
description: Leverage your JavaScript knowledge when learning Dart.
body_class: highlight-languages
---

This guide aims to leverage your JavaScript programming knowledge
when learning Dart.
It showcases key similarities and differences in both languages,
and introduces Dart concepts that are unsupported in JavaScript.
As a JavaScript developer, Dart should feel quite familiar,
as both languages share many concepts.

Like JavaScript, Dart runs on an event loop,
so both languages execute code in a similar way.
For example, asynchronous concepts like futures
(promises in JavaScript) and the `async/await` syntax are very similar.

Dart is strongly typed, unlike JavaScript.
If you have used with TypeScript or Flow,
this should simplify learning Dart.
If you've mostly worked with pure JavaScript,
it might be more of an adjustment.
With strong typing, Dart catches many errors before compiling
that might exist in JavaScript code.

Dart enables null safety by default.
JavaScript doesn't support null safety.
As a JavaScript developer,
it might take a while to learn how to write null safe code,
but the trade-off is better protection against
null reference exceptions that are detected even
before compiling Dart code. (Thereby avoiding those
dreaded `TypeError`s that occur when doing operations
on a JavaScript variable that turns out to be null.)

## Conventions and linting

JavaScript and Dart both have linting tools to enforce standard conventions.
While JavaScript offers many tools, standards, and configurations,
Dart has one official set of layout and style conventions plus a linter
to simplify compliance.
The Dart analyzer lints code along with providing more analytical functions.
To customize the lint rules for your project,
follow the [Customizing static analysis][] instructions.

Dart provides [`dart fix`][] to find and fix errors.

Dart also provides a code formatter similar to
JavaScript tools like [Prettier][].
To format code in any Dart project, run
[`dart format`](/tools/dart-format) on your command line.
The IDE plugins for Dart and Flutter also provide this ability.

Dart supports trailing commas for comma-separated lists of collections,
parameters, or arguments. When you add the trailing comma,
the formatter places each list item on its own line.
When you believe your list may have more items at a later date,
add the trailing comma. Avoid adding the trailing comma for the formatting
benefit alone.

JavaScript supports trailing commas in list and map literals only.

{{site.alert.secondary}}
  To learn more about:

  * Using commas to make your code read more like HTML, read
    [Using trailing commas][] on flutter.dev.
  * Linting Dart, read [Linter rules][].
  * Writing good Dart code, read [Effective Dart][].
{{site.alert.end}}

[Customizing static analysis]: /tools/analysis
[`dart fix`]: /tools/dart-fix
[Effective Dart]: /effective-dart
[Linter rules]: /tools/linter-rules
[Prettier]: https://prettier.io/
[Using trailing commas]: {{site.flutter-docs}}/development/tools/formatting#using-trailing-commas

## Built-in types

Both JavaScript and Dart categorize their data into _types_.
Every variable has an associated type.
The type determines the kind of value the variable can store and
what operations can be performed on these values.
Dart differs from JavaScript in that it assigns a static type
to every expression and variable.
The static type predicts the runtime type
of the values of a variable, or of the value of an expression.
This means that Dart apps have sound static typing.

JavaScript provides primitive types `num`, `string`, and `boolean`
and the `null` value as well as _arrays_ and a `Map` type.

Dart supports the following built-in types:

* Numbers (`num`, `int`, `double`)
* Strings (`String`)
* Booleans (`bool`)
* Lists (`List`, also known as arrays)
* Sets (`Set`)
* Maps (`Map`)
* Symbols (`Symbol`)
* The value `null` (`Null`)

To learn more, check out [Built-in types][] in the [Dart Language Tour][].

All non-`Null` types in Dart are subtypes of Object.
All values are also objects.
Dart doesn't use "primitive types" like JavaScript.
By contrast, Dart normalizes or _canonicalizes_ number, boolean
and `null` values.
This means only one `int` value with the numerical value `1` exists.

{{site.alert.note}}
  JavaScript has two equality operators, `==` and `===`.
  The `==` operator performs the equality test after doing any necessary
  type conversions on or to primitive values.
  The `===` operator doesn't perform type conversions.
  Dart uses the `identical` function to check if two values are the
  same object, and the `==` operator to check whether the objects
  consider themselves as equal.
{{site.alert.end}}

[Built-in types]: /language/built-in-types
[Dart Language Tour]: /guides/language

For example:
The equals operator `==` and the `identical()` method return `true`
for the same values of number types. Review the example shown in the
following code:

```dart
var a = 2;
var b = 1 + 1;

print(a == b); // Prints true
print(identical(a, b)); // Prints true; only one "2" object exists
```

### Primitive Types

This section covers how Dart represents primitive types from JavaScript.
#### Numbers

Dart has three data types for holding numbers:

`num`
: The equivalent to the generic number type in JavaScript.

`int`
: A numeric value without a fractional part.

`double`
: Any 64-bit (double-precision) floating point number.

The Dart API includes all these types as classes.
Both the `int` and `double` types share `num` as their parent class:

<img
  src="/assets/img/guides/number-classes.png"
  alt="num subclasses Object and int and double each subclass num">

As Dart considers numbers as objects, numbers can expose their
own utility functions as object methods.
You don't need to use an additional object to apply a function to a number.

For example, to round a `double` to an integer:

```js
let rounded = Math.round(2.5);
```

```dart
var rounded = 2.5.round();
```

#### Strings

Strings in Dart work like strings in JavaScript.
To write a string literal, enclose it in single (`'`) or double (`"`)
quotation marks.
The majority of Dart developers use single quotes,
but the language enforces no standard.
Use double quotation marks if you don't want to escape
single quotes within the string.

```dart
var a = 'This is a string.';
```

##### Escaping special characters

To include a character with another meaning in a string,
like a `$` used for string interpolation, you must escape that character.
Escaping special characters in Dart works like JavaScript
and most other languages.
To escape special characters,
precede that character with the backslash character (`\`).

The following code shows some examples.

```dart
final singleQuotes = 'I\'m learning Dart'; // I'm learning Dart
final doubleQuotes = "Escaping the \" character"; // Escaping the " character
final dollarEscape = 'The price is \$3.14.'; // The price is $3.14.
final backslashEscape = 'The Dart string escape character is \\.';
final unicode = '\u{1F60E}'; // 😎,  Unicode scalar U+1F60E
```

{{site.alert.note}}
  You can use four-digit hexadecimal characters with or without curly braces.
  To learn more about working with unicode characters,
  see [Runes and grapheme clusters][].
{{site.alert.end}}

[Runes and grapheme clusters]: /language/built-in-types#runes-and-grapheme-clusters

##### String interpolation

JavaScript supports template literals.
These use backtick (`` ` ``) character delimiters for the following reasons:

* To allow for multiline strings
* To interpolate strings with embedded expressions
* To create special constructs called tagged templates

In Dart, you don't need to enclose a string in backticks to concatenate
strings or use interpolations within string literals.

To learn more, check out [Strings][] in the Dart Language Tour.

[Strings]: /language/built-in-types#strings

As in JavaScript template literals,
you can use the `${<expression>}` syntax to insert expressions into
a string literal.
Dart uses this syntax and allows you to omit the curly braces
when the expression uses a single identifier.

```dart
var food = 'bread';
var str = 'I eat $food'; // I eat bread
var str = 'I eat ${food}'; // I eat bread
```

#### String concatenation and multiline declaration

In JavaScript, you can define multiline strings
using template literals.
Dart has two ways to define multiline strings.

<ol markdown="1">
<li markdown="1"> Using implicit string concatenation:
    Dart concantenates any neighboring string literals,
    even when spread over multiple lines:

```dart
final s1 = 'String '
    'concatenation'
    " even works over line breaks.";
```
</li>

<li markdown="1"> Using a multi line string literal:
When using three quotation marks (either single or double)
on either side of the string, the literal can span multiple lines.


```dart
final s2 = '''
You can create
multiline strings like this one.
''';

final s3 = """
This is also a
multiline string.""";
```
</li>
</ol>

#### Equality

Dart considers two strings equal when they contain the same sequence
of code units. To determine if two strings have the same sequences,
use the equal-to operator (`==`).

```dart
final s1 = 'String '
    'concatenation'
    " works even over line breaks.";
assert(s1 ==
    'String concatenation works even over '
        'line breaks.');
```

#### Booleans

Boolean values in both Dart and Javascript express a binary condition.
These two values represent whether a value or expression is
`true` or `false`.
You can return the values using the literals `true` and `false`,
or produced them using expressions like `x < 5` or `y == null`.

```js
let isBananaPeeled = false;
```


```dart
var isBananaPeeled = false;
```

## Variables

Variables in Dart work like variables in JavaScript,
with two exceptions:

1. Each variable has a type.
1. Dart scopes all variables at the block level,
   like `let` and `const` variables in JavaScript.

A Dart variable gets its type in one of two ways:

1. Declared: A type written in the declaration.
1. Inferred: An expression used to initialize the variable.
   By [convention][omit_local_variable_types], 
   use `var` or `final` when the analyzer can infer the type.

[omit_local_variable_types]: /effective-dart/design#dont-redundantly-type-annotate-initialized-local-variables

```js
// Declare and initialize a variable at once
let name = "bob";
```

```dart
// Declare a variable with a specific type
// when you don't provide an initial value
String name;
// Declare and initialize a variable
// at the same time and Dart infers
// the type
var name = 'bob';
```

Variables can only accept values of their type.

```dart
var name = 'bob';
name = 5; // Forbidden, as `name` has type `String`.
```

If you don't provide an initial value or explicit type,
Dart infers the variable's type to be the catch-all type `dynamic`.

Like JavaScript variables, you can assign any value to Dart variables
that use the `dynamic` type.

```js
// Declare a variable
let name;
// Initialize the variable
name = "bob";
```


```dart
// Declare a variable without a type or assigned value
// and Dart infers the 'dynamic' type
var name;
// Initialize the variable and the type remains `dynamic`
name = 'bob';
name = 5; // Allowed, as `name` has type `dynamic`.
```

### Final and const

Both JavaScript and Dart use variable modifiers. Both use `const`, but
differ in how `const` works. Where JavaScript would use `const`,
Dart uses `final`.

When you add `final` to a Dart variable or `const` to a JavaScript variable,
you must initialize the variable before other code can read its value.
Once initialized, you can't change these variables' references.

When Dart uses `const`, it refers to special values that it creates
when compiling.
Dart uses limited expressions to create these immutable values.
These expressions _cannot_ have side effects.
Under these conditions, the compiler can then predict the precise value
of a constant variable or expression, not just its static type.

```dart
final String name;
// Cannot read name here, not initialized.
if (useNickname) {
  name = "Bob";
} else {
  name = "Robert";
}
print(name); // Properly initialized here.
```

{{site.alert.note}}
When you create an object, the class constructor must initialize the
`final` instance variables.
This ensures that these variables have a value before anyone can read them.

Learn more in the [Classes](#classes) section.
{{site.alert.end}}

In Dart, _constant variables must contain constant values_.
Non-constant variables can contain constant values that
you can also mark as `const`.

```dart
var foo = const [];
  // foo is not constant, but the value it points to is.
  // You can reassign foo to a different list value,
  // but its current list value cannot be altered.

const baz = []; // Equivalent to `const []`
```

Likewise, classes can have their own `const` constructors
that produce immutable instances.

You can't modify a `const` variable in JavaScript or Dart.
JavaScript does allow you to modify a `const` object's fields, but
Dart does not.

To learn more, see the [Classes](#classes) section.

## Null safety

Unlike JavaScript, Dart supports null safety.
In Dart, all types default to non-nullable.
This benefits Dart developers because Dart catches null reference
exceptions when writing code, rather than at runtime.

### Nullable vs non-nullable types

None of the variables in the following code example can be `null`.

```dart
// In null-safe Dart, none of these can ever be null.
var i = 42; // Inferred to be an int.
String name = getFileName();
final b = Foo(); // Foo() invokes a constructor
```

To indicate that a variable might have the value `null`,
add `?` to its type declaration:

```dart
int? aNullableInt = null;
```

The same goes for any other type declaration,
such as a function declaration:

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
As in JavaScript, Dart supports the null assignment operator (`??=`),
null-coalescing operator (`??`), and optional chaining operator (`?.`).
These operators work the same as JavaScript.

#### ! Operator

In cases where a nullable variable or expression might be non-null,
you can tell the compiler to repress any compile time errors
using the (`!`) operator. Place this operator after the expression.

Don't confuse this with Dart's not (`!`) operator,
which uses the same symbol but place before the expression.

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

```dart
// On the top level
int multiply(a, b) {
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

### Arrow syntax

Both Dart and JavaScript support arrow syntax (`=>`),
but differ in how they support it.
In Dart, you can only use the arrow syntax when the function
contains a single expression or return statement.

For example, the following `isNoble` functions are equivalent:

```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

### Parameters

In JavaScript, all parameters _can_ be positional parameters.
By default, Dart _requires_ you to pass all parameters as arguments
to functions.

```dart
int multiply(int a, int b) {
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

To define optional positional parameters, enclose them
in square brackets following any required positional parameters.
You can't follow optional parameters with required parameters.

Due to null safety, optional positional parameters
must have a default value or be marked as nullable.
To learn more, see the preceding section about [null safety](#null-safety).

The following code has one valid and two invalid examples
of functions that define optional positional parameters.

```dart
// Valid: `b` has a default value of 5. `c` is marked as nullable.
multiply(int a, [int b = 5, int? c]) {
  ...
}
// Invalid: a required positional parameter follows an optional one.
multiply(int a, [int b = 5], int c) {
  ...
}
// Invalid: Neither optional positional parameter has a default
//          value or has been flagged as nullable.
multiply(int a, [int b, int c]) {
  ...
}
```

The following example shows how to call a function with optional parameters:

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

Again, with null safety, named parameters that are not flagged as
required either need to have a default value or be flagged as nullable.

The following code defines a function with named parameters:

```dart
// Valid:
// - `a` has been flagged as required
// - `b` has a default value of 5
// - `c` is marked as nullable
// - Named parameters follow the positional one
multiply(bool x, {required int a, int b = 5, int? c}) {
  ...
}
```

The following examples call a function with named parameters:

```dart
// All are valid function calls.
// Beyond providing the required positional parameter:
multiply(false, a: 3); // Only provide required named parameters
multiply(false, a: 3, b: 9); // Override default value of `b`
multiply(false, c: 9, a: 3, b: 2); // Provide all named parameters out of order
```

### First-class functions

JavaScript and Dart treat functions as first-class citizens.
This means that Dart treats functions as any other object.
For example, the following code shows how to
pass a function as a parameter to another function:

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

Likewise, Dart also has two ways to declare anonymous functions.
Both work in a similar manner to the JavaScript arrow expression.
Dart's anonymous functions do not support the extra functionality
that comes with regular function expressions.
For example, JavaScript's support for a function expression acting
like a constructor, or creating a custom binding to this.

To learn more, see the [Classes](#classes) section.

```js
// A regular function expression
// assigned to a variable
let funcExpr = function(a, b) {
  return a * b;
}
// The same anonymous function
// expressed as an arrow
// function with curly braces.
let arrowFuncExpr = (a, b) => {
  return a * b;
}
// An arrow function with only
// one return statement as
// its contents does not
// require a block.
let arrowFuncExpr2 = (a, b) => a * b;
```


```dart
// Assign an anonymous function
// to a variable.
var blockFunc =
  optionalCallback ?? (int a, int b) {
    return a * b;
};

// For an expression with only a return statement,
// you can use the arrow syntax:
var singleFunc = (int a, int b) => a * b;
```

As with JavaScript, you can pass anonymous functions to other functions.
Developers often pass anonymous functions when using the `map` function
for arrays and lists:

```js
// returns [4, 5, 6]
[1, 2, 3].map(e => e + 3);

// returns [5, 7, 9]
[1, 2, 3].map(e => {
  e *= 2;
  return e + 3;
});
```

```dart
// returns [4, 5, 6]
[1, 2, 3].map((e) => e + 3).toList();

// returns [5, 7, 9]
var list2 = [1, 2, 3].map((e) {
  e *= 2;
  return e + 3;
}).toList();
```

{{site.alert.note}}
  The `map` function in the previous examples returns
  an `Iterable<T`>, rather than a `List<T>`.
  The `toList` function converts the returned
  `Iterable` back to a `List`.

  A list literal could achieve the same goal.

  ```dart
  // These two statements are equivalent:
  print([for (var e in [1, 2, 3]) e + 3]);
  print([1, 2, 3].map((e) => e + 3).toList());
  ```
{{site.alert.end}}

### Generator functions

Both languages support [_generator functions_].
These functions return an iterable collection of items
computed to avoid unncessary work.

To write a generator function in Dart,
add the `sync*` keyword after the function parameters,
and return an `Iterable`.
Add items to the final iterable using the
`yield` keyword, or add whole sets of items using `yield*`.

[_generator functions_]: /language/functions#generators

The following example shows how to write a
basic generator function:


```js
function* naturalsTo(n) {
  let k = 0;
  while (k < n) {
    yield k++;
  }
}

// Returns [0, 1, 2, 3, 4]
for (let value of naturalsTo(5)) {
  console.log(value);
}

```


```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield k++;
  }
}

// Returns an iterable with [0, 1, 2, 3, 4]
print(naturalsTo(5).toList());
```


```js
function* doubleNaturalsTo(n) {
  let k = 0;
  while (k < n) {
    yield* [k, k];
    k++;
  }
}

// Returns [0, 0, 1, 1, 2, 2]
for (let value of doubleNaturalsTo(3)) {
  console.log(value);
}
```

```dart
Iterable<int> doubleNaturalsTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield* [k, k];
    k++;
  }
}

// Returns an iterable with [0, 0, 1, 1, 2, 2]
print(doubleNaturalsTo(3));
```

You can also define asynchronous generator functions,
which return streams instead of iterables.
Learn more in the upcoming [Asynchrony](#asynchrony) section.

## Statements

This section describes differences in statements between
JavaScript and Dart.

### Control flow (if/else, for, while, switch)

Most control statements work like their JavaScript counterparts.
Some have additional uses for [Collections](#collections).

#### Iteration

While both JavaScript and Dart have `for-in` loops,
their behaviors differ.

JavaScript's `for-in` loop iterates over an object's properties.
To iterate over a JavaScript iterable object's elements,
you must use `for-of` or `Array.forEach()`.
Dart's `for-in` loop works like JavaScripts `for-of`.

The following example shows iterating
over a collection and printing out each element:

```js
for (const element of list) {
  console.log(element);
}
```

```dart
for (final element in list) {
  print(element);
}
```

#### Switch

{{site.alert.note}}
  One key difference with the `switch` statement
  in JavaScript and Dart: when a case has no `break`,
  `continue`, or `return` statement,
  JavaScript allows execution to fall through and continue
  with the next statement. However,
  Dart only allows this when a case's body is empty.
{{site.alert.end}}

When using `continue` in a `switch` statement,
you can combine it with a label that is put on a case:

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
Neither language supports adding new operators.
Dart supports overloading some existing operators
with the `operator` keyword. For example:

```dart
class Vector {
  final double x;
  final double y;
  final double z;
  Vector(this.x, this.y, this.z);
  Vector operator +(Vector other) => Vector(
    x + other.x, 
    y + other.y,
    z + other.z,
  );
  Vector operator *(double scalar) => Vector(
    x * scalar,
    y * scalar,
    z * scalar,
  );
}
```

#### Arithmetic operators

The equality and relational operators of both languages
are almost identical, as shown in the following table:

| Meaning                                           | JavaScript operator | Dart operator |
|---------------------------------------------------|---------------------|---------------|
| Add                                               | `+`                 | `+`           |
| Subtract                                          | `-`                 | `-`           |
| Unary minus, also known as negation               | `-expr`             | `-expr`       |
| Multiply                                          | `*`                 | `*`           |
| Divide                                            | `/`                 | `/`           |
| Divide returning an integer result                |                     | `~/`          |
| Get the remainder of an integer division (modulo) | `%`                 | `%`           |
| `x = x + 1` (expression value is `x + 1`)         | `++x`               | `++x`         |
| `x = x + 1` (expression value is `x`)             | `x++`               | `x++`         |
| `x = x - 1` (expression value is `x - 1`)         | `--x`               | `--x`         |
| `x = x - 1` (expression value is `x`)             | `x--`               | `x--`         |
{:.table .table-striped}

For example:

```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder

a = 0;
b = ++a; // Increment a before b gets its value.
assert(a == b); // 1 == 1

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
a `~/` operator (called a _truncating division operator_),
that divides a double and outputs a floored integer:

```dart
assert(25 == 50.4 ~/ 2);
assert(25 == 50.6 ~/ 2);
assert(25 == 51.6 ~/ 2);
```

#### Equality and relational operators

The equality and relational operators of both languages
work in the same way:

| Meaning                   | JavaScript operator | Dart operator |
|---------------------------|---------------------|---------------|
| Strict equal              | `===`               | `==`          |
| Abstract equal            | `==`                |               |
| Strict not equal          | `!==`               | `!=`          |
| Abstract not equal        | `!=`                |               |
| Greater than              | `>`                 | `>`           |
| Less than                 | `<`                 | `<`           |
| Greater than or equal to  | `>=`                | `>=`          |
| Less than or equal to     | `<=`                | `<=`          |
{:.table .table-striped}

The `==` and `!=` JavaScript operators have no equivalent.

For example:

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

| Meaning                             | JavaScript operator | Dart operator |
|-------------------------------------|---------------------|---------------|
| Typecast                            |                     | `x as T`      |
| True if object has specified type   | `x instanceof T`    | `x is T`      |
| True if object lacks specified type | `!(x instanceof T)` | `x is! T`     |
{:.table .table-striped}

The result of `obj is T` is true if `obj`
implements the interface specified by `T`.
For example, `obj is Object?` is always true.

Use the typecast operator (`as`) to ensure that a value
has a particular type. The compiler can use that,
if you _know_ that the object will have that type.

For example:

```dart
(person as Employee).employeeNumber = 4204583;
```

If you don't _know_ that the object is of type `T`,
then use `is T` to check the type _before_ using the object.

In Dart, the types of local variables update within
the scope of the if statement.
This is not the case for instance variables.

```dart
if (person is Employee) {
   person.employeeNumber = 4204583;
}
```

#### Logical operators

You can invert or combine boolean expressions
using logical operators. The logical operators
of both languages are identical.

| Meaning                                                        | JavaScript operator | Dart operator |
|----------------------------------------------------------------|---------------------|---------------|
| Inverts next expression (changes false to true and vice versa) | `!x`                | `!x`          |
| Logical OR                                                     | `||`                | `||`          |
| Logical AND                                                    | `&&`                | `&&`          |
{:.table .table-striped}

JavaScript allows any value to be used where you need a Boolean value.
It then converts those values to either `true` or `false`.
JavaScript considers empty strings and the number `0` to be "falsy" values.
Dart allows `bool` values in conditions and as operands of logical operators.

For example:

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

| Meaning                                               | JavaScript operator | Dart operator |
|-------------------------------------------------------|---------------------|---------------|
| Bitwise AND                                           | `&`                 | `&`           |
| Bitwise OR                                            | `|`                 | `|`           |
| Bitwise XOR                                           | `^`                 | `^`           |
| Unary bitwise complement (0s become 1s; 1s become 0s) | `~expr`             | `~expr`       |
| Shift left                                            | `<<`                | `<<`          |
| Shift right                                           | `>>`                | `>>`          |
| Unsigned shift right                                  | `>>>`               | `>>>`         |
{:.table .table-striped}

For example:

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

#### Conditional operator

Both Dart and JavaScript contain a conditional operator (`?:`)
for evaluating expressions.
Some developers refer to this as a ternary operator
because it takes three operands.
As Dart has another operator (`[]=`) that takes three operands,
call this operator (`?:`) the conditional operator.
This operator works for expressions like [if-else][] does for statements.

```js
let visibility = isPublic ? "public" : "private";
```

```dart
final visibility = isPublic ? 'public' : 'private';
```

[if-else]: /language/branches#if

### Assignment operators

Use the (`=`) operator to assign values.

```dart
// Assign value to a
a = value;
```

This operator also has a null-aware variant (`??=`).

To learn more,
see the [null-assignment](#null-aware-operators) operator section.

JavaScript and Dart include operators that calculate and assign
new values to the variable in the expression.
These assignment operators use the right-side value and
the variable initial value as operands.

The following table lists these assignment operators:

| Operator | Description                     |
|----------|---------------------------------|
| `=`      | Assignment                      |
| `+=`     | Addition assignment             |
| `-=`     | Subtraction assignment          |
| `*=`     | Multiplication assignment       |
| `/=`     | Division assignment             |
| `~/=`    | Truncating division assignment  |
| `%=`     | Remainder (modulo) assignment   |
| `>>>=`   | Unsigned right shift assignment |
| `^=`     | Bitwise XOR assignment          |
| `<<=`    | Left shift assignment           |
| `>>=`    | Right shift assignment          |
| `&=`     | Bitwise AND assignment          |
| `|=`     | Bitwise OR assignment           |
{:.table .table-striped}

JavaScript does not support the `~/=` assignment operator.

```dart
var a = 5;
a *= 2; // Multiply `a` by 2 and assign the result back to a.
print(a); // `a` is now 10.
```

### Cascades (`..` operator)

Dart allows you to chain multiple method calls, property assignments,
or both on a single object. Dart refers to this as _cascading_ and
uses the cascade syntax (`..`) to perform this action.

JavaScript lacks this syntax.

The following example shows chaining multiple methods
on a newly constructed object using the cascade syntax:

```dart
var animal = Animal() // Sets multiple properties and methods
  ..name = "Bob"
  ..age = 5
  ..feed()
  ..walk();

print(animal.name); // "Bob"
print(animal.age); // 5
```

To make the first cascade syntax null-aware, write it as `?..`.

```dart
var result = maybePerson
    ?..employment = employer
    ..salary = salary;
```

Dart ignores the entire cascade if the `maybePerson` value is `null`.

## Collections

This section covers some collection types in Dart and compare them
to similar types in JavaScript.

### Lists

Dart writes list literals in the same ways as JavaScript arrays.
Dart encloses lists in square brackets and separate values with commas.

```dart
// Initialize list and specify full type
final List<String> list1 = <String>['one', 'two', 'three'];

// Initialize list using shorthand type
final list2 = <String>['one', 'two', 'three'];

// Dart can also infer the type
final list3 = ['one', 'two', 'three'];
```

The following code samples give an overview of the basic actions that
you can perform on a Dart `List`.
The following example shows how to retrieve a value from a `List`
using the index operator.

```dart
final fruits = <String>['apple', 'orange', 'pear'];
final fruit = fruits[1];
```

Add a value to the end of the `List` using the `add` method.
Add another `List` using the `addAll` method:

```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
```

Insert a value at a specific position using the
`insert` method. Insert another `List` at a
specific position using the `insertAll` method:

```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits.insert(0, 'peach');
fruits.insertAll(0, ['kiwi', 'mango']);
```

Update a value in the `List` combining the
index and assignment operators:

```dart
final fruits = <String>['apple', 'orange', 'pear'];
fruits[2] = 'peach';
```

Remove items from a `List` using one of the following methods:

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

```dart
final fruits = <String>['apple', 'orange', 'pear'];
assert(fruits.length == 3);
```

Use `isEmpty` to check if the `List` is empty:

```dart
var fruits = [];
assert(fruits.isEmpty);
```

Use `isNotEmpty` to check if the `List` is not empty:

```dart
final fruits = <String>['apple', 'orange', 'pear'];
assert(fruits.isNotEmpty);
```

#### Filled

Dart's `List` class includes a way to create a List with
each item having the same value.
This `filled` constructor creates a fixed-length list of size `n` with
one default value.
The following example create a list of 3 items:

```dart
final list1 = List.filled(3, 'a'); // Creates: [ 'a', 'a', 'a' ]
```

* You cannot add or remove elements from this list by default.
  To permit this list to add or remove elements, add `, growable: true`
  to the end of the parameter list.
* You can access and update elements of this list using their index value.

#### Generate

The Dart `List` class includes a way to create a List of incrementing values.
This `generate` constructor creates a fixed-length list of size `n`
with a template to build element values.
This template takes the index as a parameter.

```dart
// Creates: [ 'a0', 'a1', 'a2' ]
final list1 = List.generate(3, (index) => 'a$index');
```

### Sets

Unlike JavaScript, Dart supports defining `Set`s with literals.
Dart defines sets in the same way as lists,
but using curly braces rather than square brackets.
Sets are unordered collections that only contain unique items.
Dart enforces the uniqueness of these items using hash codes,
meaning that objects need hash values to be stored in a `Set`.

{{site.alert.note}}
  In Dart, the hash value defaults to the instance of an object
  but you can override it to use a set of properties.
  To learn more, see the [`hashCode`][] property page.
{{site.alert.end}}

[`hashCode`]: {{site.dart-api}}/dart-core/Object/hashCode.html

The following code snippet shows how to initialize a `Set`:

```dart
final abc = {'a', 'b', 'c'};
```

The syntax for creating an empty set might seem
confusing at first, because specifying empty
curly braces (`{}`) results in creating an empty `Map`.
To create an empty `Set`, precede the `{}` declaration
with a type argument or assign `{}` to a variable of type `Set`:

```dart
final names = <String>{};
// Set<String> names = {}; // This works, too.
// final names = {}; // Creates an empty map, not a set.
```

The following examples provide an overview of the
basic actions that you can perform on a Dart `Set`.

Add a value to the `Set` using the `add` method.
Use the `addAll` method to add multiple values:

```dart
final fruits = {'apple', 'orange', 'pear'};
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
```

Use one of the following methods in `Set`
to remove content from the set:

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

```dart
final fruits = {'apple', 'orange', 'pear'};
assert(fruits.length == 3);
```

Use `isEmpty` to check if the `Set` is empty:

```dart
var fruits = <String>{};
assert(fruits.isEmpty);
```

Use `isNotEmpty` to check if the `Set` is not empty:

```dart
final fruits = {'apple', 'orange', 'pear'};
assert(fruits.isNotEmpty);
```

### Maps

The `Map` type in Dart resembles the `Map` type in JavaScript.
Both types associate keys with values.
A key can be any object type if all keys have the same type.
This rule applies to values as well.
Each key occurs once at most, but you can use the same value multiple times.

Dart bases the dictionary on a hash table.
This means that keys need to be hashable.
Every Dart object contains a hash.

{{site.alert.note}}
In Dart, the hash value of an object defaults to a value derived from
the object's identity, and being compatible with an equality where the
object can only equal itself. To introduce an equality based on the
_contents_ of the object, override `hashCode` and `operator==`.
{{site.alert.end}}

Consider these simple `Map` examples, created using literals:

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

The following code samples provide an overview of the basic actions that
you can perform on a Dart `Map`.
The following example shows how to retrieve a value from a `Map` using
the index operator.

```dart
final gifts = {'first': 'partridge'};
final gift = gifts['first'];
```

{{site.alert.note}}
If the map does not include the lookup key, the index operator returns `null`.
{{site.alert.end}}

Use the `containsKey` method to check if the `Map` includes a key.

```dart
final gifts = {'first': 'partridge'};
assert(gifts.containsKey('fifth'));
```

Use the index assignment operator (`[]=`) to add or update an entry
in the `Map`.
If the `Map` doesn't yet contain the key, Dart adds the entry.
If the key exists, Dart updates its value.

```dart
final gifts = {'first': 'partridge'};
gifts['second'] = 'turtle'; // Gets added
gifts['second'] = 'turtle doves'; // Gets updated
```

Use the `addAll` method to add another `Map`.
Use the `addEntries` method to add other entries to the `Map`.

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

Use the `remove` method to remove an entry from the `Map`.
Use the `removeWhere` method to remove all entries that satisfy a given test.

```dart
final gifts = {'first': 'partridge'};
gifts.remove('first');
gifts.removeWhere((key, value) => value == 'partridge');
```

Use `length` to obtain the number of key-value pairs in the `Map`.

```dart
final gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

Use `isEmpty` to check if the `Map` is empty.

```dart
final gifts = {};
assert(gifts.isEmpty);
```

Use `isNotEmpty` to check if the `Map` is not empty.

```dart
final gifts = {'first': 'partridge'};
assert(gifts.isNotEmpty);
```

### Unmodifiable

Pure JavaScript doesn't support immutability.
Dart offers multiple ways to make collections like arrays, sets, or
dictionaries immutable.

* If the collection is a compile-time constant and shouldn't
  be modified, use the `const` keyword:<br>
  `const fruits = <String>{'apple', 'orange', 'pear'};`
* Assign the `Set` to a `final` field, meaning that
  the `Set` itself doesn't have to be a compile-time constant.
  This ensures that the field can't be overridden with
  another `Set`, but it still allows the size or the contents
  of the `Set` to be modified:<br>
  `final fruits = <String>{'apple', 'orange', 'pear'};`
* Create a final version of your collection type
  using the `unmodifiable` constructor
  (as shown in the following example).
  This creates a collection that cannot change its size or content:

```dart
final _set = Set<String>.unmodifiable(['a', 'b', 'c']);
final _list = List<String>.unmodifiable(['a', 'b', 'c']);
final _map = Map<String, String>.unmodifiable({'foo': 'bar'});
```

### Spread operator

As in JavaScript, Dart supports embedding a list
into another list using the spread operator (`...`)
and the null-aware spread operator (`...?`).

```dart
var list1 = [1, 2, 3];
var list2 = [0, ...list1];　// [0, 1, 2, 3]
// When the list being inserted could be null:
list1 = null;
var list2 = [0, ...?list1]; // [0]
```

This also works for sets and maps:

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

`Future` is Dart's version of a JavaScript `Promise`.
Both are the _result_ of an asynchronous operation that resolves at a
later point.

Functions in Dart or in Dart packages might return a `Future`,
rather than the value they represent, as the value might not be
available until later.

The following example shows that handling a future works
in the same way in Dart as a promise works in JavaScript.

```js
const httpResponseBody = func();

httpResponseBody.then(value => {
  console.log(
    `Promise resolved to a value: ${value}`
  );
});
```


```dart
Future<String> httpResponseBody = func();

httpResponseBody.then((String value) {
  print('Future resolved to a value: $value');
});
```

Similarly, futures can fail like promises.
Catching errors works the same as well:

```js
httpResponseBody
  .then(...)
  .catch(err => {
    console.log(
      "Promise encountered an error before resolving."
    );
  });
```


```dart
httpResponseBody
  .then(...)
  .catchError((err) {
    print(
      'Future encountered an error before resolving.'
    );
  });
```

You can also create futures.
To create a `Future`, define and call an `async` function.
When you have a value that needs to be a `Future`,
convert the function as in the following example.

```dart
String str = 'String Value';
Future<String> strFuture = Future<String>.value(str);
```

#### Async/Await

If you're familiar with promises in JavaScript,
you're likely also familiar with the `async`/`await` syntax.
This syntax is identical in Dart: functions are marked `async`,
and `async` functions always return a `Future`.
If the function returns a `String` and is marked `async`,
it returns a `Future<String>` instead.
If it returns nothing, but it is `async`,
it returns `Future<void>`.

The following example shows how to write an `async` function:

```js
// Returns a Promise of a string,
// as the method is async
async fetchString() {
  // Typically some other async
  // operations would be done here.
  return "String Value";
}
```


```dart
// Returns a future of a string,
// as the method is async
Future<String> fetchString() async {
  // Typically some other async
  // operations would be done here.
  return 'String Value';
}
```

Call this `async` function as follows:

```dart
Future<String> stringFuture = fetchString();
stringFuture.then((String str) {
  print(str); // 'String Value'
});
```

Obtain a future's value using the `await` keyword.
As in JavaScript, this removes the need to call `then`
on the `Future` to obtain its value,
and it allows you to write asynchronous code in a
more synchronous-like way.
As in JavaScript, awaiting futures is only possible
within an `async` context (such as another `async` function).

The following example shows how to await a future for its value:

```dart
// We can only await futures within an async context.
Future<void> asyncFunction() async {
  var str = await fetchString();
  print(str); // 'String Value'
}
```

To learn more about `Future`s and the
`async`/`await` syntax, see the
[Asynchronous programming][] codelab.

[Asynchronous programming]: /codelabs/async-await

### Streams

Another tool in Dart's async toolbox is `Stream`s.
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
and provide a callback method. Whenever the stream emits a value,
Dart calls this method:

```dart
Stream<int> stream = ...
stream.listen((int value) {
  print('A value has been emitted: $value');
});
```

The `listen` method includes optional callbacks
for handling errors or for when the stream completes:

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
containing the `await` keyword.
You can handle this error with a `try-catch` statement:

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
To learn more, see the [`Stream`][] API page.

[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

##### StreamController

The utility class [`StreamController`][] can create and control streams.
Its stream property exposes the stream it controls.
Its methods provides ways to add events to that stream.

For example, the `add` method can emit new items and the `close` method
completes the stream.

The following example shows basic usage of a stream controller:

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

Async generator functions can create streams.
These functions resemble a synchronous generator function
but use the `async*` keyword and return a `Stream`.

In an async generator function, the `yield` keyword
emits the given value to the stream. The `yield*` keyword,
however, works with streams instead of other iterables.
This allows events from other streams to be emitted to this stream.
In the following example,
the function continues once the newly yielded stream has completed.

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  var k = 0;
  while (k < n) yield k++;
}

Stream<int> stream = asynchronousNaturalsTo(5);

// Prints each of 0 1 2 3 4 in succession.
stream.forEach(print(value));
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

### "this" context

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

```dart
class Point {
  final double x;
  final double y;

  Point(double x, double y) : this.x = x, this.y = y { }
}

// Create a new instance of the Point class
Point p = Point(3, 5);
```

#### Initializer lists

Use initializer lists to write your constructor.
Insert the initializer list between the constructor's parameters
and body.

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

#### Constructor parameters

Writing code to assign class fields in the constructor
can feel like creating boilerplate code,
so Dart has some syntactic sugar, called
[initializing parameters][] to make this easier:

```dart
class Point {
  double x;
  double y;

  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  Point(this.x, this.y);
}

// Create a new instance of the Point class
Point p = Point(3, 5);
```

[initializing parameters]: /language/constructors

Similar to functions, constructors have the
option to take positioned or named parameters:

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

#### Named constructors

Unlike JavaScript, Dart allows classes to have
multiple constructors, by allowing you to name them.
You can optionally have one single unnamed constructor,
any additional constructors must be named:

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

To enable immutable class instances, use a `const` constructor.
A class with a `const` constructor can have `final` instance variables only.

```dart
class ImmutablePoint {
  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

#### Constructor redirection

You can call constructors from other constructors to prevent code
duplication or to add additional defaults for parameters:

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

```dart
class Logger {
  static final Map<String, Logger> _cache =
      <String, Logger>{};
 
  final String name;
 
  // Factory constructor that returns a cached copy,
  // or creates a new one if it is not yet available.
  factory Logger(String name) {
    return _cache.putIfAbsent(
        name, () => _cache[name] ??= Logger._internal(name);
  }

  // Private constructor for internal use only
  Logger._internal(this.name);
}
```

### Methods

In both Dart and JavaScript, methods serve as functions that provide
behavior for an object.

```js
function doSomething() { // This is a function
  // Implementation..
}

class Example {
  doSomething() { // This is a method
    // Implementation..
  }
}
```

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



### Extending classes

Dart allows classes to extend another class,
in the same way that JavaScript does.

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

Like JavaScript, Dart doesn't have a
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

```dart
class Cat implements Consumer {
  @override
  consume() {
    print('Eating mice...');
    super.consume(); 
    // Invalid. The superclass `Object` has no `consume` method.
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
A class can use multiple mixins. This helps when multiple classes share the
same functionality,
without needing to inherit from each other or share a common ancestor.

Use the `with` keyword to add one or more comma-separated mixins to a class.

JavaScript has no keyword equivalent. JavaScript can use `Object.assign`
to merge additional objects into an existing object, after instantiating.

The following examples show how JavaScript and Dart achieve similar behavior:

```js
class Animal {}

// Defining the mixins
class Flyer {
  fly = () => console.log('Flaps wings');
}
class Walker {
  walk = () => console.log('Walks on legs');
}
 
class Bat extends Animal {}
class Goose extends Animal {}
class Dog extends Animal {}

// Composing the class instances with
// their correct functionality.
const bat =
  Object.assign(
    new Bat(),
    new Flyer()
    );
const goose =
  Object.assign(
    new Goose(),
    new Flyer(),
    new Walker()
    );
const dog =
  Object.assign(
    new Dog(),
    new Walker()
    );

// Correct calls
bat.fly();
goose.fly();
goose.walk();
dog.walk();
// Incorrect calls
bat.walk(); // `bat` lacks the `walk` method
dog.fly(); // `dog` lacks the `fly` method
```


```dart
abstract class Animal {}

// Defining the mixins
class Flyer {
  fly() => print('Flaps wings');
}
class Walker {
  walk() => print('Walks on legs');
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

Alternatively, you can replace the `class` keyword
with `mixin` to prevent the mixin from being used
as a regular class:

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

```dart
import 'string_apis.dart'; // Import the file the extension is in
var age = '42'.parseInt(); // Use the extension method.
```

### Getters and setters

Getters and setters in Dart work exactly like
their JavaScript counterparts:

```js
class Person {
  _age = 0;

  get age() {
    return this._age;
  }

  set age(value) {
    if (value < 0) {
      throw new Error(
        'age cannot be negative'
        );
    }
    this._age = value;
  }
}

var person = new Person();
person.age = 10;
console.log(person.age);
```


```dart
class Person {
  int _age = 0;
 
  int get age {
    return _age;
  }
 
  set age(int value) {
    if (value < 0) {
      throw ArgumentError(
        'Age cannot be negative'
        );
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

JavaScript will include private class members in the next
practical revision of the EcmaScript standard.
As such, implementations for this have been available in
various browsers and runtimes for some time.

To make a class member private in JavaScript,
prefix its name with a pound (or hash) symbol (`#`).

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

To make a class member private in Dart, prefix its name
with an underscore (`_`).

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

JavaScript uses the hash as a convention.
Dart's compiler enforces use of the underscore for this feature.

Dart makes private members private to the library, not the class.
This means that you can access private members from code in the same library.
By default, Dart limits access to private class members to code in the same file.
To expand the scope of a library beyond one file, add the `part` directive.
When possible, [avoid using `part`][]. Reserve using `part` for code generators.

[avoid using `part`]: /guides/libraries/create-packages#organizing-a-package

### Late variables

To indicate that Dart initializes class fields at a later point,
assign the `late` keyword to those class fields.
Those class fields remain non-nullable.
Do this when a variable doesn't need to observed or accessed immediately
and can be initialized later.
This differs from labeling the field as nullable.

* (Non-nullable) late fields cannot have null assigned at a later point.

* (Non-nullable) late fields throw a runtime error when
  accessed before they initialize. This should be avoided.

```dart
class PetOwner {
  final String name;
  late final Pet _pet;
  PetOwner(this.name, String petName) {
    // Cyclic object graph, cannot set _pet before owner exists.
    _pet = Pet(petName, this);
  }
  Pet get pet => _pet;
}
class Pet {
  final String name;
  final PetOwner owner;
  Pet(this.name, this.owner);
}
```

Use `late` for local variables only if unclear code results
in the compiler being unable determine if the code initialized the variable.

```dart
doSomething(int n, bool capture) {
  late List<Foo> captures;
  if (capture) captures = [];
  for (var i = 0; i < n; i++) {
    var foo = something(i);
    if (capture) captures.add(foo);
  }
}
```

In the preceding example, the compiler does not know to assign
`captures` if `capture` is true. Using `late` delays the normal
"assigned" checks until runtime.

## Generics

While JavaScript doesn't offer generics,
Dart does to improve type safety and reduce code duplication.

### Generic methods

You can apply generics to methods.
To define a generic type parameter, place it between angle brackets `< >`
after the method name.
You can then use this type within the method
as the return type or within the method's parameters:

```dart
Map<Object?, Object?> _cache = {};
T cache<T>(T value) => (_cache[value] ??= value) as T;
```

Define multiple generic types by separating them with a comma:

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
You can include the type to use when calling a constructor.
This allows you to tailor reusable classes to specific types.

In the following example, the `Cache` class caches specific types:

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

If you omit the type declaration,
the runtime type becomes `Cache<dynamic>`
and both calls to `setByKey` are valid.

### Restricting generics

You can use generics to restrict your code to
a family of types using `extends`. This ensures
that your class is instantiated with a generic type
that extends a specific type:

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

`Map`, `Set`, and `List` literals can accept type arguments.
This helps when Dart cannot infer the type or infer the type correctly.

For example, the `List` class has a generic definition:
`class List<E>`. The type parameter `E` refers to the type of
the list's contents. Normally, this type is automatically inferred,
which is used in some `List` class's member types.
(For example, its first getter returns a value of type `E`.)
When defining a `List` literal,
you can explicitly define the generic type as follows:

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

```dart
/// The number of characters in this chunk when unsplit.
int get length => ...
```

[`dart doc`]: /tools/dart-doc
[doc comments]: /effective-dart/documentation#doc-comments

## Next steps

This guide has introduced you to the major differences
between Dart and JavaScript. At this point,
consider reading the Dart documentation.
You could also read the [Flutter]({{site.flutter}}) docs.
Built with Dart, Flutter is an open-source framework that
uses Dart for building natively compiled,
multi-platform applications from a single codebase.
These docs provide in-depth information about the
language and practical ways of getting started.

Some possible next steps:

* [Language tour][] to learn more about the Dart language
* [Library tour][] to learn about Dart's core libraries
* [Dart codelabs][] for hands-on experience learning a variety of topics
* [Effective Dart][] to learn about common conventions
  and guidelines when writing Dart code

[Language tour]:  /language
[Library tour]:   /guides/libraries/library-tour
[Dart codelabs]:  /codelabs
[Effective Dart]: /effective-dart
