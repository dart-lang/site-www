---
title: Constructors
description: Everything about using constructors in Dart.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
prevpage:
  url: /language/classes
  title: Classes
nextpage:
  url: /language/methods
  title: Methods
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Declare a constructor by creating a function with the same name as its
class (plus, optionally, an additional identifier as described in
[Named constructors](#named-constructors)).
The most common form of constructor, the generative constructor, creates
a new instance of a class:

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (constructor-long-way)" plaster="none"?>
```dart
class Point {
  double x = 0;
  double y = 0;

  Point(double x, double y) {
    // See initializing formal parameters for a better way
    // to initialize instance variables.
    this.x = x;
    this.y = y;
  }
}
```

The `this` keyword refers to the current instance.

{{site.alert.note}}
  Use `this` only when there is a name conflict. 
  Otherwise, Dart style omits the `this`.
{{site.alert.end}}


## Initializing formal parameters

The pattern of assigning a constructor argument to an instance variable
is so common, 
Dart has initializing formal parameters to make it easy.

Initializing parameters can also be used to initialize
non-nullable or `final` instance variables,
which both must be initialized or provided a default value.

<?code-excerpt "misc/lib/language_tour/classes/point.dart (constructor-initializer)" plaster="none"?>
```dart
class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);
}
```

The variables introduced by the initializing formals
are implicitly final and only in scope of the initializer list.


## Default constructors

If you don't declare a constructor, a default constructor is provided
for you. The default constructor has no arguments and invokes the
no-argument constructor in the superclass.


## Constructors aren't inherited

Subclasses don't inherit constructors from their superclass. A subclass
that declares no constructors has only the default (no argument, no
name) constructor.


## Named constructors

Use a named constructor to implement multiple constructors for a class
or to provide extra clarity:

<?code-excerpt "misc/lib/language_tour/classes/point.dart (named-constructor)" replace="/Point\.\S*/[!$&!]/g" plaster="none"?>
{% prettify dart tag=pre+code %}
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);

  // Named constructor
  [!Point.origin()!]
      : x = xOrigin,
        y = yOrigin;
}
{% endprettify %}

Remember that constructors are not inherited, which means that a
superclass's named constructor is not inherited by a subclass. If you
want a subclass to be created with a named constructor defined in the
superclass, you must implement that constructor in the subclass.


## Invoking a non-default superclass constructor

By default, a constructor in a subclass calls the superclass's unnamed,
no-argument constructor.
The superclass's constructor is called at the beginning of the
constructor body. If an [initializer list](#initializer-list)
is also being used, it executes before the superclass is called.
In summary, the order of execution is as follows:

1. initializer list
1. superclass's no-arg constructor
1. main class's no-arg constructor

If the superclass doesn't have an unnamed, no-argument constructor,
then you must manually call one of the constructors in the
superclass. Specify the superclass constructor after a colon (`:`), just
before the constructor body (if any).

In the following example, the constructor for the Employee class calls the named
constructor for its superclass, Person. Click **Run** to execute the code.

<?code-excerpt "misc/lib/language_tour/classes/employee.dart (super)" plaster="none"?>
```dart:run-dartpad:height-450px:ga_id-non_default_superclass_constructor
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson().
  Employee.fromJson(super.data) : super.fromJson() {
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

Because the arguments to the superclass constructor are evaluated before
invoking the constructor, an argument can be an expression such as a
function call:

<?code-excerpt "misc/lib/language_tour/classes/employee.dart (method-then-constructor)"?>
```dart
class Employee extends Person {
  Employee() : super.fromJson(fetchDefaultData());
  // ···
}
```

{{site.alert.warning}}
  Arguments to the superclass constructor don't have access to `this`. For
  example, arguments can call static methods but not instance methods.
{{site.alert.end}}

### Super parameters

To avoid having to manually pass each parameter
into the super invocation of a constructor,
you can use super-initializer parameters to forward parameters
to the specified or default superclass constructor.
This feature can't be used with redirecting constructors.
Super-initializer parameters have similar syntax and semantics to
[initializing formal parameters](#initializing-formal-parameters):

<?code-excerpt "misc/lib/language_tour/classes/super_initializer_parameters.dart (positional)" plaster="none"?>
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

Super-initializer parameters cannot be positional 
if the super-constructor invocation already has positional arguments,
but they can always be named:

<?code-excerpt "misc/lib/language_tour/classes/super_initializer_parameters.dart (named)" plaster="none"?>
```dart
class Vector2d {
  // ...

  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  // ...

  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```

{{site.alert.version-note}}
  Using super-initializer parameters 
  requires a [language version][] of at least 2.17.
  If you're using an earlier language version,
  you must manually pass in all super constructor parameters.
{{site.alert.end}}

## Initializer list

Besides invoking a superclass constructor, you can also initialize
instance variables before the constructor body runs. Separate
initializers with commas.

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (initializer-list)"?>
```dart
// Initializer list sets instance variables before
// the constructor body runs.
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

{{site.alert.warning}}
  The right-hand side of an initializer doesn't have access to `this`.
{{site.alert.end}}

During development, you can validate inputs by using `assert` in the
initializer list.

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (initializer-list-with-assert)" replace="/assert\(.*?\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Point.withAssert(this.x, this.y) : [!assert(x >= 0)!] {
  print('In Point.withAssert(): ($x, $y)');
}
{% endprettify %}

Initializer lists are handy when setting up final fields. The following example
initializes three final fields in an initializer list. Click **Run** to execute
the code.

<?code-excerpt "misc/lib/language_tour/classes/point_with_distance_field.dart"?>
```dart:run-dartpad:height-340px:ga_id-initializer_list
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


## Redirecting constructors

Sometimes a constructor's only purpose is to redirect to another
constructor in the same class. A redirecting constructor's body is
empty, with the constructor call
(using `this` instead of the class name)
appearing after a colon (:).

<?code-excerpt "misc/lib/language_tour/classes/point_redirecting.dart"?>
```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```


## Constant constructors

If your class produces objects that never change, you can make these
objects compile-time constants. To do this, define a `const` constructor
and make sure that all instance variables are `final`.

<?code-excerpt "misc/lib/language_tour/classes/immutable_point.dart"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Constant constructors don't always create constants.
For details, see the section on
[using constructors][].


## Factory constructors

Use the `factory` keyword when implementing a constructor that doesn't
always create a new instance of its class. For example, a factory
constructor might return an instance from a cache, or it might
return an instance of a subtype.
Another use case for factory constructors is
initializing a final variable using
logic that can't be handled in the initializer list.

{{site.alert.tip}}
  Another way to handle late initialization of a final variable
  is to [use `late final` (carefully!)][late-final-ivar].
{{site.alert.end}}

In the following example,
the `Logger` factory constructor returns objects from a cache,
and the `Logger.fromJson` factory constructor
initializes a final variable from a JSON object.

<?code-excerpt "misc/lib/language_tour/classes/logger.dart"?>
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

{{site.alert.note}}
  Factory constructors have no access to `this`.
{{site.alert.end}}

Invoke a factory constructor just like you would any other constructor:

<?code-excerpt "misc/lib/language_tour/classes/logger.dart (logger)"?>
```dart
var logger = Logger('UI');
logger.log('Button clicked');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

[language version]: /guides/language/evolution#language-versioning
[using constructors]: /language/classes#using-constructors
[late-final-ivar]: /effective-dart/design#avoid-public-late-final-fields-without-initializers
