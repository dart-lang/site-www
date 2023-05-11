// ignore_for_file: invalid_use_of_type_outside_library
// Library b.dart
import 'a.dart';

// Can be constructed
Vehicle myCar = Vehicle();

// ERROR: Cannot be inherited
class Car extends Vehicle {
  int passengers = 4;
  // ...
}

class MockVehicle implements Vehicle {
  // Can be implemented
  @override
  void moveForward(int meters) {
    // ...
  }
}
