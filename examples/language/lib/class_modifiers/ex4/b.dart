// ignore_for_file: invalid_use_of_type_outside_library
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// ERROR: `Vehicle` can't be extended in a different library
// because it is marked `final`.
class Car extends Vehicle {
  int passengers = 4;
  // ...
}

// ERROR: `Vehicle` can't be implemented in a different library because
// it is marked `final`.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
