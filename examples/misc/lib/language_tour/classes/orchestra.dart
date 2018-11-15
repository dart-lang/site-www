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

abstract class Aggressive {
  bool passive = false;
}

abstract class Demented {
  bool dangerous = false;
}

class Person {
  String name;
  Person();
  Person.withName(this.name);
}

abstract class Performer {
  Performer(String name);
  String name;
}

// #docregion Musician-and-Maestro
class Musician extends Performer with Musical {
  // #enddocregion Musician-and-Maestro
  Musician(String name) : super(name);
  // #docregion Musician-and-Maestro
}

class Maestro extends Person
    with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
// #enddocregion Musician-and-Maestro

// #docregion mixin-on
mixin MusicalPerformer on Musician {
  // #enddocregion mixin-on
  bool canDance = true;

  @override
  void entertainMe() =>
      canDance ? dance() : super.entertainMe();

  void dance() => print('Dancing');
  // #docregion mixin-on
}
// #enddocregion mixin-on

class SingerDancer extends Musician with MusicalPerformer {
  SingerDancer(String name) : super(name);
}

void main() {
  var director = Maestro('Allen');
  director.entertainMe(); // Waving hands

  var musician = Musician('Kathy');
  musician.canPlayPiano = true;
  musician.entertainMe(); // Playing piano

  var singerDancer = SingerDancer('Todd');
  singerDancer.entertainMe(); // Dancing
}
