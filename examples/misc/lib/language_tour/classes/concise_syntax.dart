// #docregion concise-syntax
class Point {
  double x, y;

  // Concise unnamed generative constructor.
  new(this.x, this.y);

  // Concise named generative constructor.
  new origin() : x = 0, y = 0;

  // Equivalent to `factory Point.clone(Point other)`.
  factory clone(Point other) => Point(other.x, other.y);
}

// #enddocregion concise-syntax
