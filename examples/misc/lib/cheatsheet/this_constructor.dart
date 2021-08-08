// #docregion required-positional
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
// #enddocregion required-positional

// #docregion required-named
class MyColorRN {
  int red, green, blue;

  MyColorRN({required this.red, required this.green, required this.blue});
}

final colorRN = MyColorRN(red: 80, green: 80, blue: 80);
// #enddocregion required-named

class MyColorO {
  int red;
  int green;
  int blue;

  // #docregion defaulted
  MyColorO.positional([this.red = 0, this.green = 0, this.blue = 0]);
  // or
  MyColorO.named({this.red = 0, this.green = 0, this.blue = 0});
  // #enddocregion defaulted
}
