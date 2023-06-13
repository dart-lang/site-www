---
title: Enumerated types
description: Learn about the enum type in Dart.
short-title: Enums
prevpage:
  url: /language/mixins
  title: Mixins
nextpage:
  url: /language/extension-methods
  title: Extension methods
---

Enumerated types, often called _enumerations_ or _enums_,
are a special kind of class used to represent
a fixed number of constant values.

{{site.alert.note}}
  All enums automatically extend the [`Enum`][] class.
  They are also sealed,
  meaning they cannot be subclassed, implemented, mixed in,
  or otherwise explicitly instantiated.

  Abstract classes and mixins can explicitly implement or extend `Enum`,
  but unless they are then implemented by or mixed into an enum declaration,
  no objects can actually implement the type of that class or mixin.
{{site.alert.end}}

## Declaring simple enums

To declare a simple enumerated type,
use the `enum` keyword and
list the values you want to be enumerated:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (enum)"?>
```dart
enum Color { red, green, blue }
```

{{site.alert.tip}}
  You can also use [trailing commas][] when declaring an enumerated type
  to help prevent copy-paste errors.
{{site.alert.end}}

## Declaring enhanced enums

Dart also allows enum declarations to declare classes
with fields, methods, and const constructors
which are limited to a fixed number of known constant instances.

To declare an enhanced enum,
follow a syntax similar to normal [classes][],
but with a few extra requirements:

* Instance variables must be `final`,
  including those added by [mixins][].
* All [generative constructors][] must be constant.
* [Factory constructors][] can only return
  one of the fixed, known enum instances.
* No other class can be extended as [`Enum`] is automatically extended.
* There cannot be overrides for `index`, `hashCode`, the equality operator `==`.
* A member named `values` cannot be declared in an enum,
  as it would conflict with the automatically generated static `values` getter.
* All instances of the enum must be declared
  in the beginning of the declaration,
  and there must be at least one instance declared.

Instance methods in an enhanced enum can use `this` to
reference the current enum value.

Here is an example that declares an enhanced enum
with multiple instances, instance variables,
getters, and an implemented interface:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (enhanced)"?>
```dart
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

{{site.alert.version-note}}
  Enhanced enums require a [language version][] of at least 2.17.
{{site.alert.end}}

## Using enums

Access the enumerated values like
any other [static variable][]:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (access)"?>
```dart
final favoriteColor = Color.blue;
if (favoriteColor == Color.blue) {
  print('Your favorite color is blue!');
}
```

Each value in an enum has an `index` getter,
which returns the zero-based position of the value in the enum declaration.
For example, the first value has index 0,
and the second value has index 1.

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (index)"?>
```dart
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

To get a list of all the enumerated values,
use the enum's `values` constant.

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (values)"?>
```dart
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

You can use enums in [switch statements][], and
you'll get a warning if you don't handle all of the enum's values:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (switch)"?>
```dart
var aColor = Color.blue;

switch (aColor) {
  case Color.red:
    print('Red as roses!');
  case Color.green:
    print('Green as grass!');
  default: // Without this, you see a WARNING.
    print(aColor); // 'Color.blue'
}
```

If you need to access the name of an enumerated value,
such as `'blue'` from `Color.blue`,
use the `.name` property:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (name)"?>
```dart
print(Color.blue.name); // 'blue'
```

You can access a member of an enum value
like you would on a normal object:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (method-call)"?>
```dart
print(Vehicle.car.carbonFootprint);
```

[`Enum`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Enum-class.html
[trailing commas]: /language/collections#lists
[classes]: /language/classes
[mixins]: /language/mixins
[generative constructors]: /language/constructors#constant-constructors
[Factory constructors]: /language/constructors#factory-constructors
[language version]: /guides/language/evolution#language-versioning
[static variable]: /language/classes#class-variables-and-methods
[switch statements]: /language/branches#switch
