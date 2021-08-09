// ignore_for_file: unused_local_variable

import 'package:examples/cheatsheet/factory_constructors.dart';
import 'package:examples/cheatsheet/initializer_lists.dart';
import 'package:examples/cheatsheet/named_constructor.dart';
import 'package:examples/cheatsheet/redirecting_constructors.dart';
import 'package:examples/cheatsheet/this_constructor.dart';
import 'package:test/test.dart';

void main() {
  test('this_constructor_required_positional', () {
    final color = MyColor(32, 64, 255);

    expect(color.red, equals(32));
    expect(color.green, equals(64));
    expect(color.blue, equals(255));
  });

  test('this_constructor_required_named', () {
    final color = MyColorRN(red: 32, green: 64, blue: 255);

    expect(color.red, equals(32));
    expect(color.green, equals(64));
    expect(color.blue, equals(255));
  });

  test('this_constructor_optional_positional_passed', () {
    final color = MyColorO.positional(32, 64, 255);

    expect(color.red, equals(32));
    expect(color.green, equals(64));
    expect(color.blue, equals(255));
  });

  test('this_constructor_optional_positional_not_passed', () {
    final color = MyColorO.positional();

    expect(color.red, equals(0));
    expect(color.green, equals(0));
    expect(color.blue, equals(0));
  });

  test('this_constructor_required_named_passed', () {
    final color = MyColorO.named(red: 32, green: 64, blue: 255);

    expect(color.red, equals(32));
    expect(color.green, equals(64));
    expect(color.blue, equals(255));
  });

  test('this_constructor_required_named_not_passed', () {
    final color = MyColorO.named();

    expect(color.red, equals(0));
    expect(color.green, equals(0));
    expect(color.blue, equals(0));
  });

  test('initializer_lists_assert_success', () {
    expect(() {
      final point = NonNegativePoint(100, 100);
    }, prints(contains('I just made a NonNegativePoint')));
  });

  test('initializer_lists_assert_fails', () {
    expect(() {
      final point = NonNegativePoint(-50, 100);
    }, throwsA(isA<AssertionError>()));

    expect(() {
      final point = NonNegativePoint(100, -50);
    }, throwsA(isA<AssertionError>()));
  });

  test('named_constructor_point_origin', () {
    // #docregion origin-point
    final myPoint = Point.origin();
    // #enddocregion origin-point

    expect(myPoint.x, equals(0));
    expect(myPoint.y, equals(0));
  });

  test('factory_constructor_shapes', () {
    expect(Shape(), isA<Shape>());
    expect(Shape.fromTypeName('square'), isA<Square>());
    expect(Shape.fromTypeName('circle'), isA<Circle>());
    expect(() {
      Shape.fromTypeName('trapezoid');
    }, throwsArgumentError);
  });

  test('redirecting_constructors', () {
    final hybrid = Automobile.hybrid('Dash', 'Null Safety');
    expect(hybrid.make, equals('Dash'));
    expect(hybrid.model, equals('Null Safety'));
    expect(hybrid.mpg, equals(60));

    final fancyHybrid = Automobile.fancyHybrid();
    expect(fancyHybrid.make, equals('Futurecar'));
    expect(fancyHybrid.model, equals('Mark 2'));
    expect(fancyHybrid.mpg, equals(60));
  });

  test('redirecting_const_constructors', () {
    final normal = ImmutablePoint(64, 255);
    expect(normal.x, equals(64));
    expect(normal.y, equals(255));

    final origin = ImmutablePoint.origin;
    expect(origin.x, equals(0));
    expect(origin.y, equals(0));
  });
}
