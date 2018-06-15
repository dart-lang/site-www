import 'my_collection.dart';

void oops() {
  // #docregion add-error
  var c = new C(Iterable.empty()).collection;
  // ignore_for_file: 2, undefined_method
  c.add(2); //!analysis-issue
  // #enddocregion add-error
}
