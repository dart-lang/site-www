import 'dart:async';

main() {
  runZoned(() {
    Timer.run(() { throw 'Would normally kill the program'; });
  }, onError: (error, stackTrace) {
    print('Uncaught error: $error');
  });
}

