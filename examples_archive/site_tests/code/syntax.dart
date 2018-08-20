import 'dart:math' show PI;

List shapes = [];                     // Use literals to create lists.
addShape(shape) => shapes.add(shape); // Function shorthand syntax.

main() {  
  // The cascade operator (..) saves you from repetitive typing.
  addShape(new Ellipse(10, 20)..rotation = 45*PI/180
                              ..color = 'rgb(0,129,198)'
                              ..outlineWidth = 0);
  
  // You can easily insert expression values into strings.
  print('Area of the first shape: ${shapes[0].area}');
}

abstract class Shape {
  num get area;
  num rotation = 0;
  num outlineWidth = 1;
  String color = 'black';
}

class Ellipse extends Shape {
  num minorAxis, majorAxis;

  // Syntactic sugar to set members before the constructor body runs.
  Ellipse(this.minorAxis, this.majorAxis);

  static const num C = PI/4;              // A constant.
  num get area => C*majorAxis*minorAxis;  // A property implemented with a getter.

  Ellipse.circle(diameter) {              // A named constructor.
    minorAxis = majorAxis = diameter;
  }
  
  // Override Object's toString() method.
  String toString() =>
      'Ellipse: ${majorAxis}x${minorAxis} ($area); rotation: $rotation; $color';
}
