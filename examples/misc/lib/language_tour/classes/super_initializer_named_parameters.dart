// #docregion named
class Vector2d {
// #enddocregion named
  final double x;
  final double y;

  Vector2d(this.x, this.y);
// #docregion named
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
// #enddocregion named
