// ignore_for_file: unused_local_variable

void main() {
  // #docregion
  const bar = 1000000; // Unit of pressure (dynes/cm2)
  const double atm = 1.01325 * bar; // Standard atmosphere
  // #enddocregion
  assert(atm > bar);
}
