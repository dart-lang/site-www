// #docregion enum
enum Color { red, green, blue }
// #enddocregion enum

void main() {
  // #docregion index
  assert(Color.red.index == 0);
  assert(Color.green.index == 1);
  assert(Color.blue.index == 2);
  // #enddocregion index
  assert(Color.blue.toString() == 'Color.blue');

  // #docregion values
  List<Color> colors = Color.values;
  assert(colors[2] == Color.blue);
  // #enddocregion values

  // #docregion switch
  var aColor = Color.blue;

  switch (aColor) {
    case Color.red:
      print('Red as roses!');
      break;
    case Color.green:
      print('Green as grass!');
      break;
    default: // Without this, you see a WARNING.
      print(aColor); // 'Color.blue'
  }
  // #enddocregion switch
}
