void main() {
  // #docregion code_sample
  var numbers = [1, 2, 3, 4, 5, 6];
  var items = [
    1,
    for (var n in numbers)
      if (n.isEven) n,
    7,
  ]; // [1, 2, 4, 6, 7]
  // #enddocregion code_sample

  print(items);
}
