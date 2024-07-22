// rectangle_example.dart
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  double get right => left + width;
  set right(double value) => left = value - width;

  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);

  print(
      'Left: ${rect.left}, Right: ${rect.right}'); // Should print Left: 3.0, Right: 23.0
  rect.right = 12;
  print(
      'Updated Left: ${rect.left}, Right: ${rect.right}'); // Should print Updated Left: -8.0, Right: 12.0
}
