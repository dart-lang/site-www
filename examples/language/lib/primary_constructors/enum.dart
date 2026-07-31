// #docregion enhanced-primary
enum Vehicle(
  final int tires,
  final int passengers,
  final int carbonPerKilometer,
) implements Comparable<Vehicle> {
  car(4, 5, 400),
  bus(6, 50, 800),
  bicycle(2, 1, 0);

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
// #enddocregion enhanced-primary
