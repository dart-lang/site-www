// ignore_for_file: invalid_override, invalid_use_of_type_outside_library
// Library b.dart
import 'a.dart';

Vehicle myCar = Vehicle(); // Can be constructed

// Can be extended
base class Car extends Vehicle {
  int passengers = 4;
  // ...
}

base class MockVehicle implements Vehicle {
  // ERROR: Cannot be implemented
  @override
  void moveForward() {
    // ...
  }
}
