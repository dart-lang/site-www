// ignore_for_file: sort_constructors_first

int calculate() => 3;

// #docregion late_field
class IntProvider {
  late int aRealInt;

  IntProvider() {
    aRealInt = calculate();
  }
}
// #enddocregion late_field
