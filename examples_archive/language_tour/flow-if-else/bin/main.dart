class Person {
  void bringRainCoat() {}
  void wearJacket() {}
}

class Vehicle {
  void putTopDown() {}
}

bool isRaining() {
  return false;
}

bool isSnowing() {
  return false;
}

void main() {
  var you = new Person();
  var car = new Vehicle();

  // #docregion
  if (isRaining()) {
    you.bringRainCoat();
  } else if (isSnowing()) {
    you.wearJacket();
  } else {
    car.putTopDown();
  }
  // #enddocregion
}
