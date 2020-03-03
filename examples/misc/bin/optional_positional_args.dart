int sumUpToFive(int a, [int b, int c, int d, int e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}

int sumUp(int a, int b, int c) {
  return a + b + c;
}

void main() {
  int total = sumUp(1, 2, 3);
  int otherTotal = sumUpToFive(1, 2, 3, 4, 5);
  print(total);
  print(otherTotal);
}
