// #docregion class
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
      int years =
          DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}
// #enddocregion class

// #docregion extends
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
// #enddocregion extends

// #docregion mixin
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
// #enddocregion mixin

// #docregion mixin-use
class PilotedCraft extends Spacecraft with Piloted {
  // #enddocregion mixin-use
  PilotedCraft(String name, DateTime launchDate)
      : super(name, launchDate);
  // #docregion mixin-use
}
// #enddocregion mixin-use

// #docregion implements
class MockSpaceship implements Spacecraft {
  // #enddocregion implements
  MockSpaceship(this.name);

  @override
  DateTime? launchDate = DateTime(1969, 7, 16);

  @override
  int? get launchYear => launchDate?.year;

  @override
  String name;

  @override
  void describe() => print(name);
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
