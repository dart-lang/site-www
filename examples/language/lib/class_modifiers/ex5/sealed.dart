// ignore_for_file: instantiate_abstract_class,non_exhaustive_switch_expression

sealed class Vehicle { 
  void moveForward(int meters) { 
    //... 
  } 
}

class Car extends Vehicle { 
  @override
  void moveForward(int meters) {}}
class Truck implements Vehicle { 
  @override
  void moveForward(int meters) {}
}
class Bicycle extends Vehicle { 
  @override
  void moveForward(int meters) {}
}

Vehicle vehicle = Vehicle();  // ERROR: Cannot be instantiated
Vehicle anotherVehicle = Car();      // Subclasses can be instantiated

String getVehicleSound(Vehicle vehicle) {
  // ERROR: The switch is missing the Bicycle subtype or a default case.
  return switch (vehicle) {
    Car() => 'vroom',
    Truck() => 'VROOOOMM',
  };
}
