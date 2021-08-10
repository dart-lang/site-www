class NonNegativePoint {
  final int x;
  final int y;

  // #docregion assert
  NonNegativePoint(this.x, this.y)
      : assert(x >= 0),
        assert(y >= 0) {
    print('I just made a NonNegativePoint: ($x, $y)');
  }
  // #enddocregion assert
}
