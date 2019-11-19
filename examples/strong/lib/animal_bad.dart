// NOTE: Declarations in this file are analyzed but not tested.
// ignore_for_file: annotate_overrides, unused_local_variable

import 'package:examples_util/ellipsis.dart';

import 'animal.dart';

// https://en.wikipedia.org/wiki/Eukaryote
class Root {}

// #docregion HoneyBadger
class HoneyBadger extends Animal {
  void chase(Animal a) {/* ... */}
  // ignore_for_file: stable, dev, invalid_override
  Root get parent => ellipsis(); //!analysis-issue ret. type not covariant
}
// #enddocregion HoneyBadger

//-----------------------------------------------

// #docregion chase-Mouse
class Mouse extends Animal {/*...*/}

class Cat extends Animal {
  // ignore_for_file: stable, dev, invalid_override
  void chase(Mouse x) {/* ... */} //!analysis-issue
}
// #enddocregion chase-Mouse

// We can't test the following in Dart 2 because it won't compile
// due to the static type error on Cat.chase().
void main() {
  // #docregion chase-Alligator
  Animal a = Cat();
  a.chase(Alligator()); // Not type safe or feline safe
  // #enddocregion chase-Alligator
}

//-----------------------------------------------

// #docregion dynamic-list
class Cat1 extends Animal {/* ... */}

class Dog1 extends Animal {/* ... */}

void main1() {
  // ignore_for_file: stable, dev, invalid_assignment
  List<Cat> foo = <dynamic>[Dog1()]; // Error//!analysis-issue
  List<dynamic> bar = <dynamic>[Dog1(), Cat1()]; // OK
}
// #enddocregion dynamic-list
