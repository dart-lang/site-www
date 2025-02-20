import 'my_collection.dart';

void cannotRunThis() {
  // #docregion undefined-method
  var c = C(Iterable.empty()).collection;
  // ignore: stable, beta, dev, undefined_method
  c.add(2);
  // #enddocregion undefined-method
}

// #docregion inference-using-bounds-2
X max<X extends Comparable<X>>(X x1, X x2) => x1.compareTo(x2) > 0 ? x1 : x2;

void main() {
  // Inferred as `max<num>(3, 7)` with the feature, fails without it.
  max(3, 7);
}

// #enddocregion inference-using-bounds-2
