// ignore_for_file: type_annotate_public_apis
// #docregion
class Color {
  static const red =
      const Color('red'); // A constant static variable.
  final String name; // An instance variable.
  const Color(this.name); // A constant constructor.
}

void main() {
  assert(Color.red.name == 'red');
}
