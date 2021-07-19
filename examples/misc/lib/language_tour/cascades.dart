class Colors {
  static const int black = 0;
}

class StrokeCap {
  static const int round = 0;
}

class Paint {
  late int color;
  late int strokeCap;
  late double strokeWidth;
}

void main() {
  showCascade();
  showExpanded();
}

void showCascade() {
  // #docregion cascade
  var paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;
  // #enddocregion cascade
  print(paint);
}

void showExpanded() {
  // #docregion cascade-expanded
  var paint = Paint();
  paint.color = Colors.black;
  paint.strokeCap = StrokeCap.round;
  paint.strokeWidth = 5.0;
  // #enddocregion cascade-expanded
  print(paint);
}
