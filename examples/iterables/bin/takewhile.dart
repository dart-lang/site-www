Iterable<int> takeWhile(Iterable<int> numbers) {
// #docregion takewhile
Iterable<int> numbersUntilNegative = numbers.takeWhile((number) => !number.isNegative);
// #enddocregion takewhile
return numbersUntilNegative;
}