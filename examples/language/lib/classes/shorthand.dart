// #docregion intro
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
// #enddocregion intro

// #docregion enums
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

// #enddocregion enums

// #docregion methods
// Static method
int httpPort = .parse('80'); // Instead of int.parse('80')

// Static field/getter
BigInt bigIntZero = .zero; // Instead of BigInt.zero
// #enddocregion methods
 
// #docregion constructors
 class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor

  // Factory constructor
  factory Point.fromList(List<double> list) {
    return Point(list[0], list[1]);
  }
}

// Named constructor
Point origin = .origin(); // Instead of Point.origin()

// Factory constructor
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// Generic class constructor
List<int> intList = .filled(5, 0); // Instead of List.filled(5, 0)
// #enddocregion constructors

// #docregion tearoff

// #enddocregion tearoff

// #docregion chain
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase(); // Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
// #enddocregion chain

// #docregion allowedequality
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
// #enddocregion allowedequality

// #docregion notallowedequality
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
// #enddocregion notallowedequality

// #docregion const
enum Status { none, running, stopped, paused }
class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Enum values are always constants
const Status defaultStatus = .running; // Instead of Status.running

// Invoking a const named constructor
const Point myOrigin = .origin(); 
// Instead of Point.origin()

// Using shorthands in a const collection literal
const List<Point> keyPoints = [ .origin(), .new(1.0, 1.0) ]; 
// Instead of [Point.origin(), Point(1.0, 1.0)]
// #enddocregion const

// #docregion unnamedbefore
class _PageState extends State<Page> {
  final AnimationController _animationController = AnimationController(vsync: this);
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties 
    = <String, Map<String, bool>>{};
  // ...
}
// #enddocregion unnamedbefore

// #docregion unnamedafter
class _PageState extends State<Page> {
  final AnimationController _animationController = .new(vsync: this);
  final ScrollController _scrollController = .new();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = .new();
  Map<String, Map<String, bool>> properties = .new();
  // ...
}
// #enddocregion unnamedafter