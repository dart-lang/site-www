// ignore_for_file: invalid_use_of_type_outside_library
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// ERROR: Can't be inherited.
class Car extends Vehicle {
  int passengers = 4;
  // ...
}

class MockVehicle implements Vehicle {
  // ERROR: Can't be implemented.
  @override
  void moveForward(int meters) {
    // ...
  }
}
