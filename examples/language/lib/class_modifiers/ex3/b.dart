// ignore_for_file: invalid_use_of_type_outside_library

// Library b.dart
import 'a.dart';

Vehicle myCar = Vehicle(); // Can be constructed

class Car extends Vehicle {
  // ERROR: Cannot be inherited
  int passengers = 4;
  // ...
}

class MockVehicle implements Vehicle {
  // Can be implemented
  @override
  void moveForward(int meters) {
    //...
  }
}
