import 'base_class.dart';

dynamic notTestedOnlyAnalyzed() {
  // ignore_for_file: 2, type_argument_not_matching_bounds
  // Specifying any non-SomeBaseClass type results in an error.
  // #docregion Foo-Object-error
  var foo = new Foo<Object>(); //!analysis-issue
  // #enddocregion Foo-Object-error
  return foo;
}
