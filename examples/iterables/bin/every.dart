bool bad(Iterable<String> items) {
// #docregion bad
  for (var item in items) {
    if (item.length < 5) {
      return false;
    }
  }
  return true;
// #enddocregion bad
}

bool good(Iterable<String> items) {
// #docregion good
  return items.every((element) => element.length >= 5);
// #enddocregion good
}
