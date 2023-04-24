---
title: Branches 
description: Learn how to use branches to control the flow of your Dart code.
---

You can control the flow of your Dart code using branches:

-   `if`, `case`, and `else`
-   `switch` and `case` statements
-   `switch` and `case` expressions

Other methods of manipulating control flow in Dart are:

-   [`for` loops][]
-   [`while` and `do while` loops][]
-   [`break` and `continue`][break]
-   [`assert`][]

You can also affect control flow using [Exceptions][], like `try-catch` and `throw`.

## If else

Dart supports `if` statements with optional `else` statements:

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

The statement conditions must be expressions
that evaluate to [boolean values][boolean], nothing else.
To learn how to use `if` in an expression context, see [Conditional expressions][]

## If case

Dart `if` statements support `case` clauses followed by a [case pattern][pattern]: 

```dart
if (pair case [int x, int y]) return Point(x, y);
```

If the case pattern (the list pattern `[int x, int y]` in the example above)
matches the case expression (`pair`), then the branch (`return Point(x, y)`)
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
_single_ pattern. To test a value against _multiple_ patterns, use [switch](#switch-case).

## Switch case

Switch cases (both [statements](#switch-statements) and [expressions](#switch-expressions))
in Dart compare an object against one or more [case patterns][pattern]. 

Case patterns allow control flow to
either match and destructure the object being switched, or continue execution
if the object doesn't match. They can be any kind of [refutable pattern][]:

- **Constant patterns**: the object's value has to be equivalent to match.
  ```dart
  switch (number) {
    case 1:           // Matches if number == 1
      print("one");     
  }
  ```
- **List**, **map**, or **record patterns**: the elements are destructured if matched.
  ```dart
  switch (obj) {
    case [a, b]:                  // Matches if obj is a list with two elements
      print("$a and $b match");    
  }
  ```  
- **Variable patterns**: the matched value binds to a new variable.
  ```dart
  switch ((1, 2)) {
    case (var a, var b): ...     // Matches if 1 and 2 can be assigned to a and b
  }
  ```  
- **Logical** or **relational patterns**: the object matches if the comparison to a constant returns `true`.
  ```dart
  switch (code) {
    case >= first && <= last: ...    
    // Matches if code's value is between the constant values of first and last
  }
  ```  
- **Null check** or **assert patterns**: the match is first on whether the object is not null, then on the value.
  ```dart
  switch (maybeString) {
    case var s?:                 
    // Matches if maybe is not null, and then against the inner pattern "var s"
  }
  ```  
- **Object patterns**: the match exposes getters on the object type.
  ```dart
  switch (Shape shape) {
    case Rect(width: var w, height: var h): ...
    // Matches if shape is of type Rect, and then against the properties of Rect
  }
  ```  

Values destructured by a case pattern become local variables, only available in the
scope of that clause. 

### Switch statements

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

Empty cases fall through to the next case. For an empty case that does not fall
through, use [`break`][break] for its body:

```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED': // Empty case falls through.
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
}
```

For non-sequential fall-through, you can use a [`continue` statement][break] and
a label:

```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED':
    executeClosed();
    continue nowClosed;
  // Continues executing at the nowClosed label.

  nowClosed:
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
}
```

### Switch expressions

_Switch expressions_ write a result value determined by a switch
directly into a variable or return statement. 

The syntax rules for a switch expression are:
- The expression body is a series of case patterns.
- Cases _do not_ use the `case` keyword.
- Case patterns are followed by `=>`, and then a case body. 
- Case bodies terminate with a comma `,`.
- The switch expression body terminates with a semicolon `;`.
- The wildcard pattern `_` catches remaining values instead of `default`.

This allows you to rewrite a 
_statement_ like this:

```dart
switch (charCode) {
  case slash when nextCharCode == slash:   // Constant pattern with guard
    skipComment();
  case slash || star || plus || minus:     // Logical-or pattern
    operator(charCode);
  case >= digit0 && <= digit9:             // Relational and logical-and patterns
    number();
  default:
    invalid();
}
```

Into an _expression_, like this:

```dart
var token = switch (charCode) {
  slash when nextCharCode == slash => skipComment(),
  slash || star || plus || minus   => operator(charCode),
  >= digit0 && <= digit9           => number(),
  _                                => throw invalid()
};
```

### Exhaustiveness checking

Exhaustiveness checking is a feature of switches that raises a compile-time error
if a switch is not exhaustively covering all possible values that could flow through it.

The compiler can only know if a set of cases is
exhaustive if it is soundly aware of all possible enumerations of that type. So,
exhaustiveness checking works only when switching on types that are fully enumerable:

- [Boolean][boolean] types, because there are only two possible values, `true` and `false`.
- [Enum][enum] types, because they are always a fixed number of constant values.
- [Sealed][sealed] types, because they are classes with a closed hierarcy of subtypes in the same library.

```dart
bool? b = false;
// Non-exhaustive switch on bool?, missing case to match null possiblity:
switch (b) {
  case true: print('yes');
  case false: print('no');
}
```

Use the [`sealed` modifier][sealed] on a class to enable exhaustiveness checking when 
switching over subtypes of that class:

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
checking will warn you about the missing subtype, because your switch is incomplete.
This allows you to use Dart in a somewhat 
[functional algrbraic datatype style](https://en.wikipedia.org/wiki/Algebraic_data_type). 

## When

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

[`for` loops]: /language/loops#for-loops
[`while` and `do while` loops]: /language/loops#while-and-do-while
[break]: /language/loops#break-and-continue
[`assert`]: /language/assert
[Exceptions]: /language/error-handling
[conditional expressions]: /language/operators#conditional-expressions
[boolean]: /language/built-in-types#booleans
[pattern]: /
[enum]: /language/enum
[`throw`]: /language/error-handling#throw
[`return`]: /language/functions#return-values
[sealed]: /
[refutable pattern]: /resources/glossary#refutable-pattern
