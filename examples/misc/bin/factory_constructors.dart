// ignore_for_file: unused_local_variable

// #docregion factory-constructors
class Square extends Shape {}

class Circle extends Shape {}

class Shape {
  Shape();

  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();

    print('I don\'t recognize $typeName');
    return null;
  }
}
// #enddocregion factory-constructors

void main() {
  final shape = Shape();
}
