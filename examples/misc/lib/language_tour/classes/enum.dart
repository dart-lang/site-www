// #docregion enum
enum Color { red, green, blue }
// #enddocregion enum

void main() {
  // #docregion access
  final favoriteColor = Color.blue;
  if (favoriteColor == Color.blue) {
    print('Your favorite color is blue!');
  }
  // #enddocregion access

  // #docregion index
  assert(Color.red.index == 0);
  assert(Color.green.index == 1);
  assert(Color.blue.index == 2);
  // #enddocregion index
  assert(Color.blue.toString() == 'Color.blue');

  // #docregion values
  List<Color> colors = Color.values;
  assert(colors[2] == Color.blue);
  // #enddocregion values

  // #docregion switch
  var aColor = Color.blue;

  switch (aColor) {
    case Color.red:
      print('Red as roses!');
    case Color.green:
      print('Green as grass!');
    default: // Without this, you see a WARNING.
      print(aColor); // 'Color.blue'
  }
  // #enddocregion switch

  // #docregion name
  print(Color.blue.name); // 'blue'
  // #enddocregion name

  // #docregion method-call
  print(Vehicle.car.carbonFootprint);
  // #enddocregion method-call
}

// #docregion enhanced
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
// #enddocregion enhanced
