// ignore_for_file: sort_constructors_first, type_annotate_public_apis

// #docregion
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
// #enddocregion

void main() {
  print(color.blue.toString());
}
