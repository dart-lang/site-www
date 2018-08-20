import 'dart:io';
import 'dart:async';

main() {
  var stream = new File('stream.dart').openRead()
      .map((x) => throw 'Callback throws');

  runZoned(() { stream.listen(print); },
           onError: (e) { print('Caught error: $e'); });
}

