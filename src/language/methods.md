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

Methods are functions that provide behavior for an object.

## Instance methods

Instance methods on objects can access instance variables and `this`.
The `distanceTo()` method in the following sample is an example of an
instance method:

<?code-excerpt "misc/lib/language_tour/classes/point.dart (class-with-distanceTo)" plaster="none"?>
```dart
import 'dart:math';

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## Operators

Operators are instance methods with special names.
Dart allows you to define operators with the following names:

`<`  | `+`  | `|`  | `>>>`
`>`  | `/`  | `^`  | `[]`
`<=` | `~/` | `&`  | `[]=`
`>=` | `*`  | `<<` | `~`
`-`  | `%`  | `>>` | `==`
{:.table}

{{site.alert.note}}
  You may have noticed that some [operators][], like `!=`, aren't in
  the list of names. That's because they're just syntactic sugar. For example,
  the expression `e1 != e2` is syntactic sugar for `!(e1 == e2)`.
{{site.alert.end}}

{%- comment %}
  Internal note from https://github.com/dart-lang/site-www/pull/2691#discussion_r506184100:
  -  `??`, `&&` and `||` are excluded because they are lazy / short-circuiting operators
  - `!` is probably excluded for historical reasons
{% endcomment %}

An operator declaration is identified using the built-in identifier `operator`.
The following example defines vector 
addition (`+`), subtraction (`-`), and equality (`==`):

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
```

With getters and setters, you can start with instance variables, later
wrapping them with methods, all without changing client code.

{{site.alert.note}}
  Operators such as increment (++) work in the expected way, whether or
  not a getter is explicitly defined. To avoid any unexpected side
  effects, the operator calls the getter exactly once, saving its value
  in a temporary variable.
{{site.alert.end}}

## Abstract methods

Instance, getter, and setter methods can be abstract, defining an
interface but leaving its implementation up to other classes.
Abstract methods can only exist in [abstract classes][] or [mixins][].

To make a method abstract, use a semicolon (;) instead of a method body:

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
