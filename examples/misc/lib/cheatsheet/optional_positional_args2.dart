// #docregion
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
// #enddocregion
  return a + b + c + d + e;
// #docregion
}
// #enddocregion

void mainTest() {
  // #docregion
  int newTotal = sumUpToFive(1);
  print(newTotal); // <-- prints 15
  // #enddocregion
}
