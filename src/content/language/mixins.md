---
title: Mixins
description: Learn how to add to features to a class in Dart.
toc: false
prevpage:
  url: /language/extend
  title: Extend a class
nextpage:
  url: /language/enums
  title: Enums
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Mixins are a way of defining code that can be reused in multiple class hierarchies.
They are intended to provide member implementations en masse. 

To use a mixin, use the `with` keyword followed by one or more mixin
names. The following example shows two classes that use (or, are subclasses of)
mixins:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (musician-and-maestro)" replace="/(with.*) \{/[!$1!] {/g"?>
```dart
class Musician extends Performer [!with Musical!] {
  // ···
}

class Maestro extends Person [!with Musical, Aggressive, Demented!] {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

To define a mixin, use the `mixin` declaration. 
In the rare case where you need to define both a mixin _and_ a class, you can use
the [`mixin class` declaration](#class-mixin-or-mixin-class).

Mixins and mixin classes cannot have an `extends` clause,
and must not declare any generative constructors.

For example:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (musical)"?>
```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

## Specify members a mixin can call on itself

Sometimes a mixin depends on being able to invoke a method or access fields,
but can't define those members itself (because mixins can't use constructor
parameters to instantiate their own fields).

The following sections cover different strategies for ensuring any subclass
of a mixin defines any members the mixin's behavior depends on. 

### Define abstract members in the mixin

Declaring an abstract method in a mixin forces any type that uses
the mixin to define the abstract method upon which its behavior depends. 

```dart
mixin Musician {
  void playInstrument(String instrumentName); // Abstract method.

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician { 
  void playInstrument(String instrumentName) { // Subclass must define.
    print('Plays the $instrumentName beautifully');
  }  
} 
```

#### Access state in the mixin's subclass

Declaring abstract memebers also allows you to access state on the subclass
of a mixin, by calling getters which are defined as abstract on the mixin:

```dart
/// Can be applied to any type with a [name] property and provides an
/// implementation of [hashCode] and operator `==` in terms of it.
mixin NameIdentity {
  String get name;

  int get hashCode => name.hashCode;
  bool operator ==(other) => other is NameIdentity && name == other.name;
}

class Person with NameIdentity {
  final String name;

  Person(this.name);
}
```

### Implement an interface

Similar to declaring the mixin abstract, putting an `implements` clause on the
mixin while not actually implementing the interface will also ensure any member
dependencies are defined for the mixin.

```dart
abstract interface class Tuner {
  void tuneInstrument();
}

mixin Guitarist implements Tuner {
  void playSong() {
    tuneInstrument();

    print('Strums guitar majestically.');
  }
}

class PunkRocker with Guitarist {
  void tuneInstrument() {
    print("Don't bother, being out of tune is punk rock.");
  }
}
```

### Use the `on` clause to declare a superclass

The `on` clause exists to define the type that `super` calls are resolved against.
So, you should only use it if you need to have a `super` call inside a mixin. 

The `on` clause forces any class that uses a mixin to also be a subclass
of the type in the `on` clause.
If the mixin depends on members in the superclass,
this ensures those members are available where the mixin is used:

```dart
class Musician {
  musicianMethod() {
    print('Playing music!');
  }
}

mixin MusicalPerformer [!on Musician!] {
  perfomerMethod() {
    print('Performing music!');
    super.musicianMethod();
  }
}

class SingerDancer extends Musician with MusicalPerformer { }

main() {
  SingerDance().performerMethod();
}
```

In this example, only classes that extend or implement the `Musician` class
can use the mixin `MusicalPerformer`. Because `SingerDancer` extends `Musician`,
`SingerDancer` can mix in `MusicalPerformer`.

## `class`, `mixin`, or `mixin class`?

:::version-note
The `mixin class` declaration requires a [language version][] of at least 3.0.
:::

A `mixin` declaration defines a mixin. A `class` declaration defines a [class][].
A `mixin class` declaration defines a class that is usable as both a regular class
and a mixin, with the same name and the same type.

```dart
mixin class Musician {
  // ...
}

class Novice with Musician { // Use Musician as a mixin
  // ...
}

class Novice extends Musician { // Use Musician as a class
  // ...
}
```

Any restrictions that apply to classes or mixins also apply to mixin classes:

- Mixins can't have `extends` or `with` clauses, so neither can a `mixin class`.
- Classes can't have an `on` clause, so neither can a `mixin class`.

[language version]: /guides/language/evolution#language-versioning
[class]: /language/classes
[class modifiers]: /language/class-modifiers
