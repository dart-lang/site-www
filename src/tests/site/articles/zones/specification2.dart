import 'dart:async';

main() {
  runZoned(() {
    var currentZone = Zone.current;
    scheduleMicrotask(() {
      print(identical(currentZone, Zone.current));  // prints true.
    });
  }, zoneSpecification: new ZoneSpecification(
    scheduleMicrotask: (self, parent, zone, task) {
      print('scheduleMicrotask has been called inside the zone');
      // The origin `zone` needs to be passed to the parent so that
      // the task can be executed in it.
      parent.scheduleMicrotask(zone, task);
    }));
}
