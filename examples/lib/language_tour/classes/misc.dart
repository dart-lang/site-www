// ignore_for_file: annotate_overrides, one_member_abstracts
// #docplaster

// #docregion abstract
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}
// #enddocregion abstract

// #docregion extends
class SpecializedContainer extends AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren() {
    // Provide an implementation, so the method is not abstract here...
  }

  // Abstract method causes a warning but
  // doesn't prevent instantiation.
  // #enddocregion extends
  /*
  // #docregion extends
  void doSomething();
  // #enddocregion extends
  */
// #docregion extends
}
// #enddocregion extends

class Comparable {}

class Location {}

// #docregion point_interfaces
class Point implements Comparable, Location {
  // ···
}
// #enddocregion point_interfaces

// #docregion static-field
class Queue {
  static const int initialCapacity = 16;
  // ···
}

void main() {
  assert(Queue.initialCapacity == 16);
}
// #enddocregion static-field
