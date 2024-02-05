class ImmutablePoint {
  const ImmutablePoint(this.x, this.y);

  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;
}
