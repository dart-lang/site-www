// ignore_for_file: unused_local_variable

void main() {
  const aListOfStrings = ['a', 'b', 'c'];

  {
    // #docregion has-empty-long
    bool hasEmpty = aListOfStrings.any((s) {
      return s.isEmpty;
    });
    // #enddocregion has-empty-long
  }

  {
    // #docregion has-empty-short
    bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
    // #enddocregion has-empty-short
  }
}
