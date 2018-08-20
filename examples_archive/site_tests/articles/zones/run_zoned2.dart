import 'dart:async';

main() {
  var f = new Future.error(499);
  f = f.whenComplete(() { print('Outside runZoned'); });
  runZoned(() {
    f = f.whenComplete(() { print('Inside non-error zone'); });
  });
  runZoned(() {
    f = f.whenComplete(() { print('Inside error zone (not called)'); });
    // Without zones or if this isn't an error zone, the error (499) ends
    // up here. You can test by commenting out all runZoned() calls, or
    // by removing the `onError` argument to this runZoned() call).
  }, onError: print);
}

