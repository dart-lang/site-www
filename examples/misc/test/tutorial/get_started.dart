import 'package:test/test.dart';

// #docregion calculate
int calculate() {
  return 6 * 7 ~/ 2;
}
// #enddocregion calculate

void main() {
  test('updated calculate function', () {
    expect(calculate(), 21);
  });
}
