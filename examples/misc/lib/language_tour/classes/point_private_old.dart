class Point {
  final double _x;
  final double _y;

  // The old way: Mapping public parameters to private fields
  Point({required double x, required double y})
      : _x = x,
        _y = y;

  @override
  String toString() => 'Point($_x, $_y)';
}
