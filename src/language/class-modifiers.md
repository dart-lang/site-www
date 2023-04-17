---
title: Class modifiers
description: Modifier keywords for class declarations to control external library access.
---

Class modifiers control how a class or a mixin can be utilized by libraries
outside of the library where it's defined

The full set of modifiers that can appear before a class or mixin declaration
are `base`, `final`, `interface`, `sealed`, and `abstract`. 
Only the `base` modifier can appear before a mixin declaration. The modifiers do
not apply to other declarations like `enum`, `typedef`, or `extension`.

When deciding whether or not to use class modifiers, consider the following questions:
1. Is [any access](#no-modifier) fine?
2. If not, what is the intended use for the class? / what behavior does the class need to rely on?
    - [Implementation](#base)?
    - [Inheritance](#interface)?
    - [Both](#final)?
    - [Subtyping](#sealed) by outside libraries at all?
3. Then, does it need to be [abstract](#abstract)?
4. And lastly, should it be a [class, mixin, or mixin class](#class-mixin-or-mixin-class)?

## No modifier

Use a `class` or `mixin` declaration without a modifier to **allow unrestricted
access** from outside libraries. By default, you can:

- [Construct][] new instances of a class.
- [Extend][] a class to create a new subtype.
- [Implement][] a class or mixin's interface.
- [Mix in][] a mixin or mixin class.

## `base`

Use the `base` modifier to **disallow implementation** of a class or mixin
outside of the current library.
The `base` modifier must be applied transitively to all the subtypes of a class;
any class which implements or extends a base class must be marked `base` as well.

A base class can be extended and constructed. 

{{site.alert.note}}
  Only the `base` modifier can accompany a mixin declaration. 
  - A `base mixin` can be mixed in, but not implemented.
  - A `base mixin class` can be constructed, extended, and mixed in, but not
  implemented.
{{site.alert.end}}

```dart
// a.dart
base class Vehicle {
  String make?;
  String model?;
  void moveForward(int meters) { ... }
}
```

```dart
// b.dart

var myCar = Vehicle();     // Can be constructed

class Car extends          // Can be extended
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

Disallowing implementation makes `base` useful for:
- Ensuring that the base class constructor is called whenever an instance of a
subtype of the class is created
- Ensuring all private members are available on subtypes of the base class, and
and accessing them will never cause a [`noSuchMethod`][] error.

## `interface`

Use the `interface` modifier to **disallow extending a class** 
outside of the current library.
An interface class can be implemented and constructed.

```dart
// a.dart
interface class Vehicle {
  String make?;
  String model?;
  void moveForward(int meters) { ... }
}
```

```dart
// b.dart

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

Disallowing inheritance makes `interface` useful for:
- Defining API interfaces.
- Preventing users of the API from overriding a subset of methods.

## `final` 

Use the `final` modifier to **disallow extending _and_ implementing** a class
outside of the current library.
Final classes can be constructed.

```dart
// a.dart
final class Vehicle {
  String make;
  String model;
  void moveForward(int meters) { ... }
}
```

```dart
// b.dart

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

Disallowing inheritance and implementation makes `final` useful for:
- Closing the type hierarchy.
- Ensuring that adding new members to the class won't risk breaking changes for 
its consumers.
- Ensuring access to private members on instances of the final class will never
throw a [`noSuchMethod`][] error.

## `sealed`

Use the `sealed` modifier to define a class that **cannot be constructed, extended,
or implemented** outside of the library where the class is defined. 

The purpose of the `sealed` modifier is to enable [_exhaustiveness checking_][]
for switch cases.
Any possible direct subtypes of a sealed type can only exist in the same library,
so the compiler is always aware of the extent of a sealed type's hierarchy.

This allows the compiler to alert you when a switch is not exhaustively handling
all possible subtypes in its cases.

```dart
sealed class Vehicle {
  String make;
  String model;
  void moveForward(int meters) { ... }
}

class Car extends Vehicle { }
class Truck implements Vehicle { }
class Bicycle extends Vehicle { }

// ...

  return switch (vehicle) {         // ERROR: The switch is missing a subtype of Vehicle
    Car => 'vroom',
    Truck => 'VROOOOMM'
  };
```

## `abstract`

Use the `abstract` modifier to define a class that can’t be constructed.
Abstract classes are useful for defining interfaces, often with some
implementation. If you want your abstract class to appear to be instantiable,
define a [factory constructor][].

Abstract classes often have [abstract methods][].
Here’s an example of declaring an abstract class that has an abstract
method:

<?code-excerpt "misc/lib/language_tour/classes/misc.dart (abstract)"?>
```dart
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}
```

## `class`, `mixin`, or `mixin class`?

A `mixin` declaration defines a [mixin][]. A `class` declaration defines a [class][]. A
`mixin class` declaration defines both a mixin and a class, with the same name and
the same type.

Mixins and mixin classes are meant to be mixed in, so they cannot be combined
with the modifiers that prevent inheritance: `interface`, `final`, and `sealed`.

## Combining modifiers

It is possible to combine some modifiers for layered restrictions. For example, 
an `abstract interface class` combines restrictions on instantiation and inheritance.
This could be useful to define a "pure contract", or a class that doesn't update
any preexisting state.

Modifiers that are mutually exclusive cannot be combined. For example,
`base` allows extending and disallows implementing, and `interface` allows
implementing and disallows extending.

Modifiers that are redundant cannot be combined. For example, mixins and sealed
classes already cannot be constructed, so combining them with `abstract`, which
disallows construction, is redundant. 

The [syntax specification] documents the valid combinations and their capabilities.

[class]: /language/classes
[mix in]: /language/mixins
[mixin]: /language/mixins
[`noSuchMethod`]: /language/extend#nosuchmethod
[construct]: /language/constructors
[extend]: /language/extend
[implement]: /language/classes#implicit-interfaces
[factory constructor]: /language/constructors#factory-constructors
[_exhaustiveness checking_]: /language/control-flow
[abstract methods]: /language/methods#abstract-methods
[syntax specification]: https://github.com/dart-lang/language/blob/master/accepted/future-releases/class-modifiers/feature-specification.md#syntax