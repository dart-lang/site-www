import 'package:test/test.dart';

// #docregion calculate
int calculate() {
  return 6 * 7 ~/ 2;
}
// #enddocregion calculate

void main() {
  test('calculate update', () {
    expect(calculate(), 21);
  });
}
