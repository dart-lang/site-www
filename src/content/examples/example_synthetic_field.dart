// example_synthetic_field.dart
import 'dart:math';

class ExampleSyntheticField {
  double angle = 0.0;

  static double _canonicalize(double x) {
    if (x >= 0.0) {
      return x.remainder(2.0 * pi);
    } else {
      return 2 * pi + x.remainder(2.0 * pi);
    }
  }

  double get opposite => _canonicalize(angle + pi);
  set opposite(double x) => angle = _canonicalize(x - pi);
}

void main() {
  final obj = ExampleSyntheticField();

  obj.angle = 0.5 * pi;
  print("The opposite of ${obj.angle / pi} π is ${obj.opposite / pi} π");

  obj.opposite = 0.5 * pi;
  print(
      "If the opposite is ${obj.opposite / pi} π, the angle is ${obj.angle / pi} π");

  obj.opposite += 0.25 * pi;
  print(
      "If the opposite is ${obj.opposite / pi} π, the angle is ${obj.angle / pi} π");
}
