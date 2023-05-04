---
title: Branches 
description: Learn how to use branches to control the flow of your Dart code.
---

This page shows how you can control the flow of your Dart code using branches:

- `if` statements and elements
- `if-case` statements and elements
- `switch` statements and expressions

You can also manipulate control flow in Dart using [loops][], like `for`
and `while`, or even using [exceptions][], like `try-catch` and `throw`.

## If

Dart supports `if` statements with optional `else` clauses. The condition in
parentheses after `if` must be an expression that evaluates to a [boolean][]:

<?code-excerpt "misc/lib/language_tour/control_flow.dart (if-else)"?>
```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

To learn how to use `if` in an expression context, see [Conditional expressions][]

### If-case

Dart `if` statements support `case` clauses followed by a [pattern][]: 

```dart
if (pair case [int x, int y]) return Point(x, y);
```

If the pattern (the list pattern `[int x, int y]` in the example above)
matches the value (`pair`), then the branch (`return Point(x, y)`)
executes with any variables the pattern defines in scope (`x` and `y`).

Otherwise, the else branch is executed, if there is one:

```dart 
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

If-case is a simple way to match and destructure against a
_single_ pattern. To test a value against _multiple_ patterns, use [switch](#switch).

## Switch

Switch statements evaluate a value expression against a series of cases.
Each case clause is a [pattern][] to match against the value being switched on,
followed by a series of statements in the case body to execute if the value
matches that pattern. You can use [any kind of pattern][] for a case.

Non-empty `case` clauses implicitly jump to the end of the switch after completion.
Other valid ways to end a non-empty `case` clause are a [`continue`][break],
[`throw`][], or [`return`][] statement.

Use a `default` or wildcard `_` clause to execute code when no `case` clause matches:

```dart
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
  case 'PENDING':
    executePending();
  case 'APPROVED':
    executeApproved();
  case 'DENIED':
    executeDenied();
  case 'OPEN':
    executeOpen();
  default:
    executeUnknown();
}
```

Empty cases fall through to the next case. For non-sequential fall-through,
you can use a [`continue` statement][break] and a label:

```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase;     // Continues executing at the newCase label.
  
  case 'DENIED':          // Empty case falls through.
  case 'CLOSED':
    executeClosed();      // Runs for both DENIED and CLOSED,
  
  newCase:
  case 'PENDING':
    executeNowClosed();   // Runs for both OPEN and PENDING.
}
```
For an empty case that does not fall through, use [`break`][break] for its body.

### Switch expressions

Switch expressions are similar to switch statements, but you can use them anywhere
you can use an expression. They produce a value based on the expression body of
whichever case matches.

Switch expression syntax differs slightly from switch statements:

- Cases _do not_ start with the `case` keyword.
- A case body is a single expression instead of a series of statements.
- Each case must have a body; there is no implicit fallthrough for empty cases.
- Case patterns are separated from their bodies using `=>` instead of `:`.
- Cases are separated by `,` (and an optional trailing `,` is allowed).
- Default cases can _only_ use `_`, instead of allowing both `default` and `_`.

Switch expressions allow you to rewrite a _statement_ like this:

```dart
// Where slash, star, comma, semicolon, etc., are constant variables...

switch (charCode) {
  case slash || star || plus || minus:    // Logical-or pattern
    token = operator(charCode);
  case comma || semicolon:                // Logical-or pattern
    token = punctuation(charCode);
  case >= digit0 && <= digit9:            // Relational and logical-and patterns
    token = number();
  default:
    throw invalid();
}
```

Into an _expression_, like this:

```dart
token = switch (charCode) {
  slash || star || plus || minus => operator(charCode),
  comma || semicolon => punctuation(charCode),
  >= digit0 && <= digit9 => number(),
  _ => throw invalid()
};
```

### Exhaustiveness checking

Exhaustiveness checking is a feature of switches that reports a compile-time
error if it's possible for a value entering the switch to not match any of the cases.

```dart
bool? b = false;
// Non-exhaustive switch on bool?, missing case to match null possiblity:
switch (b) {
  case true: print('yes');
  case false: print('no');
}
```

A default case (`default` or `_`) covers all possible values, making a switch on
any type exhaustive.

[Enums][enum] and [sealed types][sealed] are particularly useful for switches
because, even without a default case, their possible values are known and fully
enumerable. Use the [`sealed` modifier][sealed] on a class to enable
exhaustiveness checking when switching over subtypes of that class:

```dart
sealed class Shape {
  double calculateArea();
}

class Square extends Shape { ... }
class Circle extends Shape { ... }

// ...

double calculateArea(Shape shape) =>
  switch (shape) {
    Square(length: var l) => l * l,
    Circle(radius: var r) => math.pi * r * r
  };
```

If a new subclass of `Shape` is ever added, exhaustiveness 
checking will tell you about the missing subtype, because your switch is incomplete.
This allows you to use Dart in a somewhat 
[functional algebraic datatype style](https://en.wikipedia.org/wiki/Algebraic_data_type). 

## Guard clause

<a id="when"></a>

An optional guard clause can appear after any case clause
(`if case`, and both `switch` statements and expressions)
using the keyword `when`. Guards evaluate an arbitrary boolean expression _after_
matching, allowing you to further constrain whether a case body should execute
despite the case pattern matching the value.

```dart
switch (pair) {
  case (int a, int b) when a > b:
    print('First element greater');
  case (int a, int b):
    print('First element not greater');
}
```

When the guard clause evaluates to false, execution proceeds to the next case
rather than exiting the entire switch.

[loops]: /language/loops
[exceptions]: /language/error-handling
[conditional expressions]: /language/operators#conditional-expressions
[boolean]: /language/built-in-types#booleans
[pattern]: /
[enum]: /language/enum
[`throw`]: /language/error-handling#throw
[`return`]: /language/functions#return-values
[break]: /language/loops#break-and-continue
[sealed]: /
[destructured]: /
[any kind of pattern]: /
