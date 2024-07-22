// vector_example.dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final v1 = Vector(2, 3);
  final v2 = Vector(2, 2);

  final sum = v1 + v2;
  final difference = v1 - v2;

  print('Sum of vectors: (${sum.x}, ${sum.y})'); // Should print (4, 5)
  print(
      'Difference of vectors: (${difference.x}, ${difference.y})'); // Should print (0, 1)

  print('Vectors equal: ${v1 == Vector(2, 3)}'); // Should print true
}
