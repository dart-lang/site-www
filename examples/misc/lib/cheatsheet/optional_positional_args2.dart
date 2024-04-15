// #docregion sum-no-impl
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
  // #enddocregion sum-no-impl
  return a + b + c + d + e;
  // #docregion sum-no-impl
}

void main() {
  int newTotal = sumUpToFive(1);
  print(newTotal); // <-- prints 15
}
// #enddocregion sum-no-impl
