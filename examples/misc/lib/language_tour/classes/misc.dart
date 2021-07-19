// ignore_for_file: annotate_overrides, one_member_abstracts
// #docregion abstract
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}
// #enddocregion abstract

class Comparable {}

class Location {}

// #docregion point_interfaces
class Point implements Comparable, Location {/*...*/}
// #enddocregion point_interfaces

// #docregion static-field
class Queue {
  static const initialCapacity = 16; // ignore: type_annotate_public_apis
  // #enddocregion static-field
  // #docregion static-field
}

void main() {
  assert(Queue.initialCapacity == 16);
}
// #enddocregion static-field
