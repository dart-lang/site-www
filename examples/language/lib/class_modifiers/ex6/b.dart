// ignore_for_file: invalid_use_of_type_outside_library, instantiate_abstract_class
import 'a.dart';

// ERROR: `Vehicle` can't be instantiated because
// it is marked as `abstract`.
Vehicle myVehicle = Vehicle();

// ERROR: `Vehicle` can't be extended in a different library because
// it is marked with `interface`.
class Car extends Vehicle {
  int passengers = 4;

  @override
  void moveForward(int meters) {
    // ...
  }
}

// Can be implemented.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
