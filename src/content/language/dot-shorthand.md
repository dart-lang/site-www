---
title: Dot shorthand syntax
description: Learn about the shorthand syntax in Dart.
shortTitle: Dot Shorthands
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/extension-methods
  title: Extension methods
---

:::experimental
Support for dot shorthand syntax is experimental and
can only be used on the `main` channel.
:::

Write more concise Dart code by using the dot shorthand syntax `.foo` 
instead of `ContextType.foo`. The compiler can infer the type 
whenever it's clear from the context, letting you access 
enum values, static members, or constructors more cleanly.

Here is a quick look:

<?code-excerpt "language/lib/classes/shorthand.dart (intro)"?>
```dart
// Enum example
enum Status { none, running, stopped, paused }
Status currentStatus = .running; // Instead of Status.running

// Static method example
int port = .parse('8080'); // Instead of int.parse('8080')

// Constructor example
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}
Point origin = .origin(); // Instead of Point.origin()
```

## The role of context type 
Dot shorthand syntax works because the compiler understands 
the context type. This is the type it expects an expression 
to have based on its location. For example, 
in `Status currentStatus = .running`, the compiler knows 
a `Status` is expected, so it infers `.running` to mean 
`Status.running`.

## Using dot shorthand syntax

### Enums
A primary and highly recommended use case for dot shorthands 
is with enums, especially in assignments and switch statements, 
where the enum type is very obvious.

<?code-excerpt "language/lib/classes/shorthand.dart (enums)"?>
```dart
// Enum example
enum LogLevel { debug, info, warning, error }

// Function to get a color code based on log level
String colorCode(LogLevel level) {
  return switch (level) {
    .debug   => 'gray',    // Instead of LogLevel.debug
    .info    => 'blue',    // Instead of LogLevel.info
    .warning => 'orange',  // Instead of LogLevel.warning
    .error   => 'red',     // Instead of LogLevel.error
  };
}

// Example usage:
var warnColor = colorCode(.warning); // Returns 'orange'
```

### Named constructors
Dot shorthands are useful for invoking named constructors, 
static factory methods, or constructors of generic classes 
where type arguments are provided.

<?code-excerpt "language/lib/classes/shorthand.dart (constructors)"?>
```dart
 class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor
  static Point fromList(List<double> list) => Point(list[0], list[1]); // Static method
}

// Named constructor
Point origin = .origin(); // Instead of Point.origin()

// Static factory method
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// With type arguments for generic class constructors
List<int> intList = .filled(5, 0); // Instead of List.filled(5, 0)
``` 
### Unnamed constructors
The `.new` dot shorthand provides a concise way to call an
unnamed constructor of a class. This is useful 
for instantiating fields and variables where the type is 
already explicitly declared.

<?code-excerpt "language/lib/classes/shorthand.dart (unnamed)"?>
```dart
class _PageState extends State<Page> {
  // Before
  final AnimationController _animationController = AnimationController(vsync: this);
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties
    = <String, Map<String, bool>>{};

  // After
  final AnimationController _animationController = .new(vsync: this);
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

<?code-excerpt "language/lib/classes/shorthand.dart (methods)"?>
```dart
// Static method
int httpPort = .parse('80'); // Instead of int.parse('80')

// Static field/getter
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Constant expressions 
You can use dot shorthands within `const` contexts 
if the member being accessed is a compile-time constant. 
This is common for enum values and invoking `const` constructors.

<?code-excerpt "language/lib/classes/shorthand.dart (const)"?>
```dart
enum Status { none, running, stopped, paused }
class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Enum values are always constants
const Status defaultStatus = .running; // Instead of const Status.running

// Invoking a const named constructor
const Point myOrigin = .origin(); // Instead of const Point.origin()

// Using shorthands in a const collection literal
const List<Point> keyPoints = [ .origin(), .new(1.0, 1.0) ]; 
// Instead of [const Point.origin(), const Point(1.0, 1.0)]
```


## Advanced usage

### Chaining
While you can chain operations like method calls or 
property accesses onto a dot shorthand, the entire expression 
is validated against the context type.

The compiler first uses the context to determine what the 
dot shorthand resolves to. Any subsequent operations in the 
chain must return a value that matches that same initial 
context type.


<?code-excerpt "language/lib/classes/shorthand.dart (chain)"?>
```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase(); // Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
```

### Equality operators (`==` and `!=`)
The `==` and `!=` operators have a special rule for dot shorthands. 
When dot shorthand syntax is used directly on the right-hand side (RHS) 
of an equality check, Dart uses the static type of the 
left-hand side to determine the class or enum for the shorthand.

For instance, in an expression like `myColor == .green`, 
the type of the variable `myColor` is used as the context. 
This means the compiler interprets `.green` as `Color.green`.

<?code-excerpt "language/lib/classes/shorthand.dart (allowedequality)"?>
```dart
enum Color { red, green, blue }

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
like a ternary, is also not allowed.

<?code-excerpt "language/lib/classes/shorthand.dart (notallowedequality)"?>
```dart
enum Color { red, green, blue }

void notAllowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // ERROR: The shorthand must be on the right side of `==`.
  // Dart's `==` operator is not symmetric for this feature.
  if (.red == myColor) {
    print('This will not compile.');
  }

  // ERROR: The right-hand side is a complex expression (a ternary),
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

## Best practices 
The general recommendation is to use dot shorthands wherever 
possible, as long as the type being inferred is obvious 
from the immediate context.

<?code-excerpt "language/lib/classes/shorthand.dart (best)"?>
```dart
// GOOD: Use dot shorthands in typed collections.
final alignments = <MainAxisAlignment>[.center, .bottomLeft];

List<Person>[
  .new(name: 'Joe', age: 145),
  .new(name: 'Alice', age: 495),
];

// GOOD: Use dot shorthands for implicit return values.
class Foo {
  MainAxisAlignment pickAlignment() => .start;
  EdgeInsets get padding => .all(8.0);
}
```
Readability is always more important than brevity. 
Avoid shorthands in situations where the type is not 
immediately obvious to the reader.

Specifically, avoid shorthands:
* In return statements where the method's return type isn't 
immediately visible, like in a long method.
* When assigning to a variable whose type is not explicit or easily inferred.
* When the type is obscure or ambiguous.
* In complex or deeply nested function calls.
* When using `.new()` with a lot of nesting or without obvious types.

<?code-excerpt "language/lib/classes/shorthand.dart (avoid)"?>
```dart
Size calculateSize() {
  // AVOID: Return statement type is not obvious from the return statement alone.
  return .fromHeight(10);
}

Size calculateSize() {
  // GOOD: Return statement type is obvious.
  return Size.fromHeight(10);
}


// AVOID: The type of _character isn't obvious in this context.
setState(() {
  _character = .jefferson;
});

// AVOID: Prefer using explicit types for arrow syntax.
ScrollController buildController() => .new();


GlobalKey<ScaffoldMessengerState> buildKey() {
// AVOID: Don't use .new() as a shorthand in return statements.
  return .new();

  // GOOD
  return GlobalKey<ScaffoldMessengerState>();
}

// AVOID: Don't use .new() for class field declarations
class Foo {
  // BAD: Omit obvious types instead of using .new.
  final ScrollController _controller = .new();

  // GOOD
  final _controller = ScrollController();
}
```
