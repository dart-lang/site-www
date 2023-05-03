// NOTE: Declarations in this file are analyzed but not tested.
// ignore_for_file: unused_element, unused_local_variable, one_member_abstracts, use_super_parameters
// ignore_for_file: prefer_function_declarations_over_variables, unused_field, strict_raw_type

import 'dart:html';

// Include in this file only excerpts used to illustrate fixes to common problems.
void _samplesFromCommonProblemsPage() {
  final double x = 0;
  final double y = 0;

  {
    // #docregion canvas-undefined
    var canvas = querySelector('canvas')!;
    // ignore: stable, beta, dev, undefined_getter
    canvas.context2D.lineTo(x, y); //!analysis-issue
    // #enddocregion canvas-undefined
  }

  {
    // #docregion canvas-as
    var canvas = querySelector('canvas') as CanvasElement;
    canvas.context2D.lineTo(x, y);
    // #enddocregion canvas-as
  }

  {
    // #docregion canvas-dynamic
    dynamic canvasOrImg = querySelector('canvas, img');
    var width = canvasOrImg.width;
    // #enddocregion canvas-dynamic
  }

  {
    // #docregion inferred-collection-types
    // Inferred as Map<String, int>
    var map = {'a': 1, 'b': 2, 'c': 3};
    // ignore: stable, beta, dev, invalid_assignment
    map['d'] = 1.5; //!analysis-issue
    // #enddocregion inferred-collection-types
  }

  {
    // #docregion inferred-collection-types-ok
    var map = <String, num>{'a': 1, 'b': 2, 'c': 3};
    map['d'] = 1.5;
    // #enddocregion inferred-collection-types-ok
  }
}

//-----------------------------------------------

// #docregion invalid-method-override
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  @override
  // ignore: stable, beta, dev, invalid_override
  num add(int a, int b) => a + b;
}
// #enddocregion invalid-method-override

void adderRuntimeFail() {
  // #docregion runtime-failure-if-int
  NumberAdder adder = MyAdder();
  adder.add(1.2, 3.4);
  // #enddocregion runtime-failure-if-int
}

// #docregion type-arguments
class Superclass<T> {
  void method(T param) {/* ... */}
}

class Subclass extends Superclass {
  @override
  // ignore: stable, beta, dev, invalid_override
  void method(int param) {/* ... */}
}
// #enddocregion type-arguments

//-----------------------------------------------

class Eats {}

abstract class Animal {
  Animal(Eats food);
}

class _HoneyBadger extends Animal {
  final String _name;
  // #docregion super-goes-last
  _HoneyBadger(Eats food, String name)
      // ignore: stable, beta, dev, super_invocation_not_last
      : super(food),
        _name = name {/* ... */}
// #enddocregion super-goes-last
}

class HoneyBadger extends Animal {
  final String _name;
  // #docregion super-goes-last-ok
  HoneyBadger(Eats food, String name)
      : _name = name,
        super(food) {/* ... */}
// #enddocregion super-goes-last-ok
}

//-----------------------------------------------

void funcFail() {
  // #docregion func-fail
  void filterValues(bool Function(dynamic) filter) {}
  // ignore: stable, beta, dev, argument_type_not_assignable
  filterValues((String x) => x.contains('Hello'));
  // #enddocregion func-fail
}

void funcT() {
  // #docregion func-T
  void filterValues<T>(bool Function(T) filter) {}
  filterValues<String>((x) => x.contains('Hello'));
  // #enddocregion func-T
}

void funcCast() {
  // #docregion func-cast
  void filterValues(bool Function(dynamic) filter) {}
  filterValues((x) => (x as String).contains('Hello'));
  // #enddocregion func-cast
}

//-----------------------------------------------

void infNull() {
  // #docregion type-inf-null
  var ints = [1, 2, 3];
  // ignore: non_bool_operand, undefined_operator, return_of_invalid_type_from_closure
  var maximumOrNull = ints.fold(null, (a, b) => a == null || a < b ? b : a);
  // #enddocregion type-inf-null
}

void infFix() {
  // #docregion type-inf-fix
  var ints = [1, 2, 3];
  var maximumOrNull =
      ints.fold<int?>(null, (a, b) => a == null || a < b ? b : a);
  // #enddocregion type-inf-fix
}
