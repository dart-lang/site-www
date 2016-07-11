---
title: "Sample Code"
description: "Examples of idiomatic Dart with links to larger examples."
permalink: /samples/
---

This collection is not exhaustive&mdash;it's just a brief
introduction to the language for people who like to learn by example. You may
also want to check out the following pages.

<div class="card-grid">
  <div class="card">
    <h3><a href="/guides/language/language-tour">Language Tour</a></h3>
    <p>
      Higher text-to-code ratio than here.
    </p>
  </div>
  <!-- XXXXX TODO: XXXXX
  <div class="card">
    <h3><a href="/DOES_NOT_EXIST_YET">End-to-end repositories</a></h3>
    <p>For those who like to see projects in their entirety.</p>
  </div>
  -->
  <div class="card">
    <h3><a href="/dart-vm/dart-by-example">Cookbook</a></h3>
    <p>
      A set of concrete 'recipes' to get you started with common programming
      tasks.
    </p>
  </div>
</div>

## Hello World

First things first:

{% prettify dart %}
void main() {
  print('Hello, World!');
}
{% endprettify %}

## Variables

We're not explicitly typing the variables here. We could, but type inference works for us.

{% prettify dart %}
var name = "Voyager I";
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ["Jupiter", "Saturn", "Uranus", "Neptune"];
var image = {
  "tags": ["saturn"],
  "url": "//path/to/saturn.jpg"
};
{% endprettify %}

[Read more](/guides/language/language-tour#variables) about variables in Dart, including default values, `final` and `const` keywords, and more.

## Control flow statements

No surprises here.

{% prettify dart %}
if (year >= 2001) {
  print("21st century");
} else if (year >= 1901) {
  print("20th century");
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

As a best practice, we're specifying the type of the function's argument and return value here. You don't need to do that, though.

{% prettify dart %}
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
{% endprettify %}

There is a shorthand ('fat arrow') syntax for functions that contain a single statement.
It's most useful when functions are passed as arguments (but it also means 'Hello World' can be made even [shorter](https://gist.github.com/filiph/8a5e3e845acdafe2ea928fd257a46859) than it already is).

{% prettify dart %}
flybyObjects.where((name) => name.contains("anus")).forEach(print);
{% endprettify %}

Also note that in the example above, the top-level function `print` is provided as an argument.

[Read more](/guides/language/language-tour#functions) about functions in Dart,
including optional parameters, default parameter values, lexical scope, and more.

## Comments

{% prettify dart %}
// A normal, one-line comment.

/// A documentation comment. These are used to document libraries, classes and
/// their members. IDEs and tools use these.

/* Comments like these are also supported. */
{% endprettify %}

[Read more](/guides/language/language-tour#comments) about comments in Dart,
including how the documentation tooling works.

## Imports

{% prettify dart %}
// Core libraries.
import 'dart:async';
import 'dart:math';

// Packages.
import 'package:angular2/angular2.dart';

// Files.
import 'path/to/my_other_file.dart';
{% endprettify %}

[Read more](/guides/language/language-tour#libraries-and-visibility) about libraries and visibility in Dart,
including library prefixes, `show` and `hide`, and lazy loading through the `deferred` keyword.

## Classes

{% prettify dart %}
class Spacecraft {
  String name;
  DateTime launchDate;
  int launchYear;

  // Constructor, including syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Pretend the following is something you'd actually want to run in
    // a constructor.
    launchYear = launchDate?.year;
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print("Spacecraft: $name");
    if (launchDate != null) {
      int years = new DateTime.now().difference(launchDate).inDays ~/ 365;
      print("Launched: $launchYear ($years years ago)");
    } else {
      print("Unlaunched");
    }
  }
}
{% endprettify %}

You would use the class defined above like so:

{% prettify dart %}
var voyager = new Spacecraft("Voyager I", new DateTime(1977, 9, 5));
voyager.describe();

var voyager3 = new Spacecraft.unlaunched("Voyager III");
voyager3.describe();
{% endprettify %}

[Read more](/guides/language/language-tour#classes) about classes in Dart,
including initializer lists, redirecting constructors, constant constructors, `factory` constructors, getters, setters, and much more.

## Inheritance

Dart has single-inheritance.

{% prettify dart %}
class Orbiter extends Spacecraft {
  num altitude;
  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
{% endprettify %}

[Read more](/guides/language/language-tour#extending-a-class) about extending classes, the optional `@override` annotation, and more.

## Mixins

Mixins are a way of reusing code in multiple class hierarchies. The following class can act as a mixin.

{% prettify dart %}
class Manned {
  int astronauts;
  void describeCrew() {
    print("Number of astronauts: $astronauts");
  }
}
{% endprettify %}

Just extend a class with this mixin to give it its capabilities.

{% prettify dart %}
class Orbiter extends Spacecraft with Manned {
  // ...
}
{% endprettify %}

`Orbiter` now has the `astronauts` field as well as the `describeCrew()` method.

[Read more](/articles/language/mixins) about mixins.

## Interfaces

There is no `interface` keyword in Dart. All classes implicitly define an interface. Therefore, you can `implement` any class.

{% prettify dart %}
class MockSpaceship implements Spacecraft {
  // ...
}
{% endprettify %}

[Read more](/guides/language/language-tour#implicit-interfaces) about implicit interfaces.

## Abstract classes

You can create an abstract class which is supposed to be extended (or implemented) by a concrete one. Abstract classes can contain abstract methods (with empty body).

{% prettify dart %}
abstract class Describable {
  void describe();

  void describeWithEmphasis() {
    print("=========");
    describe();
    print("=========");
  }
}
{% endprettify %}

Any class extending `Describable` will now have the `describeWithEmphasis()` method. It will call the implementation of `describe()` of that class.

[Read more](/guides/language/language-tour#abstract-classes) about abstract classes and methods.

## Async

You can avoid callback hell and make your code much more readable by using `async` and `await`.

{% prettify dart %}
Future<Null> printWithDelay(String message) async {
  await new Future.delayed(const Duration(seconds: 1));
  print(message);
}
{% endprettify %}

The code above is equivalent to:

{% prettify dart %}
Future<Null> printWithDelay(String message) {
  return new Future.delayed(const Duration(seconds: 1)).then((_) {
    print(message);
  });
}
{% endprettify %}

From the example above, `async` may not seem all that useful. Until you realize you can do things like the following.

{% prettify dart %}
Future<Null> createDescriptions(Iterable<String> objects) async {
  for (var object in objects) {
    try {
      var file = new File("$object.txt");
      if (await file.exists()) {
        var modified = await file.lastModified();
        print("File for $object already exists. It was modified on $modified");
        continue;
      }
      await file.create();
      await file.writeAsString("Start describing $object in this file.");
    } on IOException catch (e) {
      print("Cannot create description for $object: $e");
    }
  }
}
{% endprettify %}

You can also use `async*`, which gives you a nice, readable way to build steams.

{% prettify dart %}
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (var object in objects) {
    await new Future.delayed(const Duration(seconds: 1));
    yield "${craft.name} flies by $object";
  }
}
{% endprettify %}

[Read more](/guides/language/language-tour#asynchrony-support) about asynchrony support, including async functions, `Future`, `Stream`, the asynchronous loop (`await for`), and much more.

## Exceptions

{% prettify dart %}
if (astronauts == 0) {
  throw new StateError("No astronauts.");
}
{% endprettify %}

Exceptions can be caught. And this works even with asynchronous code.

{% prettify dart %}
try {
  for (var object in flybyObjects) {
    var description = await new File("$object.txt").readAsString();
    print(description);
  }
} on IOException catch (e) {
  print('Could not describe object: $e');
} finally {
  flybyObjects.clear();
}
{% endprettify %}

[Read more](/guides/language/language-tour#exceptions) about exceptions, including information about the distinction between Error and Exception, stack traces, `rethrow`, and more.

### Getters and setters

Getters and setters are special methods that appear like properties. We could rewrite the `launchYear` property of the `Spacecraft` class like so:

{% prettify dart %}
class Spacecraft {
  // ...
  DateTime launchDate;
  int get launchYear => launchDate?.year;
  // ...
}
{% endprettify %}

Users of the class access the property like they normally would (`spacecraft.launchYear`). The fact that it's a method is transparent to them.

[Read more](/guides/language/language-tour#getters-and-setters) about getters and their counterpart, setters.

## Other topics

There are many more code samples in the [Language Tour](/guides/language/language-tour) and the [Library Tour](/guides/libraries/library-tour).
Libraries provide examples of use in their [API documentation.](https://api.dartlang.org/)
