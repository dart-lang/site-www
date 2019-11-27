Iterable<int> where(Iterable<int> numbers) {
  // #docregion where
  // #docregion where-for
  Iterable<int> evenNumbers = numbers.where((number) => number.isEven);
  // #enddocregion where
  for (var number in evenNumbers) {
    print('$number is even');
  }
  // #enddocregion where-for
  return evenNumbers;
}
