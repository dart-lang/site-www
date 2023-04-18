---
title: Class modifiers
description: Modifier keywords for class declarations to control external library access.
---

Class modifiers control how a class or a mixin can be subtyped in libraries
outside of the library where it's defined.

The full set of modifiers that can appear before a class declaration
are `abstract`, [`mixin`][mixin], `base`, `final`, `interface`, and `sealed`. 
Only the `base` modifier can appear before a mixin declaration. The modifiers do
not apply to other declarations like `enum`, `typedef`, or `extension`.

When deciding whether to use class modifiers, consider the intended uses of the
class, and what behaviors the class needs to be able to rely on.

## No modifier

Use a `class` or `mixin` declaration without a modifier to allow unrestricted
permission to create subtype relationships from outside libraries.
By default, you can:

- [Construct][] new instances of a class.
- [Extend][] a class to create a new subtype.
- [Implement][] a class or mixin's interface.
- [Mix in][mixin] a mixin or mixin class.

## `abstract`

Use the `abstract` modifier to define a class that can’t be constructed.
Abstract classes are useful for defining interfaces, often with some
implementation. Abstract classes often have [abstract methods][]:

```dart
// Library a.dart
abstract class Vehicle {
  
  void moveForward();     // Abstract method.
}
```

```dart
// Library b.dart
import 'a.dart';

var myCar = Vehicle();     // Error: Cannot be constructed

class Car extends          // Can be extended
  Vehicle {
    int passengers;
    ...
}

class MockVehicle          // Can be implemented
  implements Vehicle {
    @override
    void moveForward(int meters) { ... }
}
```

If you want your abstract class to appear to be instantiable,
define a [factory constructor][].

## `base`

Use the `base` modifier to enforce inheritance of a class or mixin's implementation.

The `base` modifier disallows implementation outside of the current library, which
guarantees:

- The base class constructor is called whenever an instance of a subtype of the
class is created.
- That all implemented private members exist in subtypes.
- Adding new members to a class reduces the risk of breaking subtypes, since all
subtypes will inherit the new member.

The `base` modifier must be applied transitively to all the subtypes of a class;
any class which implements or extends a base class must be marked `base` as well. 

```dart
// Library a.dart
base class Vehicle {
  void moveForward(int meters) { ... }
}
```

```dart
// Library b.dart
import 'a.dart';

var myCar = Vehicle();          // Can be constructed

base class Car extends          // Can be extended
  Vehicle {
    int passengers;
    ...
}

base class MockVehicle          // ERROR: Cannot be implemented
  implements Vehicle {
    @override
    void moveForward ...
}
```

## `interface`

Use the `interface` modifier to define an interface. Interface classes can be
implemented outside of the current library, but not extended. This guarantees:

- Users of the API are prevented from overriding a subset of methods.
- A solution to the [fragile base class problem][], or the freedom to change the
interface's implementation, because there are no inherited member implementations
outside of the current library whose behavior needs to be preserved. 

```dart
// Library a.dart
interface class Vehicle {
  void moveForward(int meters) { ... }
}
```

```dart
// Library b.dart
import 'a.dart';

var myCar = Vehicle();     // Can be constructed

class Car extends          // ERROR: Cannot be inherited
  Vehicle {
    int passengers;
    ...
}

class MockVehicle          // Can be implemented     
  implements Vehicle {
    @override
    void moveForward ...
}
```

To define a pure interface that others are free to implement, that cannot be
inherited and only has abstract members, define an `abstract interface class`.

## `final` 

Use the `final` modifier to prevent subtyping from a class outside of the current
library, closing the type hierarchy. 

Disallowing both inheritance and implementation means `final` classes provide all
the same guarantees of [`base`](#base) and [`interface`](#interface) classes.

Final class can be extended or implemented within the
same library, but like the `base` modifier, any subtypes must be marked `base`.

```dart
// Library a.dart
final class Vehicle {
  void moveForward(int meters) { ... }
}
```

```dart
// Library b.dart
import 'a.dart';

var myCar = Vehicle();     // Can be constructed

class Car extends          // ERROR: Cannot be inherited
  Vehicle {
    int passengers;
    ...
}

class MockVehicle          // ERROR: Cannot be implemented     
  implements Vehicle {
    @override
    void moveForward ...
}
```

## `sealed`

Use the `sealed` modifier to create a known, enumerable set of subtypes, so that
a switch over those types can be statically ensured to be [_exhaustive_][exhaustive].

The `sealed` modifier prevents a class from being extended or implemented outside
of the library where the class is defined. The compiler is aware of any possible
direct subtypes because they can only exist in the same library.

This allows the compiler to alert you when a switch is not exhaustively handling
all possible subtypes in its cases:

```dart
sealed class Vehicle { ... }

class Car extends Vehicle { }
class Truck implements Vehicle { }
class Bicycle extends Vehicle { }

// ...

var vehicle = Vehicle();                 // ERROR: Cannot be instantiated

// ...

return switch (Vehicle vehicle) {       // ERROR: The switch is missing a subtype of Vehicle
  Car => 'vroom',
  Truck => 'VROOOOMM'
};
```

If [exhaustiveness checking][exhaustive] is not necessary for your use case, use
[`final`](#final) instead.

## Combining modifiers

It is possible to combine some modifiers for layered restrictions. 
A class declaration can be, in order:

* (Optional) `abstract`, describing whether the class can contain abstract members
and prevents instantiation.
* (Optional) One of `base`, `interface`, `final` or `sealed`, describing
restrictions on other libraries subtyping the class.
* (Optional) `mixin`, describing whether the declaration can be mixed in.
* The `class` keyword itself.

Some combinations are disallowed beacause they are contradictory, redundant, or
otherwise mutually exclusive:

* `abstract` with `sealed` (because a sealed class is always implicitly abstract).
* `interface`, `final` or `sealed` with `mixin` (because those access modifiers
prevent mixing in).

[class, mixin, or mixin class]: /language/mixins#class-mixin-or-mixin-class
[mixin]: /language/mixins
[fragile base class problem]: https://en.wikipedia.org/wiki/Fragile_base_class
[`noSuchMethod`]: /language/extend#nosuchmethod
[construct]: /language/constructors
[extend]: /language/extend
[implement]: /language/classes#implicit-interfaces
[factory constructor]: /language/constructors#factory-constructors
[exhaustive]: /language/control-flow
[abstract methods]: /language/methods#abstract-methods
[syntax specification]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/class-modifiers/feature-specification.md#syntax