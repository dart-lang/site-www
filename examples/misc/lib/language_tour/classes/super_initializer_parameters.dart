// #docregion positional, named
class Vector2d {
  // #enddocregion positional
  // ...

  // #enddocregion named
  // #docregion positional
  final double x;
  final double y;

  Vector2d(this.x, this.y);
  // #enddocregion positional

  // #docregion named
  Vector2d.named({required this.x, required this.y});
// #docregion positional
}

class Vector3d extends Vector2d {
  // #enddocregion positional
  // ...

  // #enddocregion named
  // #docregion positional
  final double z;

  // Forward the x and y parameters to the default super constructor like:
  // Vector3d(final double x, final double y, this.z) : super(x, y);
  Vector3d(super.x, super.y, this.z);
  // #enddocregion positional

  // #docregion named
  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
// #docregion positional
}
// #enddocregion positional, named
