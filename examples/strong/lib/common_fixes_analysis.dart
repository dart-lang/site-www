// NOTE: Declarations in this file are analyzed but not tested.
// ignore_for_file: sort_constructors_first, unused_element, unused_local_variable

import 'dart:html';

// Include in this file only excerpts used to illustrate fixes to common problems.
void _samplesFromCommonProblemsPage() {
  num x, y;

  {
    // #docregion canvas-as
    var canvas = querySelector('canvas') as CanvasElement;
    canvas.context2D.lineTo(x, y); //!analysis-issue
    // #enddocregion canvas-as
  }

  {
    // We need to ignore invalid_assignment because we use --no-implicit-casts.
    // #docregion canvas-ok
    // ignore_for_file: 1, 2, invalid_assignment
    CanvasElement canvas = querySelector('canvas');
    canvas.context2D.lineTo(x, y); //!analysis-issue
    // #enddocregion canvas-ok
  }

  {
    // #docregion canvas-dynamic
    dynamic canvasOrImg = querySelector('canvas, img');
    var width = canvasOrImg.width; //!analysis-issue
    // #enddocregion canvas-dynamic
  }

  {
    // #docregion inferred-collection-types
    var map = <String, num>{'a': 1, 'b': 2, 'c': 3};
    map['d'] = 1.5;
    // #enddocregion inferred-collection-types
  }
}

//-----------------------------------------------

// ignore_for_file: annotate_overrides, one_member_abstracts
// #docregion valid-method-override
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  num add(num a, num b) => a + b;
}
// #enddocregion valid-method-override

// #docregion type-arguments
class Superclass<T> {
  void method(T t) {/* ... */}
}

class Subclass extends Superclass<int> {
  void method(int i) {/* ... */}
}
// #enddocregion type-arguments

//-----------------------------------------------

class Eats {}

abstract class Animal {
  Animal(Eats food);
}

// ignore_for_file: unused_field
class HoneyBadger extends Animal {
  String _name;
  // #docregion super-goes-last
  HoneyBadger(Eats food, String name)
      : _name = name,
        super(food) {/* ... */}
// #enddocregion super-goes-last
}

//-----------------------------------------------

// #docregion func-T
typedef Filter<T> = bool Function(T any);
Filter<String> filter = (String x) => x.contains('Hello');
// #enddocregion func-T

//-----------------------------------------------

// #docregion func-cast
typedef Filter1 = bool Function(dynamic any);
Filter1 filter1 = (x) => (x as String).contains('Hello');
// #enddocregion func-cast
