// ignore_for_file: unused_local_variable, unused_element
import 'animal.dart';

// #docregion chase-mouse
class Mouse extends Animal {/* ... */}

class Cat extends Animal {
  @override
  // ignore: invalid_override
  void chase(Mouse a) {/* ... */}
}
// #enddocregion chase-mouse

void notTypeSafeChase() {
  // #docregion would-not-be-type-safe
  Animal a = Cat();
  a.chase(Alligator()); // Not type safe or feline safe.
  // #enddocregion would-not-be-type-safe
}

void invalidDynamicList() {
  // #docregion invalid-dynamic-list
  void main() {
    // ignore: invalid_assignment
    List<Cat> foo = <dynamic>[Dog()]; // Error
    List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
  }
  // #enddocregion invalid-dynamic-list
}
