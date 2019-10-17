// NOTE: Declarations in this file are analyzed but not tested.
//
// Include in this file only excerpts used to illustrate common problems.
// The specific errors generated by the analyzer are included in the markdown.
//
// ignore_for_file: sort_constructors_first, unused_element, unused_local_variable

import 'dart:html';

void _samplesFromCommonProblemsPage() {
  {
    // #docregion is-strong-mode-enabled
    // ignore_for_file: stable, dev, invalid_assignment
    bool b = [0][0];
    // #enddocregion is-strong-mode-enabled
  }

  {
    num x, y;
    // #docregion canvas-error
    var canvas = querySelector('canvas');
    // ignore_for_file: stable, dev, undefined_getter
    canvas.context2D.lineTo(x, y); //!analysis-issue
    // #enddocregion canvas-error
  }

  {
    // #docregion unsafe-method-call
    NumberAdder adder = MyAdder();
    adder.add(1.2, 3.4);
    // #enddocregion unsafe-method-call
  }

  {
    // #docregion inferred-collection-types
    // Inferred as Map<String, int>
    var map = {'a': 1, 'b': 2, 'c': 3};
    map['d'] = 1.5; // a double is not an int
    // #enddocregion inferred-collection-types
  }

  {
    // #docregion int-not-string
    List<int> numbers = [1, 2, 3];
    // ignore_for_file: stable, dev, invalid_assignment
    List<String> string = numbers;
    // #enddocregion int-not-string
  }
}

//-----------------------------------------------

// ignore_for_file: annotate_overrides, one_member_abstracts
// #docregion invalid-method-override
abstract class NumberAdder {
  num add(num a, num b);
}

class MyAdder extends NumberAdder {
  // ignore_for_file: stable, dev, invalid_override
  int add(int a, int b) => a + b;
}
// #enddocregion invalid-method-override

//-----------------------------------------------

// #docregion missing-type-arguments
class Superclass<T> {
  void method(T t) {/* ... */}
}

class Subclass extends Superclass {
  // ignore_for_file: stable, dev, invalid_override
  void method(int i) {/* ... */}
}
// #enddocregion missing-type-arguments

//-----------------------------------------------

class Eats {}

abstract class Animal {
  Animal(Eats food);
}

// ignore_for_file: super_goes_last, unused_field
class HoneyBadger extends Animal {
  String _name;
  // #docregion super-goes-last
  HoneyBadger(Eats food, String name)
      // ignore_for_file: stable, dev, invalid_super_invocation
      : super(food),
        _name = name {/* ... */}
  // #enddocregion super-goes-last
}

//-----------------------------------------------

// #docregion func-dynamic
typedef Filter = bool Function(dynamic any);
// ignore_for_file: stable, dev, invalid_cast_function_expr
Filter filter = (String x) => x.contains('Hello');
// #enddocregion func-dynamic
