import 'dart:async';

main() {
  runZoned(() {
    print(Zone.current[#key]);
  }, zoneValues: { #key: 499 });
}
