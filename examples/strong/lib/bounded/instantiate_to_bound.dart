import 'my_collection.dart';

void main() {
  // #docregion add-ok
  var c = new C(Iterable.empty()).collection.toList();
  c.add(2);
  // #enddocregion add-ok
  assert(c.length == 1);
}
