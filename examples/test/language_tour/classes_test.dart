// ignore_for_file: unused_local_variable
// #docplaster
import 'dart:convert';

import 'package:test/test.dart';
import 'package:examples/language_tour/classes/employee.dart'
    as employee;
import 'package:examples/language_tour/classes/enum.dart'
    as enum_with_main;
import 'package:examples/language_tour/classes/immutable_point.dart';
import 'package:examples/language_tour/classes/impostor.dart'
    as impostor;
import 'package:examples/language_tour/classes/logger_with_main.dart'
    as logger_with_main;
import 'package:examples/language_tour/classes/misc.dart'
    as misc;
import 'package:examples/language_tour/classes/no_such_method.dart'
    as no_such_method;
import 'package:examples/language_tour/classes/orchestra.dart'
    as orchestra;
import 'package:examples/language_tour/classes/point.dart';
import 'package:examples/language_tour/classes/point_redirecting.dart'
    as point_redirecting;
import 'package:examples/language_tour/classes/point_with_distance_field.dart'
    as point_with_distance_field;
import 'package:examples/language_tour/classes/point_with_distance_method.dart'
    as point_with_distance_method;
import 'package:examples/language_tour/classes/point_with_main.dart'
    as point_with_main;
import 'package:examples/language_tour/classes/proxy.dart'
    as proxy;
import 'package:examples/language_tour/classes/proxy_alt.dart'
    as proxy_alt;
import 'package:examples/language_tour/classes/rectangle.dart'
    as rectangle_with_main;
import 'package:examples/language_tour/classes/vector.dart'
    as vector_with_main;
import 'package:examples/language_tour/util/logging_printer.dart';
import 'package:examples/language_tour/util/print.dart';

void main() {
  final printLog = PrintLog.it;

  setUpAll(() => PrintLog.set$print());
  setUp(() => printLog.clear());

  test('object-creation', () {
    // #docregion object-creation
    var jsonData = JSON.decode('{"x":1, "y":2}');

    // Create a Point using Point().
    var p1 = new Point(2, 2);

    // Create a Point using Point.fromJson().
    var p2 = new Point.fromJson(jsonData);
    // #enddocregion object-creation
    expect(p1.y, p2.y);
  });

  test('object-members', () {
    // #docregion object-members
    var p = new Point(2, 2);

    // Set the value of the instance variable y.
    p.y = 3;

    // Get the value of y.
    assert(p.y == 3);

    // Invoke distanceTo() on p.
    num distance = p.distanceTo(new Point(4, 4));
    // #enddocregion object-members

    // #docregion safe-member-access
    // If p is non-null, set its y value to 4.
    p?.y = 4;
    // #enddocregion safe-member-access
    expect(p.y, 4);
  });

  test('const, identical, runtimeType', () {
    // #docregion const
    var p = const ImmutablePoint(2, 2);
    // #enddocregion const

    // #docregion identical
    var a = const ImmutablePoint(1, 1);
    var b = const ImmutablePoint(1, 1);

    assert(identical(a, b)); // They are the same instance!
    // #enddocregion identical

    // #docregion runtimeType
    $print('The type of a is ${a.runtimeType}');
    // #enddocregion runtimeType
    expect(printLog.toString(),
        'The type of a is ImmutablePoint');
  });

  test('point_with_main', () {
    point_with_main.main(); // contains assertions
  });

  test('employee', () {
    employee.main();
    expect(printLog.toString(), 'in Person\nin Employee');
  });

  test('point_with_distance', () {
    point_with_distance_field.main();
    expect(printLog.toString().startsWith('3.6'), isTrue);
  });

  test('point_redirecting', () {
    final p = new point_redirecting.Point.alongXAxis(42);
    expect(p.y, 0);
  });

  test('logger_with_main', () {
    logger_with_main.main(); // contains assertions
    expect(printLog.log, [
      'Button clicked',
      'log1: This is l1.',
      'log1: This is l1_2.',
      'log2: This is l2.',
    ]);
  });

  test('rectangle_with_main', () {
    rectangle_with_main.main(); // contains assertions
  });

  test('vector_with_main', () {
    vector_with_main.main(); // contains assertions
  });

  test('imposter', () {
    impostor.main();
    expect(
        printLog.toString(),
        'Hello, Bob. I am Kathy.\n' +
            'Hi Bob. Do you know who I am?');
  });

  test('no_such_method', () {
    no_such_method.main();
    expect(printLog.toString(),
        'You tried to use a non-existent member: Symbol("foo")');
  });

  test('proxy', () {
    proxy.main();
    expect(printLog.toString(),
        'handling invocation: Symbol("doSomething")');
  });

  test('proxy_alt', () {
    proxy_alt.main();
    expect(
        printLog.toString(),
        'handling invocation: Symbol("doSomething")\n' +
            'handling invocation: Symbol("doSomeOtherThing")');
  });

  test('enum_with_main', () {
    enum_with_main.main(); // contains assertions
    expect(printLog.toString(), 'Color.blue');
  });

  test('orchestra', () {
    orchestra.main();
    expect(
        printLog.toString(), 'Waving hands\nPlaying piano');
  });

  test('static-field', () {
    misc.main(); // contains assertions
  });

  test('point_with_distance_method', () {
    point_with_distance_method
        .main(); // contains assertions
    expect(printLog.toString().startsWith('2.82'), isTrue);
  });
}
