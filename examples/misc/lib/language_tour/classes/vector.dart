// ignore_for_file: sort_constructors_first
// #docregion ''
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  // Operator == and hashCode not shown. For details, see note below.
  // #enddocregion ''
  @override
  bool operator ==(Object o) => o is Vector && x == o.x && y == o.y;

  @override
  int get hashCode => 37 * (629 + x.hashCode) + y.hashCode;

  @override
  String toString() => '($x, $y)';
  // #docregion ''
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
