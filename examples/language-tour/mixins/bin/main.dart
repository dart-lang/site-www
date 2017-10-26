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

class Musician extends Performer with Musical {
  Musician(String name) : super(name);
}

class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}

void main() {
  var director = new Maestro('Allen');
  director.entertainMe(); // Waving hands

  var musician = new Musician('Kathy');
  musician.canPlayPiano = true;
  musician.entertainMe(); // Playing piano
}
