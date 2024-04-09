import 'my_collection.dart';

void cannotRunThis() {
  // #docregion undefined-method
  var c = C(Iterable.empty()).collection;
  // ignore: stable, beta, dev, undefined_method
  c.add(2);
  // #enddocregion undefined-method
}
