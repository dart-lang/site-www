// ignore_for_file: sort_constructors_first, type_annotate_public_apis

// #docregion this-constructor
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
// #enddocregion this-constructor

void main() {
  print(color.blue.toString());
}
