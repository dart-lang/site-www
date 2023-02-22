---
title: Language samples
description: Examples of idiomatic Dart with links to larger examples.
---

This collection is not exhaustive—it's just a brief
introduction to the language for people who like to learn by example.
You might also want to check out the language and library tours,
or the [Dart cheatsheet codelab](/codelabs/dart-cheatsheet).

<div class="card-grid no_toc_section">
  <div class="card">
    <h3><a href="/language/basics">Language tour</a></h3>
    <p>
      A comprehensive tour, with examples, of the Dart language.
      Most of the <em>read more</em> links in this page
      point to the language tour.
    </p>
  </div>
  <div class="card">
    <h3><a href="/guides/libraries/library-tour">Library tour</a></h3>
    <p>
      An example-based introduction to the Dart core libraries.
      See how to use the built-in types, collections,
      dates and times, streams, and more.
    </p>
  </div>
</div>


## Hello World

Every app has a `main()` function.
To display text on the console, you can use the top-level `print()` function:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Hello, World!');
}
```


## Variables

Even in type-safe Dart code, most variables don't need explicit types,
thanks to type inference:

<?code-excerpt "misc/test/samples_test.dart (var)"?>
```dart
var name = 'Voyager I';
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg'
};
```

[Read more](/language/variables) about variables in Dart, 
including default values, the `final` and `const` keywords, and static types.


## Control flow statements

Dart supports the usual control flow statements:

<?code-excerpt "misc/test/samples_test.dart (control-flow)"?>
```dart
if (year >= 2001) {
  print('21st century');
} else if (year >= 1901) {
  print('20th century');
}

for (final object in flybyObjects) {
  print(object);
}

for (int month = 1; month <= 12; month++) {
  print(month);
}

while (year < 2016) {
  year += 1;
}
```

[Read more](/language/control-flow) 
about control flow statements in Dart,
including `break` and `continue`, `switch` and `case`, and `assert`.


## Functions

[We recommend](/guides/language/effective-dart/design#types)
specifying the types of each function's arguments and return value:

<?code-excerpt "misc/test/samples_test.dart (functions)"?>
```dart
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
```

A shorthand `=>` (_arrow_) syntax is handy for functions that
contain a single statement.
This syntax is especially useful when passing anonymous functions as arguments:

<?code-excerpt "misc/test/samples_test.dart (arrow)"?>
```dart
flybyObjects.where((name) => name.contains('turn')).forEach(print);
```

Besides showing an anonymous function (the argument to `where()`),
this code shows that you can use a function as an argument:
the top-level `print()` function is an argument to `forEach()`.

[Read more](/language/functions) about functions in Dart,
including optional parameters, default parameter values, and lexical scope.


## Comments

Dart comments usually start with `//`.

```dart
// This is a normal, one-line comment.

/// This is a documentation comment, used to document libraries,
/// classes, and their members. Tools like IDEs and dartdoc treat
/// doc comments specially.

/* Comments like these are also supported. */
```

[Read more](/language/comments) about comments in Dart,
including how the documentation tooling works.


## Imports

To access APIs defined in other libraries, use `import`.

<?code-excerpt "misc/test/samples_test.dart (import)" plaster="none"?>
```
// Importing core libraries
import 'dart:math';

// Importing libraries from external packages
import 'package:test/test.dart';

// Importing files
import 'path/to/my_other_file.dart';
```

[Read more](/guides/libraries/visibility) 
about libraries and visibility in Dart,
including library prefixes, `show` and `hide`, 
and lazy loading through the `deferred` keyword.


## Classes

Here's an example of a class with three properties, two constructors,
and a method. One of the properties can't be set directly, so it's
defined using a getter method (instead of a variable).

<?code-excerpt "misc/lib/samples/spacecraft.dart (class)"?>
```dart
class Spacecraft {
  String name;
  DateTime? launchDate;

  // Read-only non-final property
  int? get launchYear => launchDate?.year;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print('Spacecraft: $name');
    // Type promotion doesn't work on getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}
```

You might use the `Spacecraft` class like this:

<?code-excerpt "misc/test/samples_test.dart (use class)" plaster="none"?>
```dart
var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
voyager.describe();

var voyager3 = Spacecraft.unlaunched('Voyager III');
voyager3.describe();
```

[Read more](/language/classes) about classes in Dart,
including initializer lists, optional `new` and `const`, redirecting constructors,
`factory` constructors, getters, setters, and much more.


## Enums

Enums are a way of enumerating a predefined set of values or instances
in a way which ensures that there cannot be any other instances of that type.

Here is an example of a simple `enum` that defines
a simple list of predefined planet types:

<?code-excerpt "misc/lib/samples/spacecraft.dart (simple-enum)"?>
```dart
enum PlanetType { terrestrial, gas, ice }
```

Here is an example of an enhanced enum declaration
of a class describing planets,
with a defined set of constant instances,
namely the planets of our own solar system.

<?code-excerpt "misc/lib/samples/spacecraft.dart (enhanced-enum)"?>
```dart
/// Enum that enumerates the different planets in our solar system
/// and some of their properties.
enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ···
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// A constant generating constructor
  const Planet(
      {required this.planetType, required this.moons, required this.hasRings});

  /// All instance variables are final
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enhanced enums support getters and other methods
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}
```

You might use the `Planet` enum like this:

<?code-excerpt "misc/test/samples_test.dart (use enum)" plaster="none"?>
```dart
final yourPlanet = Planet.earth;

if (!yourPlanet.isGiant) {
  print('Your planet is not a "giant planet".');
}
```

[Read more](/language/enum) about enums in Dart,
including enhanced enum requirements, automatically introduced properties,
accessing enumerated value names, switch statement support, and much more.


## Inheritance

Dart has single inheritance.

<?code-excerpt "misc/lib/samples/spacecraft.dart (extends)"?>
```dart
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(super.name, DateTime super.launchDate, this.altitude);
}
```

[Read more](/language/extend) 
about extending classes, the optional `@override` annotation, and more.


## Mixins

Mixins are a way of reusing code in multiple class hierarchies. The following is
a mixin declaration:

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin)"?>
```dart
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
```

To add a mixin's capabilities to a class, just extend the class with the mixin.

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin-use)" replace="/with/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class PilotedCraft extends Spacecraft [!with!] Piloted {
  // ···
}
{% endprettify %}

`PilotedCraft` now has the `astronauts` field as well as the `describeCrew()` method.

[Read more](/language/mixins) about mixins.


## Interfaces and abstract classes

Dart has no `interface` keyword. 
Instead, all classes implicitly define an interface. 
Therefore, you can implement any class.

<?code-excerpt "misc/lib/samples/spacecraft.dart (implements)"?>
```dart
class MockSpaceship implements Spacecraft {
  // ···
}
```

[Read more](/language/classes#implicit-interfaces) about implicit interfaces.

You can create an abstract class
to be extended (or implemented) by a concrete class. 
Abstract classes can contain abstract methods (with empty bodies).

<?code-excerpt "misc/lib/samples/spacecraft.dart (abstract)" replace="/abstract/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
[!abstract!] class Describable {
  void describe();

  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}
{% endprettify %}

Any class extending `Describable` has the `describeWithEmphasis()` method, 
which calls the extender's implementation of `describe()`.

[Read more](/language/classes#abstract-classes) 
about abstract classes and methods.


## Async

Avoid callback hell and make your code much more readable by
using `async` and `await`.

<?code-excerpt "misc/test/samples_test.dart (async)" replace="/async/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
const oneSecond = Duration(seconds: 1);
// ···
Future<void> printWithDelay(String message) [!async!] {
  await Future.delayed(oneSecond);
  print(message);
}
{% endprettify %}

The method above is equivalent to:

<?code-excerpt "misc/test/samples_test.dart (Future.then)"?>
```dart
Future<void> printWithDelay(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}
```

As the next example shows, `async` and `await` help make asynchronous code
easy to read.

<?code-excerpt "misc/test/samples_test.dart (await)"?>
```dart
Future<void> createDescriptions(Iterable<String> objects) async {
  for (final object in objects) {
    try {
      var file = File('$object.txt');
      if (await file.exists()) {
        var modified = await file.lastModified();
        print(
            'File for $object already exists. It was modified on $modified.');
        continue;
      }
      await file.create();
      await file.writeAsString('Start describing $object in this file.');
    } on IOException catch (e) {
      print('Cannot create description for $object: $e');
    }
  }
}
```

You can also use `async*`, which gives you a nice, readable way to build streams.

<?code-excerpt "misc/test/samples_test.dart (async*)"?>
```dart
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (final object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object';
  }
}
```

[Read more](/language/async) about
asynchrony support, including `async` functions, `Future`, `Stream`,
and the asynchronous loop (`await for`).


## Exceptions

To raise an exception, use `throw`:

<?code-excerpt "misc/test/samples_test.dart (throw)"?>
```dart
if (astronauts == 0) {
  throw StateError('No astronauts.');
}
```

To catch an exception, use a `try` statement with `on` or `catch` (or both):

<?code-excerpt "misc/test/samples_test.dart (try)" replace="/on.*e\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
Future<void> describeFlybyObjects(List<String> flybyObjects) async {
  try {
    for (final object in flybyObjects) {
      var description = await File('$object.txt').readAsString();
      print(description);
    }
  } [!on IOException catch (e)!] {
    print('Could not describe object: $e');
  } finally {
    flybyObjects.clear();
  }
}
{% endprettify %}

Note that the code above is asynchronous;
`try` works for both synchronous code and code in an `async` function.

[Read more](/language/error-handling#exceptions) about exceptions, 
including stack traces, `rethrow`, 
and the difference between `Error` and `Exception`.


## Other topics

Many more code samples are in the
[language tour](/language/basics) and the
[library tour](/guides/libraries/library-tour).
Also see the [Dart API reference,]({{site.dart-api}})
which often contains examples.
