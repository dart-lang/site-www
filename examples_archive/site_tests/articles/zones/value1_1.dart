import 'dart:async';

main() {
  runZoned(() {
    Zone.current[#key].add(499);
    print(Zone.current[#key]); // [499]
  }, zoneValues: { #key: [] });
}
