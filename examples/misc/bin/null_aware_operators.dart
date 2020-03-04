// ignore_for_file: unnecessary_null_in_if_null_operators
void main() {
  int a; // The initial value of a is null.
  a ??= 3;
  print(a); // <-- Prints 3.

  a ??= 5;
  print(a); // <-- Still prints 3.

  print(1 ?? 3); // <-- Prints 1.
  print(null ?? 12); // <-- Prints 12.
}
