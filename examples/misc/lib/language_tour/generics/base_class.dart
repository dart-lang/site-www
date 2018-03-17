class SomeBaseClass {}

// #docregion
// T must be SomeBaseClass or one of its descendants.
class Foo<T extends SomeBaseClass> {
  // #enddocregion
  // Implementation goes here.
  @override
  String toString() => 'Foo<$T>';
  // #docregion
}

class Extender extends SomeBaseClass {
  // #enddocregion
  // Implementation goes here.
  // #docregion
}
// #enddocregion

void main() {
  // It's OK to use SomeBaseClass or any of its subclasses inside <>.
  // #docregion SomeBaseClass-ok
  var someBaseClassFoo = new Foo<SomeBaseClass>();
  var extenderFoo = new Foo<Extender>();
  // #enddocregion SomeBaseClass-ok

  // It's also OK to use no <> at all.
  // #docregion no-generic-arg-ok
  var foo = new Foo();
  // #enddocregion no-generic-arg-ok

  // Normal mode: Foo<SomeBaseClass>, Foo<Extender>, Foo<dynamic>, Foo<Object>
  // print('$someBaseClassFoo, $extenderFoo, $foo, $objectFoo');

  // Foo<SomeBaseClass>, Foo<Extender>, Foo<dynamic>
  print('$someBaseClassFoo, $extenderFoo, $foo');
}

dynamic notTestedOnlyAnalyzed() {
  // ignore_for_file: 2, type_argument_not_matching_bounds
  // Specifying any non-SomeBaseClass type results in an error.
  // #docregion Foo-Object-error
  var foo = new Foo<Object>(); //!analysis-issue
  // #enddocregion Foo-Object-error
  return foo;
}
