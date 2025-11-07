---
title: Dot shorthands
description: Learn about the dot shorthand syntax in Dart.
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/extension-methods
  title: Extension methods
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

:::version-note
Dot shorthands require a [language version][] of at least 3.10.
:::

[language version]: /resources/language/evolution#language-versioning

## Overview

Dot shorthand syntax `.foo` lets you write more concise Dart 
code by omitting the type when the compiler can infer it 
from context. This provides a clean alternative to writing 
the full `ContextType.foo` when accessing enum values, 
static members, or constructors.

In essence, dot shorthands allow an expression 
to start with one of the following and then optionally chain 
other operations onto it:

* Identifier `.myValue`

* Constructor `.new()`

* Constant creation `const .myValue()`

Here's a quick look at how it simplifies an enum assignment:

<?code-excerpt "language/lib/shorthands/intro.dart"?>
```dart
// Use dot shorthand syntax on enums:
enum Status { none, running, stopped, paused }

Status currentStatus = .running; // Instead of Status.running

// Use dot shorthand syntax on a static method:
int port = .parse('8080'); // Instead of int.parse('8080')

// Uses dot shorthand syntax on a constructor:
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

Point origin = .origin(); // Instead of Point.origin()
```

## The role of context type 

Dot shorthands use the [context type][] to determine the member 
the complier resolves to. The context type is the type that Dart 
expects an expression to have based on its location. 
For example, in `Status currentStatus = .running`, 
the compiler knows a `Status` is expected, so it infers 
`.running` to mean `Status.running`.

[context type]: /resources/glossary#context-type

## Lexical structure and syntax

A _static member shorthand_ is an expression that
begins with a leading dot (`.`).
When the type is known from the surrounding context,
this syntax provides a concise way to access
static members, constructors, and enum values.

### Enums

A primary and highly recommended use case for dot shorthands 
is with enums, especially in assignments and switch statements, 
where the enum type is very obvious.

<?code-excerpt "language/lib/shorthands/enums.dart"?>
```dart
enum LogLevel { debug, info, warning, error }

/// Returns the color code to use for the specified log [level].
String colorCode(LogLevel level) {
  // Use dot shorthand syntax for enum values in switch cases:
  return switch (level) {
    .debug => 'gray', // Instead of LogLevel.debug
    .info => 'blue', // Instead of LogLevel.info
    .warning => 'orange', // Instead of LogLevel.warning
    .error => 'red', // Instead of LogLevel.error
  };
}

// Example usage:
String warnColor = colorCode(.warning); // Returns 'orange'
```

### Named constructors

Dot shorthands are useful for invoking named constructors 
or factory constructors. This syntax also works when providing 
type arguments to a generic class's constructor.

<?code-excerpt "language/lib/shorthands/constructors.dart"?>
```dart
class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor

  // Factory constructor
  factory Point.fromList(List<double> list) {
    return Point(list[0], list[1]);
  }
}

// Use dot shorthand syntax on a named constructor:
Point origin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax on a factory constructor:
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// Use dot shorthand syntax on a generic class constructor:
List<int> intList = .filled(5, 0); // Instead of List.filled(5, 0)
``` 

### Unnamed constructors

The `.new` dot shorthand provides a concise way to call an
unnamed constructor of a class. This is useful 
for assigning fields or variables where the type is 
already explicitly declared.

This syntax is particularly effective for cleaning up 
repetitive class field initializers.
As shown in the following "after" example using dot shorthands,
it can be used for constructors both with and without arguments.
tt also infers any generic type arguments 
from the context. 

**Without dot shorthands:**

<?code-excerpt "language/lib/shorthands/unnamed_constructors.dart (unnamed-before)"?>
```dart
class _PageState extends State<Page> {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties = <String, Map<String, bool>>{};
  // ...
}
```

**Using dot shorthands:**

<?code-excerpt "language/lib/shorthands/unnamed_constructors.dart (unnamed-after)" replace="/_PageStateAfter/_PageState/g;"?>
```dart
// Use dot shorthand syntax for calling unnamed constructors:
class _PageState extends State<Page> {
  late final AnimationController _animationController = .new(vsync: this);
  final ScrollController _scrollController = .new();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = .new();
  Map<String, Map<String, bool>> properties = .new();
  // ...
}
```

### Static members

You can use dot shorthand syntax to call static methods or 
access static fields/getters. The compiler infers the 
target class from the context type of the expression.

<?code-excerpt "language/lib/shorthands/static_members.dart"?>
```dart
// Use dot shorthand syntax to invoke a static method:
int httpPort = .parse('80'); // Instead of int.parse('80')

// Use dot shorthand syntax to access a static field or getter:
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Constant expressions 

You can use dot shorthands within a constant context
if the member being accessed is a compile-time constant. 
This is common for enum values and invoking `const` constructors.

<?code-excerpt "language/lib/shorthands/consts.dart"?>
```dart
enum Status { none, running, stopped, paused }

class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Use dot shorthand syntax for enum value:
const Status defaultStatus = .running; // Instead of Status.running

// Use dot shorthand syntax to invoke a const named constructor:
const Point myOrigin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax in a const collection literal:
const List<Point> keyPoints = [.origin(), .new(1.0, 1.0)];
// Instead of [Point.origin(), Point(1.0, 1.0)]
```

## Rules and limitations

Dot shorthands rely on a clear context type, which leads to 
a few specific rules and limitations you should know about.

### Clear context type required in chains

While you can chain operations like method calls or 
property accesses onto a dot shorthand, the entire expression 
is validated against the context type.

The compiler first uses the context to determine what the 
dot shorthand resolves to. Any subsequent operations in the 
chain must return a value that matches that same initial 
context type.

<?code-excerpt "language/lib/shorthands/chain.dart (chain)"?>
```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase();
// Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
```

### Asymmetric equality checks

The `==` and `!=` operators have a special rule for dot shorthands. 
When dot shorthand syntax is used directly on the right-hand side
of an equality check, Dart uses the static type of the 
left-hand side to determine the class or enum for the shorthand.

For instance, in an expression like `myColor == .green`, 
the type of the variable `myColor` is used as the context. 
This means the compiler interprets `.green` as `Color.green`.

<?code-excerpt "language/lib/shorthands/equality.dart"?>
```dart
enum Color { red, green, blue }

// Use dot shorthand syntax for equality expressions:
void allowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // OK: `myColor` is a `Color`, so `.green` is inferred as `Color.green`.
  if (myColor == .green) {
    print('The color is green.');
  }

  // OK: Works with `!=` as well.
  if (myColor != .blue) {
    print('The color is not blue.');
  }

  // OK: The context for the ternary is the variable `inferredColor`
  // being assigned to, which has a type of `Color`.
  Color inferredColor = condition ? .green : .blue;
  print('Inferred color is $inferredColor');
}
```

The dot shorthand must be on the right-hand side of the `==` 
or `!=` operator. Comparing against a more complex expression, 
like a conditional expression, is also not allowed.

<?code-excerpt "language/lib/shorthands/equality_with_errors.dart"?>
```dart tag=fails-sa
enum Color { red, green, blue }

void notAllowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // ERROR: The shorthand must be on the right side of `==`.
  // Dart's `==` operator is not symmetric for this feature.
  if (.red == myColor) {
    print('This will not compile.');
  }

  // ERROR: The right-hand side is a complex expression (a conditional expression),
  // which is not a valid target for shorthand in a comparison.
  if (myColor == (condition ? .green : .blue)) {
    print('This will not compile.');
  }

  // ERROR: The type context is lost by casting `myColor` to `Object`.
  // The compiler no longer knows that `.green` should refer to `Color.green`.
  if ((myColor as Object) == .green) {
    print('This will not compile.');
  }
}
```

### Expression statements can't start with `.`

To avoid potential parsing ambiguities in the future, an
expression statement is not allowed to begin with a
`.` token.

<?code-excerpt "language/lib/shorthands/expression_with_errors.dart"?>
```dart tag=fails-sa
class Logger {
  static void log(String message) {
    print(message);
  }
}

void main() {
  // ERROR: An expression statement can't begin with `.`.
  // The compiler has no type context (like a variable assignment)
  // to infer that `.log` should refer to `Logger.log`.
  .log('Hello');
}
```

### Limited handling of union types

While there is special handling for nullable types (`T?`) and
`FutureOr<T>`, support is limited.

*  For a nullable type (T?), you can access static members
   of `T`, but not of `Null`.

*  For `FutureOr<T>`, you can access static members of `T`
  (primarily to support `async` function returns), but you
  can't access static members of the `Future` class itself.
