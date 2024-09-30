class SomeBaseClass {}

// #docregion generic
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'"; // ignore: annotate_overrides
}

class Extender extends SomeBaseClass {/*...*/}
// #enddocregion generic
