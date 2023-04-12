---
title: Class modifiers
description: Modifier keywords for class declarations to control external library access.
---

Class modifiers control how a class or a mixin can be implemented, extended,
or mixed in. 

The full set of modifiers that can appear before a class declaration are `base`,
`final`, `interface`, `sealed`, `abstract`, and `mixin`. 
Only the `base` modifier can appear before a mixin declaration. The modifiers do
not apply to other declarations like `enum`, `typedef`, or `extension`.

When deciding whether or not to use class modifiers, consider the following questions:
1. Is [any access](#no-modifier) fine?
2. If not, what do you want to restrict?
    - [Implementation](#base)?
    - [Inheritance](#interface)?
    - [Both](#final)?
    - [Subtyping](#sealed) by outside libraries at all?
3. Then, does it need to be [abstract](#abstract)?
4. And lastly, should it be a [class, mixin, or mixin class](#class-mixin-or-mixin-class)?

## No modifier

Use a `class` or `mixin` declaration without a modifier to **allow unrestricted
access** to outside libraries. The standard behaviors apply:

- [Construct][] new instances of a class
- [Extend][] a class to create a new subtype
- [Implement][] a class's interface
- [Mix in][] a mixin or mixin class

## `base`

Use the `base` modifier to **disallow implementation** of a class or mixin.
A base class can be extended and constructed. This applies trasitively to all
subtypes, because implementing a subtype implements the supertype as well.  

{{site.alert.note}}
  Only the `base` modifier can accompany a mixin declaration. 
  - A `base mixin` can be mixed in, but not implemented.
  - A `base mixin class` can be constructed, extended, and mixed in, but not
  implemented.
{{site.alert.end}}

```dart
base class Vehicle {
  String make;
  String model;
  void moveForward(int meters) { … }
}

var myCar = Vehicle(     // Can be constructed
  make: 'Ford',
  model: 'T',
);

class Car extends     // Can be extended
  Vehicle {
    int passengers;
…
}

class MockVehicle     // ERROR: Cannot be implemented
  implements Vehicle {
    @override
    void moveForward …
}

```

Disallowing implementation makes `base` useful for:
- Preventing users of the API from overriding the constructor, for example, to
bypass its validation.
- Ensuring all private members are available to subtypes of the base class, and
and accessing them will never cause a [`noSuchMethod`][] error.

## `interface`

Use the `interface` modifier to **disallow extending a class**.
An interface class can be implemented and constructed.

```dart
interface class Vehicle {
  String make;
  String model;
  void moveForward(int meters) { … }
}

var myCar = Vehicle(     // Can be constructed
  make: 'Ford',
  model: 'T',
);

class Car extends     // ERROR: Cannot be inherited
  Vehicle {
    int passengers;
…
}

class MockVehicle     // Can be implemented     
  implements Vehicle {
    @override
    void moveForward …
}
```

Disallowing inheritance makes `interface` useful for:
- Defining API interfaces.
- Preventing users of the API from overriding a subset of methods.

## `final` 

Use the `final` modifier to **disallow extending _and_ implementing** a class.
Final classes can be constructed.

```dart
final class Vehicle {
  String make;
  String model;
  void moveForward(int meters) { … }
}

var myCar = Vehicle(     // Can be constructed
  make: 'Ford',
  model: 'T',
);

class Car extends     // ERROR: Cannot be inherited
  Vehicle {
    int passengers;
…
}

class MockVehicle     // ERROR: Cannot be implemented     
  implements Vehicle {
    @override
    void moveForward …
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
or implementated** outside of the library where the class is defined. 

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
  void moveForward(int meters) { … }
}

class Car extends Vehicle { }
class Truck implements Vehicle { }
class Bicycle extends Vehicle { }

// ...

return switch (vehicle) {     // ERROR: The switch is missing a subtype of Vehicle
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

The `mixin` declaration defines a [mixin][]. The `mixin` _modifier_ can only be
applied to a `class` declaration to create a _mixin class_: a class that can be
treated both as a class and a mixed in. Regular classes cannot be mixed in.

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