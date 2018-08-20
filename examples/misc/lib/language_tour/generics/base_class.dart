class SomeBaseClass {}

// #docregion
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'"; // ignore: annotate_overrides
}

class Extender extends SomeBaseClass {/*...*/}
