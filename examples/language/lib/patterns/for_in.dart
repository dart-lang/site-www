void main() {
  // #docregion for-in-pattern
  Map<String, int> hist = {
    'a': 23,
    'b': 100,
  };

  for (var MapEntry(key: key, value: count) in hist.entries) {
    print('$key occurred $count times');
  }
  // #enddocregion for-in-pattern

  // #docregion for-in-short
  for (var MapEntry(:key, value: count) in hist.entries) {
    print('$key occurred $count times');
  }
  // #enddocregion for-in-short
}
