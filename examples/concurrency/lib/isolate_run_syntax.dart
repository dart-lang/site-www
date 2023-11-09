import 'dart:isolate';

// #docregion main
int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

// Compute without blocking current isolate.
void fib40() async {
  await Isolate.run(() => slowFib(40));
}
// #enddocregion main
