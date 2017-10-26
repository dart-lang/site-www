class Color {
  static const Color red = const Color('red'); // A constant static variable.
  final String name; // An instance variable.
  const Color(this.name); // A constant constructor.
}

void main() {
  assert(Color.red.name == 'red');
}
