// ignore_for_file: unused_local_variable
import 'package:test/test.dart';
import 'package:examples/language_tour/classes/employee.dart' as employee;
import 'package:examples/language_tour/classes/enum.dart' as enum_with_main;
import 'package:examples/language_tour/classes/immutable_point.dart';
import 'package:examples/language_tour/classes/impostor.dart' as impostor;
import 'package:examples/language_tour/classes/logger.dart' as logger_with_main;
import 'package:examples/language_tour/classes/misc.dart' as misc;
import 'package:examples/language_tour/classes/no_such_method.dart'
    as no_such_method;
import 'package:examples/language_tour/classes/orchestra.dart' as orchestra;
import 'package:examples/language_tour/classes/point.dart';
import 'package:examples/language_tour/classes/point_redirecting.dart'
    as point_redirecting;
import 'package:examples/language_tour/classes/point_with_distance_field.dart'
    as point_with_distance_field;
import 'package:examples/language_tour/classes/point_with_distance_method.dart'
    as point_with_distance_method;
import 'package:examples/language_tour/classes/point_with_main.dart'
    as point_with_main;
import 'package:examples/language_tour/classes/rectangle.dart'
    as rectangle_with_main;
import 'package:examples/language_tour/classes/vector.dart' as vector_with_main;
import 'package:dartlang_examples_util/print_matcher.dart' as m;

void main() {
  test('object-creation', () {
    // #docregion object-creation
    var p1 = Point(2, 2);
    var p2 = Point.fromJson({'x': 1, 'y': 2});
    // #enddocregion object-creation
    expect(p1.y, p2.y);
  });

  test('object-creation-new', () {
    // #docregion object-creation-new
    var p1 = new Point(2, 2); // ignore: unnecessary_new
    var p2 = new Point.fromJson({'x': 1, 'y': 2}); // ignore: unnecessary_new
    // #enddocregion object-creation-new
    expect(p1.y, p2.y);
  });

  test('object-members', () {
    // #docregion object-members
    var p = Point(2, 2);

    // Set the value of the instance variable y.
    p.y = 3;

    // Get the value of y.
    assert(p.y == 3);

    // Invoke distanceTo() on p.
    num distance = p.distanceTo(Point(4, 4));
    // #enddocregion object-members

    // #docregion safe-member-access
    // If p is non-null, set its y value to 4.
    p?.y = 4;
    // #enddocregion safe-member-access
    expect(p.y, 4);
  });

  test('const, identical, runtimeType', () {
    _test() {
      // #docregion const
      var p = const ImmutablePoint(2, 2);
      // #enddocregion const

      // #docregion identical
      var a = const ImmutablePoint(1, 1);
      var b = const ImmutablePoint(1, 1);

      assert(identical(a, b)); // They are the same instance!
      // #enddocregion identical

      // #docregion runtimeType
      print('The type of a is ${a.runtimeType}');
      // #enddocregion runtimeType
    }

    expect(_test, m.prints('The type of a is ImmutablePoint'));
  });

  test('point_with_main', () {
    point_with_main.main(); // contains assertions
  });

  test('employee', () {
    expect(employee.main, m.prints(['in Person', 'in Employee']));
  });

  test('point_with_distance', () {
    expect(point_with_distance_field.main, prints(startsWith('3.6')));
  });

  test('point_redirecting', () {
    final p = point_redirecting.Point.alongXAxis(42);
    expect(p.y, 0);
  });

  test('logger', () {
    expect(
        logger_with_main.main,
        m.prints([
          'Button clicked',
          'log1: This is l1.',
          'log1: This is l1_2.',
          'log2: This is l2.',
        ]));
  });

  test('rectangle_with_main', () {
    rectangle_with_main.main(); // contains assertions
  });

  test('vector_with_main', () {
    vector_with_main.main(); // contains assertions
  });

  test('imposter', () {
    expect(
        impostor.main,
        m.prints([
          'Hello, Bob. I am Kathy.',
          'Hi Bob. Do you know who I am?',
        ]));
  });

  test('no_such_method', () {
    expect(no_such_method.main,
        m.prints('You tried to use a non-existent member: Symbol("foo")'));
  });

  test('enum_with_main', () {
    expect(enum_with_main.main, m.prints('Color.blue'));
  });

  test('orchestra', () {
    expect(orchestra.main, m.prints(['Waving hands', 'Playing piano']));
  });

  test('static-field', () {
    misc.main(); // contains assertions
  });

  test('point_with_distance_method', () {
    expect(point_with_distance_method.main, prints(startsWith('2.82')));
  });

  // ignore_for_file: unnecessary_const
  test('const_context', () {
    // #docregion const-context-withconst
    // Lots of const keywords here.
    const pointAndLine1 = const {
      'point': const [const ImmutablePoint(0, 0)],
      'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
    };
    // #enddocregion const-context-withconst

    // #docregion const-context-noconst
    // Only one const, which establishes the constant context.
    const pointAndLine2 = {
      'point': [ImmutablePoint(0, 0)],
      'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
    };
    // #enddocregion const-context-noconst

    expect(pointAndLine1 == pointAndLine2, isTrue);
  });

  test('nonconst_const_constructor', () {
    // #docregion nonconst-const-constructor
    var a = const ImmutablePoint(1, 1); // Creates a constant
    var b = ImmutablePoint(1, 1); // Does NOT create a constant

    assert(!identical(a, b)); // NOT the same instance!
    // #enddocregion nonconst-const-constructor

    expect(a == b, isFalse);
  });
}
