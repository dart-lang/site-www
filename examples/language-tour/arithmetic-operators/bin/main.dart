void main() {
  assert(2 + 3 == 5);
  assert(2 - 3 == -1);
  assert(2 * 3 == 6);
  assert(5 / 2 == 2.5); // Result is a double
  assert(5 ~/ 2 == 2); // Result is an integer
  assert(5 % 2 == 1); // Remainder

  print('5/2 = ${5~/2} r ${5%2}'); // 5/2 = 2 r 1
}
