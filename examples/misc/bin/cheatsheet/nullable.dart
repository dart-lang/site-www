// ignore_for_file: avoid_init_to_null, unused_local_variable

void main() {
  {
    // #docregion invalid-null
    // ignore: invalid_assignment
    int a = null; // INVALID.
    // #enddocregion invalid-null
  }

  {
    // #docregion valid-null
    int? a = null; // Valid.
    // #enddocregion valid-null
  }

  {
    // #docregion simple-null
    int? a; // The initial value of a is null.
    // #enddocregion simple-null
  }
}
