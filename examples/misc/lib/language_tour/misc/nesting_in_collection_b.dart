void main() {
  // #docregion code_sample
  var nestItems = true;
  var ys = [1, 2, 3, 4];
  var items = [
    if (nestItems) ...[
      for (var x = 0; x < 3; x++)
        for (var y in ys)
          if (x < y) x + y * 10,
    ],
  ]; // [10, 20, 30, 40, 21, 31, 41, 32, 42]
  // #enddocregion code_sample

  print(items);
}
