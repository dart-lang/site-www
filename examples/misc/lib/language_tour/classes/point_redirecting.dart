class Point {
  // The main constructor for this class.
  Point(this.x, this.y);

  double x, y;

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
