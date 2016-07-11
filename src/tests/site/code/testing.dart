import 'package:unittest/unittest.dart';
import 'dart:math' show Point;

main() {
  Point a = new Point(2, 15);
  Point b = new Point(7, 3);

  test('point distances', () {
    expect(a.distanceTo(b), equals(13));
  });
  test('point magnitude close to', () {
    expect(a.magnitude, closeTo(15, .25));
  });
  test('point magnitude greater than', () {
    expect(a.magnitude, greaterThan(b.magnitude));
  });
  test('point == operator', () {
    expect(a == b, equals(false));
  });
}
