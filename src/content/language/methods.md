---
title: Methods
description: Learn about methods in Dart.
prevpage:
  url: /language/constructors
  title: Constructors
nextpage:
  url: /language/extend
  title: Extend a class
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

Methods are functions that provide behavior for an object.

## Instance methods

Instance methods on objects can access instance variables and `this`.
The `distanceTo()` method in the following sample is an example of an
instance method:

<?code-excerpt "misc/lib/language_tour/classes/point.dart (class-with-distance-to)" plaster="none"?>
```dart
import 'dart:math';

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## Operators

Most operators are instance methods with special names.
Dart allows you to define operators with the following names:

|       |      |      |      |       |      |
|-------|------|------|------|-------|------|
| `<`   | `>`  | `<=` | `>=` | `==`  | `~`  |
| `-`   | `+`  | `/`  | `~/` | `*`   | `%`  |
| `\|`  | `ˆ`  | `&`  | `<<` | `>>>` | `>>` |
| `[]=` | `[]` |      |      |       |      |

{:.table}

:::note
You may have noticed that some [operators][], like `!=`, aren't in
the list of names. These operators aren't instance methods.
Their behavior is built in to Dart.
:::

{%- comment %}
  Internal note from https://github.com/dart-lang/site-www/pull/2691#discussion_r506184100:
  -  `??`, `&&` and `||` are excluded because they are lazy / short-circuiting operators
  - `!` is probably excluded for historical reasons
{% endcomment %}

To declare an operator, use the built-in identifier
`operator` then the operator you are defining.
The following example defines vector addition (`+`), subtraction (`-`),
and equality (`==`):

<?code-excerpt "misc/lib/language_tour/classes/vector.dart"?>
```dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
```


## Getters and setters

Getters and setters are special methods that provide read and write
access to an object's properties. Recall that each instance variable has
an implicit getter, plus a setter if appropriate. You can create
additional properties by implementing getters and setters, using the
`get` and `set` keywords:

<?code-excerpt "misc/lib/language_tour/classes/rectangle.dart"?>
```dart
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  double get right => left + width;
  set right(double value) => left = value - width;
  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
  assert(rect.left == 3);
  rect.right = 12;
  assert(rect.left == -8);
}
class Example {
  int a;
  int _b;
  final int c;
  static int d = 1000;

  Example(this.a, this._b, this.c);
}

void handleExample() {
  final ex = Example(1, 2, 3);
  final v = ex.a; // Getter for 'a'
  ex.a = 10;      // Setter for 'a'
  ex.a++;         // Increment 'a'
  assert(ex.a == 11);

  final u = ex._b; // Getter for '_b' (private to library)
  ex._b = 20;      // Setter for '_b'
  assert(ex._b == 20);

  final w = ex.c; // Getter for 'c' (final field)
  // ex.c = 10; // Error: 'c' is final

  final z = Example.d; // Static getter for 'd'
  Example.d = 10;      // Static setter for 'd'
  Example.d++;
  assert(Example.d == 11);
}
//fautly examples
/*
These examples illustrate common mistakes when using getters and setters. They show how attempting to use methods as getters or setters, or vice versa, results in errors.
*/
class ExampleFaulty extends Example {
  ExampleFaulty(super.a, super._b, super.c);

  int a() {
    return a; // Error: Cannot use method as a getter
  }

  void a(int x) {
    a = x; // Error: Cannot use method as a setter
  }
}
//java style getters and setters
/*This example demonstrates a Java-style approach to getters and setters. Instead of using Dart's get and set keywords, methods are used to achieve similar functionality. This style is not typical in Dart but is shown here for comparison.*/
class ExampleJavaStyleGetterSetter extends Example {
  ExampleJavaStyleGetterSetter(super.a, super._b, super.c);

  int getA() {
    return a;
  }

  void setA(int x) {
    a = x;
  }
}
//over riding getters and setters
class ExampleOverrideGetterSetterOfA1 extends Example {
  ExampleOverrideGetterSetterOfA1(super.a, super._b, super.c);

  set a(int x) => a = x;
  int get a => a;
}

class ExampleOverrideAccessorsOfA2 extends Example {
  ExampleOverrideAccessorsOfA2(super.a, super._b, super.c);

  set a(int x) {
    print("Setter for 'a' called");
    a = x;
  }

  int get a {
    print("Getter for 'a' called");
    return a;
  }
}
//synthetic field example
class ExampleSyntheticField {
  double angle = 0.0;

  static double _canonicalize(double x) {
    if (x >= 0.0) {
      return x.remainder(2.0 * pi);
    } else {
      return 2 * pi + x.remainder(2.0 * pi);
    }
  }

  double get opposite => _canonicalize(angle + pi);
  set opposite(double x) => angle = _canonicalize(x - pi);
}

void handleExampleSyntheticField() {
  final obj = ExampleSyntheticField();
  obj.angle = 0.5 * pi;
  print("The opposite of ${obj.angle / pi} π is ${obj.opposite / pi} π");
  obj.opposite = 0.5 * pi;
  print("If the opposite is ${obj.opposite / pi} π, the angle is ${obj.angle / pi} π");
  obj.opposite += 0.25 * pi;
  print("If the opposite is ${obj.opposite / pi} π, the angle is ${obj.angle / pi} π");
}


```



With getters and setters, you can start with instance variables, later
wrapping them with methods, all without changing client code.

:::note
Operators such as increment (++) work in the expected way, whether or
not a getter is explicitly defined. To avoid any unexpected side
effects, the operator calls the getter exactly once, saving its value
in a temporary variable.
:::

## Abstract methods

Instance, getter, and setter methods can be abstract, defining an
interface but leaving its implementation up to other classes.
Abstract methods can only exist in [abstract classes][] or [mixins][].

To make a method abstract, use a semicolon (`;`) instead of a method body:

<?code-excerpt "misc/lib/language_tour/classes/doer.dart"?>
```dart
abstract class Doer {
  // Define instance variables and methods...

  void doSomething(); // Define an abstract method.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // Provide an implementation, so the method is not abstract here...
  }
}
```

[operators]: /language/operators
[abstract classes]: /language/class-modifiers#abstract
[mixins]: /language/mixins
