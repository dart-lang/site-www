// #docregion
// Import only foo.
import 'lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'lib2.dart' hide foo;
// #enddocregion

Element e = Element();
dynamic bar = foo;
