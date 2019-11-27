Iterable<int> mapInt(Iterable<int> numbers) {
  // #docregion int
  Iterable<int> output = numbers.map((number) => number * 10);
  // #enddocregion int
  return output;
}

Iterable<String> mapString(Iterable<int> numbers) {
  // #docregion string
  Iterable<String> output = numbers.map((number) => number.toString());
  // #enddocregion string
  return output;
}
