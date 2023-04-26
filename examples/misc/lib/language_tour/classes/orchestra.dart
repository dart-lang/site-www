// #docregion Musical
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
// #enddocregion Musical

mixin Aggressive {
  bool passive = false;
}

mixin Demented {
  bool dangerous = false;
}

class Person {
  String? name;
  Person();
  Person.withName(this.name);
}

abstract class Performer {
  Performer(String name);
  String? name;
}

// #docregion Musician-and-Maestro
class Musician extends Performer with Musical {
  // #enddocregion Musician-and-Maestro
  Musician(super.name);
  // #docregion Musician-and-Maestro
}

class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
// #enddocregion Musician-and-Maestro

// Musician2 was a workaround for https://github.com/dart-lang/sdk/issues/35011,
// which has been marked as fixed.

class Musician2 extends Performer with Musical {
  Musician2() : super('Anonymous');
  Musician2.withName(super.name);
}

// Simple version of Musician for the mixin example.
/*
// #docregion mixin-on
class Musician {
  // ...
}
// #enddocregion mixin-on
*/

// #docregion mixin-on
mixin MusicalPerformer on Musician2 {
  // ...
  // #enddocregion mixin-on
  bool canDance = true;

  @override
  void entertainMe() => canDance ? dance() : super.entertainMe();

  void dance() => print('Dancing');
  // #docregion mixin-on
}
// #enddocregion mixin-on

// #docregion mixin-on
class SingerDancer extends Musician2 with MusicalPerformer {
  // ...
  // #enddocregion mixin-on
  SingerDancer(super.name) : super.withName();
// #docregion mixin-on
}
// #enddocregion mixin-on

void main() {
  var director = Maestro('Allen');
  director.entertainMe(); // Waving hands

  var musician = Musician('Kathy');
  musician.canPlayPiano = true;
  musician.entertainMe(); // Playing piano

  var singerDancer = SingerDancer('Todd');
  singerDancer.entertainMe(); // Dancing
}
