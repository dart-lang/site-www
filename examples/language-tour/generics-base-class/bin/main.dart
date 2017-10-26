class SomeBaseClass {}

// T must be SomeBaseClass or one of its descendants.
class Foo<T extends SomeBaseClass> {
  // Implementation goes here.
  @override
  String toString() => 'Foo<$T>';
}

class Extender extends SomeBaseClass {
  // Implementation goes here.
}

void main() {
  // It's OK to use SomeBaseClass or any of its subclasses inside <>.
  var someBaseClassFoo = new Foo<SomeBaseClass>();
  var extenderFoo = new Foo<Extender>();

  // It's also OK to use no <> at all.
  var foo = new Foo();

  // Specifying any non-SomeBaseClass type results in a warning and, in
  // checked mode, a runtime error.
  // var objectFoo = new Foo<Object>();

  // Normal mode: Foo<SomeBaseClass>, Foo<Extender>, Foo<dynamic>, Foo<Object>
  // print('$someBaseClassFoo, $extenderFoo, $foo, $objectFoo');

  // Foo<SomeBaseClass>, Foo<Extender>, Foo<dynamic>
  print('$someBaseClassFoo, $extenderFoo, $foo');
}
