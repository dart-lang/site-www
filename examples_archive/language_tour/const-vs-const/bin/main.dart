// #docplaster
void main() {
  // #docregion
  // Note: [] creates an empty list.
  // const [] creates an empty, immutable list (EIA).
  var foo = const []; // foo is currently an EIA.
  final bar = const []; // bar will always be an EIA.
  const baz = const []; // baz is a compile-time constant EIA.
  // #enddocregion

  print('$foo, $bar, $baz'); // [], [], []
  // #docregion

  // You can change the value of a non-final, non-const variable,
  // even if it used to have a const value.
  foo = [];

  // You can't change the value of a final or const variable.
  // bar = []; // Unhandled exception.
  // baz = []; // Unhandled exception.
  // #enddocregion
}
