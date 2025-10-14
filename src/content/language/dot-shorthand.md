---
title: Shorthand syntax
description: Learn about the shorthand syntax in Dart.
shortTitle: Shorthand
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/extension-methods
  title: Extension methods
---

:::experimental
Support for shorthand syntax is experimental and
can only be used on the `main` channel.
:::

Write more concise Dart code by using the shorthand syntax `.foo` 
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
## Using shorthand syntax

### Enums
A primary and highly recommended use case for shorthands is with enums, 
especially in assignments and switch statements, where the 
enum type is very clear.

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
// var warnColor = colorCode(.warning); // Returns 'orange'
```

### Constructors
Shorthands are useful for invoking named constructors, 
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
List<int> intList = .filled(5, 0); // Instead of List<int>.filled(5, 0)
``` 

### Static members
You can use shorthand syntax to call static methods or 
access static fields/getters of a class when the class 
type is providing the context.

<?code-excerpt "language/lib/classes/shorthand.dart (methods)"?>
```dart
// Static method
int httpPort = .parse('80'); // Instead of int.parse('80')

// Static field/getter
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Constant expressions 
You can use shorthands within `const` contexts 
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
const List<Point> keyPoints = [ .origin(), .new(1.0, 1.0) ]; // Instead of [const Point.origin(), const Point(1.0, 1.0)]
```


## Advanced usage

### Chaining
Once shorthand syntax resolves to an object or value, 
you can chain further operations onto it, such as instance 
method calls or property accesses, just as if you had 
written out the type name.

<?code-excerpt "language/lib/classes/shorthand.dart (chain)"?>
```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase(); // Instead of String.fromCharCode(72).toLowerCase()

// print(lowerH); // Output: h
```

### Equality operators (`==` and `!=`)
The `==` and `!=` operators have a special rule for shorthands. 
When shorthand syntax is used directly on the right-hand side (RHS) 
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
The shorthand must be on the right-hand side of the `==` or `!=` operator. 
Comparing against a more complex expression, like a ternary, 
is also not allowed.

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

### Constructor tear-offs
You can also use dot shorthand to get a reference to a 
constructor, also known as a "tear-off." Use `.new` for 
an unnamed constructor reference and `.identifier` for a 
named one. The compiler resolves these using the function 
type of the variable they're being assigned to.

<?code-excerpt "language/lib/classes/shorthand.dart (tearoff)"?>
```dart
class Logger {
  final String name;
  Logger(this.name); // Unnamed constructor
  Logger.verbose() : name = 'VERBOSE'; // Named constructor
}

void main() {
  // .new for an UNNAMED constructor tear-off:
  Logger Function(String) createLogger = .new; // Instead of Logger.new

  // .identifier for a NAMED constructor tear-off:
  Logger Function() createVerboseLogger = .verbose; // Instead of Logger.verbose

  // .new for a generic UNNAMED constructor tear-off:
  Set<String> Function() createStringSet = .new; // Instead of Set<String>.new

  // Now use the tear-offs to create instances:
  var appLog = createLogger('App');
  var verboseLog = createVerboseLogger();
  var stringSet = createStringSet();

  print(appLog.name);         // Prints "App"
  print(verboseLog.name);     // Prints "VERBOSE"
  print(stringSet.isEmpty);   // Prints "true"
}
```



## Best practices and limitations 
Shorthand syntax (`.foo`) can make code more concise, 
but the primary goal should be to improve readability. 
Only use shorthands if the type being omitted is completely 
obvious from the immediate local context. If a reader 
needs to look around to understand what class `.foo` refers to, 
it's better to write the type name out.

Avoid using shorthands within the arguments of other shorthands, 
especially for constructors. This can make it very hard to 
determine the types being used at each level.
<?code-excerpt "language/lib/classes/shorthand.dart (nested)"?>
```dart
// AVOID: Hard to read, types are hidden
// Widget complex = .container(
//   child: .padding(
//     padding: .all(8.0),
//     child: .text('Hello')
//   )
// );

// PREFER: Explicit types in nested structures
Widget complex = Container( // Assuming types
  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('Hello')
  )
);
```
