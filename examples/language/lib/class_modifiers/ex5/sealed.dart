// ignore_for_file: instantiate_abstract_class, non_exhaustive_switch_expression
sealed class Vehicle {}

class Car extends Vehicle {}

class Truck implements Vehicle {}

class Bicycle extends Vehicle {}

// ERROR: `Vehicle` can't be instantiated because
// it is marked `sealed` and therefore, implicitly abstract.
Vehicle myVehicle = Vehicle();

// Subclasses of a sealed class can be instantiated unless also restricted.
Vehicle myCar = Car();

extension VehicleSounds on Vehicle {
  String get sound {
    // ERROR: The switch does not exhaustively account for
    // all possible objects of type `Vehicle`.
    // In this example, a `Vehicle` with a run-time type of `Bicycle`
    // would not match any of the cases.
    return switch (this) {
      Car() => 'vroom',
      Truck() => 'VROOOOMM',
    };
  }
}
