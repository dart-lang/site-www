void main() {
  // #docregion code_sample
  var items = [1, for (var x = 5; x > 2; x--) x, 7]; // [1, 5, 4, 3, 7]
  // #enddocregion code_sample

  print(items);
}
