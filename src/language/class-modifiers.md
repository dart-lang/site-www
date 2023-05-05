---
title: Class modifiers
description: Modifier keywords for class declarations to control external library access.
---

Class modifiers control how a class or mixin can be used, both
[from within its own library](#abstract), and from outside of the library where
it's defined.

Modifiers prepend a class or mixin declaration.
For example, writing `abstract class` defines an abstract class.
The full set of modifiers that can appear before a class declaration include:

- `abstract`
- `base`
- `final`
- `interface`
- `sealed`
- [`mixin`][class, mixin, or mixin class]

Only the `base` modifier can appear before a mixin declaration. The modifiers do
not apply to other declarations like `enum`, `typedef`, or `extension`.

When deciding whether to use class modifiers, consider the intended uses of the
class, and what behaviors the class needs to be able to rely on.

## No modifier

To allow unrestricted permission to construct or subtype from any library,
use a `class` or `mixin` declaration without a modifier. By default, you can:

- [Construct][] new instances of a class.
- [Extend][] a class to create a new subtype.
- [Implement][] a class or mixin's interface.
- [Mix in][mixin] a mixin or mixin class.

## `abstract`

To define a class that doesn't require a full, concrete implementation of its
entire interface, use the `abstract` modifier.

Abstract classes cannot be constructed from any library, whether its own or
an outside library. Abstract classes often have [abstract methods][].

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

To enforce inheritance of a class or mixin's implementation, use the `base` modifier.
A base class disallows implementation outside of its own library. This guarantees:

- The base class constructor is called whenever an instance of a subtype of the
class is created.
- All implemented private members exist in subtypes.
- A new implemented member in a `base` class does not break subtypes,
since all subtypes inherit the new member.
  - This is true unless the subtype already declares a member with the same name
  and an incompatible signature.

Any class which implements or extends a base class must transitively be marked
`base`, `final`, or `sealed`. This is necessary to prevent outside libraries from
breaking the base class guarantees.

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

To define an interface, use the `interface` modifier. Libraries outside of the
interface's own defining library can implement the interface, but not extend it.
This guarantees:

- When an instance method in the class calls another instance method on `this`,
it will always invoke a known implementation of the method from the same library.
- Other libraries can't override methods which may then be called by the interface
class's own methods in unexpected ways. This reduces the [fragile base class problem][].

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

### `abstract interface`

The most common use for the `interface` modifier is to [combine](#combining-modifiers)
it with [`abstract`](#abstract) for an `abstract interface class`.
This defines a pure interface. 

Like an `interface` class, other libraries can implement, but cannot inherit,
a pure interface. Like an `abstract` class, a pure interface is allowed to have
abstract members.

## `final` 

To close the type hierarchy, use the `final` modifier.
This prevents subtyping from a class outside of the current library. 
Disallowing both inheritance and implementation prevents subtyping entirely.
This guarantees:

- You can safely add incremental changes to the API.
- You can call instance methods knowing that they haven't been overwritten in a
third-party subclass.

Final classes can be extended or implemented within the
same library. The `final` modifier encompasses the effects of `base`, and
therefore any subclasses must also be marked `base`, `final`, or `sealed`.


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

To create a known, enumerable set of subtypes, so that a switch over those types
can be statically ensured to be [_exhaustive_][exhaustive], use the `sealed` modifier.

The `sealed` modifier prevents a class from being extended or implemented outside
of the library where the class is defined. They also prevent construction,
and are therefore implicitly [abstract](#abstract).

The compiler is aware of any possible direct subtypes because they can only exist
in the same library. This allows the compiler to alert you when a switch does not
exhaustively handle all possible subtypes in its cases:

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

If you don't intend users to be able to [exhaustively switch][exhaustive] over
the subtypes of the class, or you want the freedom to add new subtypes later
without it being a breaking API change, use [`final`](#final) instead.

## Combining modifiers

You can combine some modifiers for layered restrictions. 
A class declaration can be, in order:

1. (Optional) `abstract`, describing whether the class can contain abstract members
and prevents instantiation.
2. (Optional) One of `base`, `interface`, `final` or `sealed`, describing
restrictions on other libraries subtyping the class.
3. (Optional) `mixin`, describing whether the declaration can be mixed in.
4. The `class` keyword itself.

You can't combine some modifiers beacause they are contradictory, redundant, or
otherwise mutually exclusive:

* `abstract` with `sealed`. A [sealed](#sealed) class is always implicitly
[abstract](#abstract).
* `interface`, `final` or `sealed` with `mixin`. These access modifiers
prevent [mixing in][mixin].

[class, mixin, or mixin class]: /language/mixins#class-mixin-or-mixin-class
[mixin]: /language/mixins
[fragile base class problem]: https://en.wikipedia.org/wiki/Fragile_base_class
[`noSuchMethod`]: /language/extend#nosuchmethod
[construct]: /language/constructors
[extend]: /language/extend
[implement]: /language/classes#implicit-interfaces
[factory constructor]: /language/constructors#factory-constructors
[exhaustive]: /
[abstract methods]: /language/methods#abstract-methods
[syntax specification]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/class-modifiers/feature-specification.md#syntax