import 'dart:async';

main() {
  runZoned(() {
    print('Will be ignored');
  }, zoneSpecification: new ZoneSpecification(
    print: (self, parent, zone, message) {
      // Ignore message.
    }));
}
