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
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
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

  Orbiter(super.name, DateTime super.launchDate, this.altitude);
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
  PilotedCraft(super.name, DateTime super.launchDate);
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
// #enddocregion abstract

// #docregion simple-enum
enum PlanetType { terrestrial, gas, ice }
// #enddocregion simple-enum

// #docregion enhanced-enum
/// Enum that enumerates the different planets in our solar system
/// and some of their properties.
enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // #enddocregion enhanced-enum
  earth(planetType: PlanetType.terrestrial, moons: 1, hasRings: false),
  mars(planetType: PlanetType.terrestrial, moons: 2, hasRings: false),
  jupiter(planetType: PlanetType.gas, moons: 80, hasRings: true),
  saturn(planetType: PlanetType.gas, moons: 83, hasRings: true),
  // #docregion enhanced-enum
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// A constant generating constructor
  const Planet(
      {required this.planetType, required this.moons, required this.hasRings});

  /// All instance variables are final
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enhanced enums support getters and other methods
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}
// #enddocregion enhanced-enum
