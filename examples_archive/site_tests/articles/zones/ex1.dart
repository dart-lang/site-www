import 'dart:async';

main() {
  foo();
  var future;
  runZoned(() {         // Starts a new child zone.
    future = new Future(bar).then(baz);
  });
  future.then(qux);
}

foo() => print('foo');  // Executed twice (once each in two zones).
bar() => print('bar');
baz(x) => runZoned(() => foo());
qux(x) => print('qux: $x');
