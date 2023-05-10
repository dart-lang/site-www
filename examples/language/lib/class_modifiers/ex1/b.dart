// ignore_for_file: invalid_use_of_type_outside_library,invalid_override,type_annotate_public_apis

// Library b.dart
import 'a.dart';

var myCar = Vehicle(); // Error: Cannot be constructed

base class Car extends Vehicle {
  // Can be extended
  int passengers = 4;
  // ...
}

base class MockVehicle implements Vehicle {
  // Can be implemented
  @override
  void moveForward(int meters) {
    //...
  }
}
