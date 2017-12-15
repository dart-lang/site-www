import 'dart:async';

main() {
  var completer = new Completer();
  var future = completer.future.then((x) => x + 1);
  var zoneFuture;
  runZoned(() {
    zoneFuture = future.then((y) => throw 'Inside zone');
  }, onError: (error) {
    print('Caught: $error');
  });
  zoneFuture.catchError((e) { print('Never reached'); });
  completer.complete(499);
}

