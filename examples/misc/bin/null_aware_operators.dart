// ignore_for_file: unnecessary_null_in_if_null_operators, dead_null_aware_expression

void main() {
// #docregion null-aware-operators
  int? a; // = null
  a ??= 3;
  print(a); // <-- Prints 3.

  a ??= 5;
  print(a); // <-- Still prints 3.
// #enddocregion null-aware-operators

// #docregion null-aware-operators-2
  print(1 ?? 3); // <-- Prints 1.
  print(null ?? 12); // <-- Prints 12.
// #enddocregion null-aware-operators-2
}
