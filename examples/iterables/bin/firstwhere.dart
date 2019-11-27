String firstWhere(Iterable<String> iterable) {
  // #docregion firstwhere
  String element = iterable.firstWhere((element) => element.length > 5);
  // #enddocregion firstwhere
  return element;
}
