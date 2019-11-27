void any(Iterable<String> items) {
  // #docregion any-false
  if (items.any((element) => element.contains('Z'))) {
    print('At least one element contains "Z"');
  } else {
    print('No element contains "Z"');
  }
  // #enddocregion any-false
}
