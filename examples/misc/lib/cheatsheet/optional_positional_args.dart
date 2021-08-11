// #docregion optional-positional-args-2
int sumUpToFive(int a, [int? b, int? c, int? d, int? e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}
// #enddocregion optional-positional-args-2

// #docregion optional-positional-args
int sumUp(int a, int b, int c) {
  return a + b + c;
}
// #enddocregion optional-positional-args

void mainTest() {
  // #docregion optional-positional-args
  int total = sumUp(1, 2, 3);
  // #enddocregion optional-positional-args
  // #docregion optional-positional-args-2
  int total2 = sumUpToFive(1, 2);
  int otherTotal = sumUpToFive(1, 2, 3, 4, 5);
  // #enddocregion optional-positional-args-2
  print(total);
  print(total2);
  print(otherTotal);
}
