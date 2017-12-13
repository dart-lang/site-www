// #docregion class
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
    print('Spacecraft: $name');
    if (launchDate != null) {
      int years = new DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}
// #enddocregion class

// #docregion extends
class Orbiter extends Spacecraft {
  num altitude;
  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
// #enddocregion extends

// #docregion mixin
class Piloted {
  int astronauts = 1;
  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
// #enddocregion mixin

// #docregion mixin-use
class PilotedCraft extends Spacecraft with Piloted {
  // #enddocregion mixin-use
  PilotedCraft(name, launchDate) : super(name, launchDate);
  // #docregion mixin-use
}
// #enddocregion mixin-use

// #docregion implements
class MockSpaceship implements Spacecraft {
  // #enddocregion implements
  MockSpaceship(this.name);

  @override
  DateTime launchDate;

  @override
  int launchYear;

  @override
  String name;

  @override
  void describe() => name;
  // #docregion implements
}
// #enddocregion implements

// #docregion abstract
abstract class Describable {
  void describe();

  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}
// #enddocregion abstract

// #docregion get
class SpacecraftShowingGetter {
  // ...
  DateTime launchDate;
  int get launchYear => launchDate?.year;
  // ...
}
