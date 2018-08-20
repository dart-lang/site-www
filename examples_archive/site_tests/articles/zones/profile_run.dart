import 'dart:async';
import 'dart:io';

main() {
  final total = new Stopwatch();
  final user = new Stopwatch();

  final specification = new ZoneSpecification(
    run: (self, parent, zone, f) {
      user.start();
      try { return parent.run(zone, f); } finally { user.stop(); }
    },
    runUnary: (self, parent, zone, f, arg) {
      user.start();
      try { return parent.runUnary(zone, f, arg); } finally { user.stop(); }
    },
    runBinary: (self, parent, zone, f, arg1, arg2) {
      user.start();
      try {
        return parent.runBinary(zone, f, arg1, arg2);
      } finally {
        user.stop();
      }
    });

  runZoned(() {
    total.start();
    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse("http://www.google.com/"))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) {
        print("got reply");
        response.drain();
        print(total.elapsedMilliseconds);
        print(user.elapsedMilliseconds);
      });
  }, zoneSpecification: specification);
}
