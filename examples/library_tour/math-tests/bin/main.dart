import 'dart:math' as math;

void main() {
  trig();
  minmax();
  constants();
  random();
}

void trig() {
  // Cosine
  assert(math.cos(math.PI) == -1.0);

  // Sine
  var degrees = 30;
  var radians = degrees * (math.PI / 180);
  // radians is now 0.52359.
  var sinOf30degrees = math.sin(radians);
  // sin 30° = 0.5
  assert((sinOf30degrees - 0.5).abs() < 0.01);
}

void minmax() {
  assert(math.max(1, 1000) == 1000);
  assert(math.min(1, -1000) == -1000);
}

void constants() {
  // See the Math library for additional constants.
  print(math.E); // 2.718281828459045
  print(math.PI); // 3.141592653589793
  print(math.SQRT2); // 1.4142135623730951
}

void random() {
  var random = new math.Random();

  var nextDouble = random.nextDouble();
  assert(nextDouble >= 0.0 && nextDouble < 1.0); // [0, 1)

  var nextInt = random.nextInt(10);
  assert(nextInt >= 0 && nextInt < 10); // [0 .. 9]

  var nextBool = random.nextBool(); // true or false

  print('$nextDouble, $nextInt, $nextBool');
}
