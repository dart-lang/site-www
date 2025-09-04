// ignore_for_file: invalid_override, invalid_use_of_type_outside_library
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// Can be extended.
base class Car extends Vehicle {
  int passengers = 4;
  // ...
}

// ERROR: `Vehicle` can't be implemented in a different library because
// it is marked with `base`.
base class MockVehicle implements Vehicle {
  @override
  void moveForward() {
    // ...
  }
}
