import 'dart:async';

get currentStackTrace {
  try {
    throw 0;
  } catch(_, st) {
    return st;
  }
}

var lastStackTrace = null;

bar() => throw "in bar";
foo() => new Future(bar);

main() {
  final specification = new ZoneSpecification(
    registerCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerCallback(zone, () {
        lastStackTrace = stackTrace;
        return f();
      });
    },
    registerUnaryCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerUnaryCallback(zone, (arg) {
        lastStackTrace = stackTrace;
        return f(arg);
      });
    },
    registerBinaryCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerBinaryCallback(zone, (arg1, arg2) {
        lastStackTrace = stackTrace;
        return f(arg1, arg2);
      });
    },
    handleUncaughtError: (self, parent, zone, error, stackTrace) {
      if (lastStackTrace != null) print("last stack: $lastStackTrace");
      return parent.handleUncaughtError(zone, error, stackTrace);
    });

  runZoned(() {
    foo();
  }, zoneSpecification: specification);
}
