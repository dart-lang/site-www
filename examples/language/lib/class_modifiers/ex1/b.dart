// ignore_for_file: invalid_use_of_type_outside_library, instantiate_abstract_class

// #docregion
// Library b.dart
import 'a.dart';

// Error: Cannot be constructed
Vehicle myVehicle = Vehicle();

// Can be extended
class Car extends Vehicle {
  int passengers = 4;
  // #enddocregion
  @override
  void moveForward(int meters) {
    // ...
  }
  // #docregion
}

// Can be implemented
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
// #enddocregion
