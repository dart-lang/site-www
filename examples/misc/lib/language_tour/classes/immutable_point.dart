class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  const ImmutablePoint(this.x, this.y);

  final double x, y;
}
