---
title: Constructors
description: Everything about using constructors in Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
prevpage:
  url: /language/classes
  title: Classes
nextpage:
  url: /language/methods
  title: Methods
---

Constructors are special functions that create instances of classes.

Dart implements many types of constructors.
Except for default constructors,
these functions use the same name as their class.

* [Generative constructors][generative]: Creates new instances and
      initializes instance variables.
* [Default constructors][default]: Used to create a new instance when a
     constructor hasn't been specified. It doesn't take arguments and
     isn't named.
* [Named constructors][named]: Clarifies the purpose of
      a constructor or allows the creation of multiple constructors for
      the same class.
* [Constant constructors][constant]: Creates instances as compile-type
      constants.
* [Factory constructors][factory]: Either creates a new instance of a
      subtype or returns an existing instance from cache.
* [Redirecting constructor][redirecting]: Forwards calls to another
      constructor in the same class.

[default]: #default-constructors
[generative]: #generative-constructors
[named]: #named-constructors
[constant]: #constant-constructors
[factory]: #factory-constructors
[redirecting]: #redirecting-constructors

<?code-excerpt path-base="misc/lib/language_tour/classes"?>

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

## Types of constructors

### Generative constructors

To instantiate a class, use a generative constructor.

<?code-excerpt "point_alt.dart (idiomatic-constructor)" plaster="none"?>
```dart
class Point {
  // Initializer list of variables and values
  double x = 2.0;
  double y = 2.0;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
}
```

### Default constructors

If you don't declare a constructor, Dart uses the default constructor.
The default constructor is a generative constructor without arguments or name.

### Named constructors

Use a named constructor to implement multiple constructors for a class
or to provide extra clarity:

<?code-excerpt "point.dart (named-constructor)" replace="/Point\.\S*/[!$&!]/g" plaster="none"?>
```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  // Named constructor
  [!Point.origin()!]
      : x = xOrigin,
        y = yOrigin;
}
```

A subclass doesn't inherit a superclass's named constructor.
To create a subclass with a named constructor defined in the superclass,
implement that constructor in the subclass.

### Constant constructors

If your class produces unchanging objects, make these
objects compile-time constants. 
To make objects compile-time constants, define a `const` constructor
with all instance variables set as `final`.

<?code-excerpt "immutable_point.dart"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Constant constructors don't always create constants.
They might be invoked in a non-`const` context.
To learn more, consult the section on [using constructors][].

### Redirecting constructors

A constructor might redirect to another constructor in the same class.
A redirecting constructor has an empty body.
The constructor uses `this` instead of the class name after a colon (:).

<?code-excerpt "point_redirecting.dart"?>
```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```

### Factory constructors

When encountering one of following two cases of implementing a constructor,
use the `factory` keyword:

* The constructor doesn't always create a new instance of its class.
  Although a factory constructor cannot return `null`,
  it might return:
  
  * an existing instance from a cache instead of creating a new one
  * a new instance of a subtype

* You need to perform non-trivial work prior to constructing an instance.
  This could include checking arguments or doing any other processing
  that cannot be handled in the initializer list.

:::tip
You can also handle late initialization of a final variable
with [`late final`][late-final-ivar] (carefully!).
:::

The following example includes two factory constructors.

* `Logger` factory constructor returns objects from a cache.
* `Logger.fromJson` factory constructor initializes a final variable
  from a JSON object.

<?code-excerpt "logger.dart (constructors)"?>
```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
```

:::warning
Factory constructors can't access `this`.
:::

Use a factory constructor as any other constructor:

<?code-excerpt "logger.dart (logger)"?>
```dart
var logger = Logger('UI');
logger.log('Button clicked');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

### Redirecting factory constructors

A redirecting factory constructor specifies a call to a constructor of another
class to use whenever someone makes a call to the redirecting constructor.

```dart
factory Listenable.merge(List<Listenable> listenables) = _MergingListenable
```

It might appear that ordinary factory constructors
could create and return instances of other classes.
This would make redirecting factories unnecessary.
Redirecting factories have several advantages:

* An abstract class might provide a constant constructor
  that uses the constant constructor of another class.
* A redirecting factory constructor avoids the need for forwarders
  to repeat the formal parameters and their default values.

### Constructor tear-offs

Dart allows you to supply a constructor as a parameter without calling it.
Called a _tear-off_ (as you _tear off_ the parentheses)
serves as a closure that invokes the constructor with the same parameters.

If the tear-off is a constructor with the same signature and return type
as the method accepts, you can use the tear-off as a parameter or variable.

Tear-offs differ from lambdas or anonymous functions.
Lambdas serve as a wrapper for the constructor whereas a tear-off
is the constructor.

**Use Tear-Offs**

```dart tag=good
// Use a tear-off for a named constructor: 
var strings = charCodes.map(String.fromCharCode);  

// Use a tear-off for an unnamed constructor: 
var buffers = charCodes.map(StringBuffer.new); 
```

**Not Lambdas**

```dart tag=bad
// Instead of a lambda for a named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Instead of a lambda for an unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

For visual learners, watch this Decoding Flutter video on tear-offs.

<iframe
  {{yt.std-size}}
  title="Learn about tear-offs in Dart"
  src="{{yt.embed}}/OmCaloD7sis"
  {{yt.set}}>
</iframe>

## Instance Variable Initialization

Dart can initialize variables in three ways.

### Initialize instance variables in the declaration

Initialize the instance variables when you declare the variables.

<?code-excerpt "point_alt.dart (initialize-declaration)" plaster="none"?>
```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

  // The implicit default constructor sets these variables to (1.0,2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
```

### Use initializing formal parameters

To simplify the common pattern of assigning a constructor argument
to an instance variable, Dart has *initializing formal parameters*.

In the constructor declaration, include `this.<propertyName>`
and omit the body. The `this` keyword refers to the current instance.

When the name conflict exists, use `this`.
Otherwise, Dart style omits the `this`.
An exception exists for the generative constructor where
you must prefix the initializing formal parameter name with `this`.

As noted earlier in this guide, certain constructors
and certain parts of constructors can't access `this`. These include:

* Factory constructors
* The right-hand side of an initializer list
* Arguments to a superclass constructor

Initializing formal parameters also allow you to initialize
non-nullable or `final` instance variables.
Both of these types of variables require initialization or a default value.

<?code-excerpt "point_alt.dart (initialize-formal)" plaster="none"?>
```dart
class PointB {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  PointB(this.x, this.y);

  // Initializing formal parameters can also be optional.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

Private fields can't be used as named initializing formals.

{% comment %}
Don't attach the following example to a code excerpt.
It doesn't work on purpose and will cause errors in CI.
{% endcomment %}

```dart
class PointB {
// ...

  PointB.namedPrivate({required double x, required double y})
      : _x = x,
        _y = y;

// ...
}
```

This also works with named variables.

<?code-excerpt "point_alt.dart (initialize-named)" plaster="none"?>
```dart
class PointC {
  double x; // must be set in constructor
  double y; // must be set in constructor

  // Generative constructor with initializing formal parameters
  // with default values
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x,$y)';
  }
}

// Constructor using named variables.
final pointC = PointC.named(x: 2.0, y: 2.0);
```

All variables introduced from initializing formal parameters are both
final and only in scope of the initialized variables.

To perform logic that you can't express in the initializer list,
create a [factory constructor](#factory-constructors)
or [static method][] with that logic.
You can then pass the computed values to a normal constructor.

The constructor parameters could be set as nullable and not be initialized.

<?code-excerpt "point_alt.dart (initialize-null)" plaster="none"?>
```dart
class PointD {
  double? x; // null if not set in constructor
  double? y; // null if not set in constructor

  // Generative constructor with initializing formal parameters
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
```

### Use an initializer list

Before the constructor body runs, you can initialize instance variables.
Separate initializers with commas.

<?code-excerpt "point_alt.dart (initializer-list)"?>
```dart
// Initializer list sets instance variables before
// the constructor body runs.
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

:::warning
The right-hand side of an initializer list can't access `this`.
:::

To validate inputs during development,
use `assert` in the initializer list.

<?code-excerpt "point_alt.dart (initializer-list-with-assert)" replace="/assert\(.*?\)/[!$&!]/g"?>
```dart
Point.withAssert(this.x, this.y) : [!assert(x >= 0)!] {
  print('In Point.withAssert(): ($x, $y)');
}
```

Initializer lists help set up `final` fields.

The following example initializes three `final` fields in an initializer list.
To execute the code, click **Run**.

<?code-excerpt "point_with_distance_field.dart"?>
```dartpad
import 'dart:math';

class Point {
  final double x;
  final double y;
  final double distanceFromOrigin;

  Point(double x, double y)
      : x = x,
        y = y,
        distanceFromOrigin = sqrt(x * x + y * y);
}

void main() {
  var p = Point(2, 3);
  print(p.distanceFromOrigin);
}
```

## Constructor inheritance

_Subclasses_, or child classes, don't inherit *constructors*
from their _superclass_, or immediate parent class.
If a class doesn't declare a constructor, it can only use the
[default constructor](#default-constructors).

A class can inherit the _parameters_ of a superclass.
These are called [super parameters](#super-parameters)

Constructors work in a somewhat similar way to
how you call a chain of static methods.
Each subclass can call its superclass's constructor to initialize an instance,
like a subclass can call a superclass's static method.
This process doesn't "inherit" constructor bodies or signatures.

### Non-default superclass constructors

Dart executes constructors in the following order:

1. [initializer list](#use-an-initializer-list)
1. superclass's unnamed, no-arg constructor
1. main class's no-arg constructor

If the superclass lacks an unnamed, no-argument constructor,
call one of the constructors in the superclass.
Before the constructor body (if any),
specify the superclass constructor after a colon (`:`).

In the following example,
the `Employee` class constructor calls the named constructor
for its superclass, `Person`. To execute the following code, click **Run**.

<?code-excerpt "employee.dart (super)" plaster="none"?>
```dartpad
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Prints:
  // in Person
  // in Employee
  // Instance of 'Employee'
}
```

As Dart evaluates the arguments to the superclass constructor *before*
invoking the constructor, an argument can be an expression like a
function call.

<?code-excerpt "employee.dart (method-then-constructor)"?>
```dart
class Employee extends Person {
  Employee() : super.fromJson(fetchDefaultData());
  // ···
}
```

:::warning
Arguments to the superclass constructor can't access `this`.
For example, arguments can call *static* methods
but not *instance* methods.
:::

### Super parameters

To avoid passing each parameter into the super invocation of a constructor,
use super-initializer parameters to forward parameters
to the specified or default superclass constructor.
You can't use this feature with
[redirecting constructors](#redirecting-constructors).
Super-initializer parameters have syntax and semantics like
[initializing formal parameters](#use-initializing-formal-parameters).

:::version-note
Using super-initializer parameters
requires a [language version][] of at least 2.17.
If you're using an earlier language version,
you must manually pass in all super constructor parameters.
:::

If the super-constructor invocation includes positional arguments,
super-initializer parameters can't be positional.

<?code-excerpt "super_initializer_positional_parameters.dart (positional)" plaster="none"?>
```dart
class Vector2d {
  final double x;
  final double y;

  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the x and y parameters to the default super constructor like:
  // Vector3d(final double x, final double y, this.z) : super(x, y);
  Vector3d(super.x, super.y, this.z);
}
```

To further illustrate, consider the following example.

```dart
  // If you invoke the super constructor (`super(0)`) with any
  // positional arguments, using a super parameter (`super.x`)
  // results in an error.
  Vector3d.xAxisError(super.x): z = 0, super(0); // BAD
```

This named constructor tries to set the `x` value twice:
once in the super constructor and once as a
positional super parameter.
As both address the `x` positional parameter, this results in an error.

When the super constructor has named arguments, you can split them
between named super parameters (`super.y` in the next example)
and named arguments to the super constructor invocation
(`super.named(x: 0)`).

<?code-excerpt "super_initializer_named_parameters.dart (named)" plaster="none"?>
```dart
class Vector2d {
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```

[language version]: /guides/language/evolution#language-versioning
[using constructors]: /language/classes#using-constructors
[late-final-ivar]: /effective-dart/design#avoid-public-late-final-fields-without-initializers
[static method]: /language/classes#static-methods
