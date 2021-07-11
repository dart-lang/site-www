// NOTE: Declarations in this file are analyzed but not tested.

import 'package:examples_util/ellipsis.dart';

// #docregion Animal
class Animal {
  void chase(Animal a) {/* ... */}
  Animal get parent => ellipsis();
}
// #enddocregion Animal

// #docregion HoneyBadger
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) {/* ... */}

  @override
  HoneyBadger get parent => ellipsis();
}
// #enddocregion HoneyBadger

// #docregion chase-Object
class HoneyBadger1 extends Animal {
  @override
  void chase(Object a) {/* ... */}

  @override
  Animal get parent => ellipsis();
}
// #enddocregion chase-Object

class Alligator extends Animal {/* ... */}

class Cat extends Animal {/* ... */}

class Dog extends Animal {/* ... */}

class MaineCoon extends Cat {/* ... */}
