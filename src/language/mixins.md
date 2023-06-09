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
names. The following example shows two classes that use mixins:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (Musician and Maestro)" replace="/(with.*) \{/[!$1!] {/g"?>
{% prettify dart tag=pre+code %}
class Musician extends Performer [!with Musical!] {
  // ···
}

class Maestro extends Person [!with Musical, Aggressive, Demented!] {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
{% endprettify %}

To define a mixin, use the `mixin` declaration. 
In the rare case where you need to define both a mixin _and_ a class, you can use
the [`mixin class` declaration](#class-mixin-or-mixin-class).

Mixins and mixin classes cannot have an `extends` clause,
and must not declare any generative constructors.

For example:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (Musical)"?>
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

Sometimes you might want to restrict the types that can use a mixin.
For example, the mixin might depend on being able to invoke a method
that the mixin doesn't define.
As the following example shows, you can restrict a mixin's use
by using the `on` keyword to specify the required superclass:

<?code-excerpt "misc/lib/language_tour/classes/orchestra.dart (mixin-on)" plaster="none" replace="/on Musician2/[!on Musician!]/g" ?>
```dart
class Musician {
  // ...
}
mixin MusicalPerformer [!on Musician!] {
  // ...
}
class SingerDancer extends Musician with MusicalPerformer {
  // ...
}
```

In the preceding code,
only classes that extend or implement the `Musician` class
can use the mixin `MusicalPerformer`.
Because `SingerDancer` extends `Musician`,
`SingerDancer` can mix in `MusicalPerformer`.

## `class`, `mixin`, or `mixin class`?

{{site.alert.version-note}}
  The `mixin class` declaration requires a [language version][] of at least 3.0.
{{site.alert.end}}

A `mixin` declaration defines a mixin. A `class` declaration defines a [class][].
A `mixin class` declaration defines a class that is usable as both a regular class
and a mixin, with the same name and the same type.

Any restrictions that apply to classes or mixins also apply to mixin classes:

- Mixins can't have `extends` or `with` clauses, so neither can a `mixin class`.
- Classes can't have an `on` clause, so neither can a `mixin class`. 

### `abstract mixin class`

You can achieve similar behavior to the `on` directive for a mixin class. 
Make the mixin class `abstract` and define the abstract methods its behavior 
depends on:

```dart
abstract mixin class Musician {
  // No 'on' clause, but an abstract method that other types must define if 
  // they want to use (mix in or extend) Musician: 
  void playInstrument(String instrumentName);

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician { // Use Musician as a mixin
  void playInstrument(String instrumentName) {
    print('Plays the $instrumentName beautifully');
  }  
} 

class Novice extends Musician { // Use Musician as a class
  void playInstrument(String instrumentName) {
    print('Plays the $instrumentName poorly');
  }  
} 
```

By declaring the `Musician` mixin as abstract, you force any type that uses
it to define the abstract method upon which its behavior depends. 

This is similar to how the `on` directive ensures a mixin has access to any
interfaces it depends on by specifying the superclass of that interface.

[language version]: /guides/language/evolution#language-versioning
[class]: /language/classes
[class modifiers]: /language/class-modifiers
