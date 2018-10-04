---
title: Sample Code
description: Examples of idiomatic Dart with links to larger examples.
---

This collection is not exhaustive&mdash;it's just a brief
introduction to the language for people who like to learn by example. You may
also want to check out the language and library tours.

<div class="card-grid">
  <div class="card">
    <h3><a href="/guides/language/language-tour">Language tour</a></h3>
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
{% prettify dart %}
void main() {
  print('Hello, World!');
}
{% endprettify %}


## Variables

Even in type-safe Dart code, most variables don't need explicit types,
thanks to type inference:

<?code-excerpt "misc/test/samples_test.dart (var)"?>
{% prettify dart %}
var name = 'Voyager I';
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg'
};
{% endprettify %}

[Read more](/guides/language/language-tour#variables) about variables in Dart, including default values, the `final` and `const` keywords, and static types.


## Control flow statements

Dart supports the usual control flow statements:

<?code-excerpt "misc/test/samples_test.dart (control-flow)"?>
{% prettify dart %}
if (year >= 2001) {
  print('21st century');
} else if (year >= 1901) {
  print('20th century');
}

for (var object in flybyObjects) {
  print(object);
}

for (int month = 1; month <= 12; month++) {
  print(month);
}

while (year < 2016) {
  year += 1;
}
{% endprettify %}

[Read more](/guides/language/language-tour#control-flow-statements) about control flow statements in Dart,
including `break` and `continue`, `switch` and `case`, and `assert`.


## Functions

[We recommend](/guides/language/effective-dart/design#types)
specifying the types of each function's arguments and return value:

<?code-excerpt "misc/test/samples_test.dart (functions)"?>
{% prettify dart %}
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
{% endprettify %}

A shorthand `=>` (_arrow_) syntax is handy for functions that
contain a single statement.
This syntax is especially useful when passing anonymous functions as arguments:

<?code-excerpt "misc/test/samples_test.dart (arrow)"?>
{% prettify dart %}
flybyObjects.where((name) => name.contains('turn')).forEach(print);
{% endprettify %}

Besides showing an anonymous function (the argument to `where()`),
this code shows that you can use a function as an argument:
the top-level `print()` function is an argument to `forEach()`.

[Read more](/guides/language/language-tour#functions) about functions in Dart,
including optional parameters, default parameter values, and lexical scope.


## Comments

Dart comments usually start with `//`.

{% prettify dart %}
// This is a normal, one-line comment.

/// This is a documentation comment, used to document libraries,
/// classes, and their members. Tools like IDEs and dartdoc treat
/// doc comments specially.

/* Comments like these are also supported. */
{% endprettify %}

[Read more](/guides/language/language-tour#comments) about comments in Dart,
including how the documentation tooling works.


## Imports

To access APIs defined in other libraries, use `import`.

<?code-excerpt "misc/test/samples_test.dart (import)" replace="/'.*?' as \w+/'path\/to\/my_other_file.dart'/g"?>
{% prettify dart %}
// Importing core libraries
import 'dart:async';
import 'dart:math';

// Importing libraries from external packages
import 'package:test/test.dart';

// Importing files
import 'path/to/my_other_file.dart';
import 'package:examples/samples/spacecraft.dart';
{% endprettify %}

[Read more](/guides/language/language-tour#libraries-and-visibility) about libraries and visibility in Dart,
including library prefixes, `show` and `hide`, and lazy loading through the `deferred` keyword.


## Classes

Here's an example of a class with three properties, two constructors,
and a method. One of the properties can't be set directly, so it's
defined using a getter method (instead of a variable).

{% comment %}
The linter rule sort_constructors_first made us put the getter below
the constructors: https://github.com/dart-lang/linter/issues/859.
{% endcomment %}

<?code-excerpt "misc/lib/samples/spacecraft.dart (class)"?>
{% prettify dart %}
class Spacecraft {
  String name;
  DateTime launchDate;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  int get launchYear =>
      launchDate?.year; // read-only non-final property

  // Method.
  void describe() {
    print('Spacecraft: $name');
    if (launchDate != null) {
      int years =
          DateTime.now().difference(launchDate).inDays ~/
              365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}
{% endprettify %}

You might use the `Spacecraft` class like this:

<?code-excerpt "misc/test/samples_test.dart (use class)" plaster="none"?>
{% prettify dart %}
var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
voyager.describe();

var voyager3 = Spacecraft.unlaunched('Voyager III');
voyager3.describe();
{% endprettify %}

[Read more](/guides/language/language-tour#classes) about classes in Dart,
including initializer lists, optional `new` and `const`, redirecting constructors,
`factory` constructors, getters, setters, and much more.


## Inheritance

Dart has single inheritance.

<?code-excerpt "misc/lib/samples/spacecraft.dart (extends)"?>
{% prettify dart %}
class Orbiter extends Spacecraft {
  num altitude;
  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
{% endprettify %}

[Read more](/guides/language/language-tour#extending-a-class) about extending classes, the optional `@override` annotation, and more.


## Mixins

Mixins are a way of reusing code in multiple class hierarchies. The following class can act as a mixin:

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin)"?>
{% prettify dart %}
class Piloted {
  int astronauts = 1;
  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
{% endprettify %}

To add a mixin's capabilities to a class, just extend the class with the mixin.

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin use)" replace="/with/[!$&!]/g"?>
{% prettify dart %}
class PilotedCraft extends Spacecraft [!with!] Piloted {
  // ···
}
{% endprettify %}

`Orbiter` now has the `astronauts` field as well as the `describeCrew()` method.

[Read more](/guides/language/language-tour#adding-features-to-a-class-mixins) about mixins.


## Interfaces and abstract classes

Dart has no `interface` keyword. Instead, all classes implicitly define an interface. Therefore, you can implement any class.

<?code-excerpt "misc/lib/samples/spacecraft.dart (implements)"?>
{% prettify dart %}
class MockSpaceship implements Spacecraft {
  // ···
}
{% endprettify %}

[Read more](/guides/language/language-tour#implicit-interfaces) about implicit interfaces.

You can create an abstract class to be extended (or implemented) by a concrete class. Abstract classes can contain abstract methods (with empty bodies).

<?code-excerpt "misc/lib/samples/spacecraft.dart (abstract)" replace="/abstract/[!$&!]/g"?>
{% prettify dart %}
[!abstract!] class Describable {
  void describe();

  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}
{% endprettify %}

Any class extending `Describable` has the `describeWithEmphasis()` method, which calls the extender's implementation of `describe()`.

[Read more](/guides/language/language-tour#abstract-classes) about abstract classes and methods.


## Async

Avoid callback hell and make your code much more readable by
using `async` and `await`.

<?code-excerpt "misc/test/samples_test.dart (async)" replace="/async/[!$&!]/g"?>
{% prettify dart %}
const oneSecond = Duration(seconds: 1);
// ···
Future<void> printWithDelay(String message) [!async!] {
  await Future.delayed(oneSecond);
  print(message);
}
{% endprettify %}

The method above is equivalent to:

<?code-excerpt "misc/test/samples_test.dart (Future.then)"?>
{% prettify dart %}
Future<void> printWithDelay(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}
{% endprettify %}

As the next example shows, `async` and `await` help make asynchronous code
easy to read.

<?code-excerpt "misc/test/samples_test.dart (await)"?>
{% prettify dart %}
Future<void> createDescriptions(Iterable<String> objects) async {
  for (var object in objects) {
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
{% endprettify %}

You can also use `async*`, which gives you a nice, readable way to build streams.

<?code-excerpt "misc/test/samples_test.dart (async*)"?>
{% prettify dart %}
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (var object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object';
  }
}
{% endprettify %}

[Read more](/guides/language/language-tour#asynchrony-support) about
asynchrony support, including async functions, `Future`, `Stream`,
and the asynchronous loop (`await for`).


## Exceptions

To raise an exception, use `throw`:

<?code-excerpt "misc/test/samples_test.dart (throw)"?>
{% prettify dart %}
if (astronauts == 0) {
  throw StateError('No astronauts.');
}
{% endprettify %}

To catch an exception, use a `try` statement with `on` or `catch` (or both):

<?code-excerpt "misc/test/samples_test.dart (try)"?>
{% prettify dart %}
try {
  for (var object in flybyObjects) {
    var description = await File('$object.txt').readAsString();
    print(description);
  }
} on IOException catch (e) {
  print('Could not describe object: $e');
} finally {
  flybyObjects.clear();
}
{% endprettify %}

Note that the code above is asynchronous;
`try` works for both synchronous code and code in an async function.

[Read more](/guides/language/language-tour#exceptions) about exceptions, including stack traces, `rethrow`, and the difference between
Error and Exception.


## Other topics

Many more code samples are in the
[Language Tour](/guides/language/language-tour) and the
[Library Tour](/guides/libraries/library-tour).
Also see the [API reference](https://api.dartlang.org),
which often contains examples.
