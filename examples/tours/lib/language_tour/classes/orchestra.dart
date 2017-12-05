// #docregion Musical
abstract class Musical {
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

void main() {
  var director = new Maestro('Allen');
  director.entertainMe(); // Waving hands

  var musician = new Musician('Kathy');
  musician.canPlayPiano = true;
  musician.entertainMe(); // Playing piano
}
