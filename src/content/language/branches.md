---
title: Branches 
description: Learn how to use branches to control the flow of your Dart code.
prevpage:
  url: /language/loops
  title: Loops
nextpage:
  url: /language/error-handling
  title: Error handling
---

This page shows how you can control the flow of your Dart code using branches:

- `if` statements and elements
- `if-case` statements and elements
- `switch` statements and expressions

You can also manipulate control flow in Dart using:

- [Loops][], like `for` and `while`
- [Exceptions][], like `try`, `catch`, and `throw`

## If

Dart supports `if` statements with optional `else` clauses.
The condition in parentheses after `if` must be
an expression that evaluates to a [boolean][]:

<?code-excerpt "language/lib/control_flow/branches.dart (if-else)"?>
```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

To learn how to use `if` in an expression context, 
check out [Conditional expressions][].

### If-case

Dart `if` statements support `case` clauses followed by a [pattern][]: 

<?code-excerpt "language/lib/control_flow/branches.dart (if-case)"?>
```dart
if (pair case [int x, int y]) return Point(x, y);
```

If the pattern matches the value,
then the branch executes with any variables the pattern defines in scope.

In the previous example,
the list pattern `[int x, int y]` matches the value `pair`,
so the branch `return Point(x, y)` executes with the variables that
the pattern defined, `x` and `y`.

Otherwise, control flow progresses to the `else` branch
to execute, if there is one:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case-else)"?>
```dart 
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

The if-case statement provides a way to match and
[destructure][] against a _single_ pattern. 
To test a value against _multiple_ patterns, use [switch](#switch).

:::version-note
Case clauses in if statements require
a [language version][] of at least 3.0.
:::

<a id="switch"></a>
## Switch statements

A `switch` statement evaluates a value expression against a series of cases.
Each `case` clause is a [pattern][] for the value to match against.
You can use [any kind of pattern][] for a case.

When the value matches a case's pattern, the case body executes. 
Non-empty `case` clauses jump to the end of the switch after completion.
They do not require a `break` statement.
Other valid ways to end a non-empty `case` clause are a
[`continue`][break], [`throw`][], or [`return`][] statement.

Use a `default` or [wildcard `_`][] clause to
execute code when no `case` clause matches:

<?code-excerpt "language/lib/control_flow/branches.dart (switch)"?>
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

<a id="switch-share"></a>

Empty cases fall through to the next case, allowing cases to share a body. 
For an empty case that does not fall through,
use [`break`][break] for its body.
For non-sequential fall-through,
you can use a [`continue` statement][break] and a label:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-empty)"?>
```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase; // Continues executing at the newCase label.

  case 'DENIED': // Empty case falls through.
  case 'CLOSED':
    executeClosed(); // Runs for both DENIED and CLOSED,

  newCase:
  case 'PENDING':
    executeNowClosed(); // Runs for both OPEN and PENDING.
}
```

### Labels in Dart

In Dart, labels are used to control nested loops(Loop inside Loop) using break and continue. Labels allow you to specify which loop to `break` or `continue`, rather than affecting the innermost loop by default.

Here is the syntax for labels in Dart : 

```dart

labelName:
for (/* condition */) {
  // code
}

```

A label is simply an identifier followed by a colon (`:`) placed before a loop or statement.

#### Labels in for loop using `break` :

The below code demonstrates the usage of a labels in `for` loop with `break` : 

```dart
void main() {
  outerLoop:
  for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
      print("i = $i, j = $j");
      if (i == 2 && j == 2) {
        break outerLoop;
      }
    }
  }
  print("outerLoop exited");
}

```

In the above example, When `i == 2` and `j == 2`, `break outerLoop;` statement stops both inner and outer loops. So, the expected output would be :

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited

```

#### Labels in for loop using `contiue` :

The below code demonstrates the usage of labels in `for` loop with `continue` :

```dart

void main() {
  outerLoop:
  for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
      if (i == 2 && j == 2) {
        continue outerLoop;
      }
      print("i = $i, j = $j");
    }
  }
}

```
In the above example, When `i == 2` and `j == 2`, `continue outerLoop;` skips the rest of the iterations for `i = 2` and moves to `i = 3`. So, the output would be :

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3

```

#### Labels in while loop using `break` :

The below code demonstrates the usage of a labels in `while` loop with `break` :

```dart

void main() {
  int i = 1;
  outerLoop:
  while (i <= 3) {
    int j = 1;
    while (j <= 3) {
      print("i = $i, j = $j");
      if (i == 2 && j == 2) {
        break outerLoop; 
      }
      j++;
    }
    i++;
  }
  print("outerLoop exited");
}

```

In the above example, the program breaks out of both inner and outer while loops when `i == 2` and `j == 2`.So, the expected output would be :

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited

```

#### Labels in while loop using `continue`:

The below code demonstrates the usage of labels in `while` loop using `continue`:

```dart

void main() {
  int i = 1;
  
  outerLoop:
  while (i <= 3) {
    int j = 1;
    while (j <= 3) {
      if (i == 2 && j == 2) {
        i++; 
        continue outerLoop;
      }
      print("i = $i, j = $j");
      j++;
    }
    i++;
  }
}

```
In the above example, the iteration for i = 2, j = 2 is skipped, and the loop moves directly to i = 3. As a result, the output would be:

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
  
```

#### Label in do while loop using `break` :

The below code demonstrate the usage of label in `do while` loop :
```dart

void main() {
  int i = 1;
  outerLoop:
  do {
    int j = 1;
    do {
      print("i = $i, j = $j");
      if (i == 2 && j == 2) {
        break outerLoop;
      }
      j++;
    } while (j <= 3);
    i++;
  } while (i <= 3);

  print("outerLoop exited");
}

```
In the above example, the program breaks out of both inner and outer loops when `i == 2` and `j == 2`. So, the expected output would be :

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 2, j = 2
outerLoop exited

```

#### Labels in do while loop using `continue` : 

The below code demonstrates the usage of labels in `do while` loop using `continue`:

```dart
void main() {
  int i = 1;

  outerLoop:
  do {
    int j = 1;
    do {
      if (i == 2 && j == 2) {
        i++; 
        continue outerLoop;
      }
      print("i = $i, j = $j");
      j++;
    } while (j <= 3);
    i++;
  } while (i <= 3);
}

```

In the above example, the loop skips i = 2, j = 2 and moves directly to i = 3. As a result, the output would be:

```dart

i = 1, j = 1
i = 1, j = 2
i = 1, j = 3
i = 2, j = 1
i = 3, j = 1
i = 3, j = 2
i = 3, j = 3
 
```

You can use [logical-or patterns][] to allow cases to share a body or a guard.
To learn more about patterns and case clauses, 
check out the patterns documentation on [Switch statements and expressions][].

[Switch statements and expressions]: /language/patterns#switch-statements-and-expressions

### Switch expressions

A `switch` _expression_ produces a value based on the expression
body of whichever case matches. 
You can use a switch expression wherever Dart allows expressions,
_except_ at the start of an expression statement. For example:

```dart
var x = switch (y) { ... };

print(switch (x) { ... });

return switch (x) { ... };
```

If you want to use a switch at the start of an expression statement,
use a [switch statement](#switch-statements).

Switch expressions allow you to rewrite a switch _statement_ like this:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-stmt)"?>
```dart
// Where slash, star, comma, semicolon, etc., are constant variables...
switch (charCode) {
  case slash || star || plus || minus: // Logical-or pattern
    token = operator(charCode);
  case comma || semicolon: // Logical-or pattern
    token = punctuation(charCode);
  case >= digit0 && <= digit9: // Relational and logical-and patterns
    token = number();
  default:
    throw FormatException('Invalid');
}
```

Into an _expression_, like this:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-exp)"?>
```dart
token = switch (charCode) {
  slash || star || plus || minus => operator(charCode),
  comma || semicolon => punctuation(charCode),
  >= digit0 && <= digit9 => number(),
  _ => throw FormatException('Invalid'),
};
```

The syntax of a `switch` expression differs from `switch` statement syntax:

- Cases _do not_ start with the `case` keyword.
- A case body is a single expression instead of a series of statements.
- Each case must have a body; there is no implicit fallthrough for empty cases.
- Case patterns are separated from their bodies using `=>` instead of `:`.
- Cases are separated by `,` (and an optional trailing `,` is allowed).
- Default cases can _only_ use `_`, instead of allowing both `default` and `_`.

:::version-note
Switch expressions require a [language version][] of at least 3.0.
:::

### Exhaustiveness checking

Exhaustiveness checking is a feature that reports a
compile-time error if it's possible for a value to enter a switch but
not match any of the cases.

<?code-excerpt "language/lib/control_flow/branches.dart (exh-bool)"?>
```dart
// Non-exhaustive switch on bool?, missing case to match null possibility:
switch (nullableBool) {
  case true:
    print('yes');
  case false:
    print('no');
}
```

A default case (`default` or `_`) covers all possible values that
can flow through a switch.
This makes a switch on any type exhaustive.

[Enums][enum] and [sealed types][sealed] are particularly useful for
switches because, even without a default case, 
their possible values are known and fully enumerable. 
Use the [`sealed` modifier][sealed] on a class to enable
exhaustiveness checking when switching over subtypes of that class:

<?code-excerpt "language/lib/patterns/algebraic_datatypes.dart (algebraic-datatypes)"?>
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

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r,
};
```

If anyone were to add a new subclass of `Shape`, 
this `switch` expression would be incomplete. 
Exhaustiveness checking would inform you of the missing subtype.
This allows you to use Dart in a somewhat 
[functional algebraic datatype style](https://en.wikipedia.org/wiki/Algebraic_data_type). 

<a id="when"></a>
## Guard clause

To set an optional guard clause after a `case` clause, use the keyword `when`.
A guard clause can follow `if case`, and
both `switch` statements and expressions.

```dart
// Switch statement:
switch (something) {
  case somePattern when some || boolean || expression:
    //             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
    body;
}

// Switch expression:
var value = switch (something) {
  somePattern when some || boolean || expression => body,
  //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
}

// If-case statement:
if (something case somePattern when some || boolean || expression) {
  //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
  body;
}
```

Guards evaluate an arbitrary boolean expression _after_ matching.
This allows you to add further constraints on
whether a case body should execute.
When the guard clause evaluates to false, 
execution proceeds to the next case rather
than exiting the entire switch.

[language version]: /resources/language/evolution#language-versioning
[loops]: /language/loops
[exceptions]: /language/error-handling
[conditional expressions]: /language/operators#conditional-expressions
[boolean]: /language/built-in-types#booleans
[pattern]: /language/patterns
[enum]: /language/enums
[`throw`]: /language/error-handling#throw
[`return`]: /language/functions#return-values
[wildcard `_`]: /language/pattern-types#wildcard
[break]: /language/loops#break-and-continue
[sealed]: /language/class-modifiers#sealed
[any kind of pattern]: /language/pattern-types
[destructure]: /language/patterns#destructuring
[section on switch]: /language/patterns#switch-statements-and-expressions
[logical-or patterns]: /language/patterns#or-pattern-switch
