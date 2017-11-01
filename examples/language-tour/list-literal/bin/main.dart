// #docregion
List<int> list = [1, 2, 3];
// #enddocregion

void main() {
  // #docregion const
  var constantList = const [1, 2, 3];
  // constantList[1] = 1; // Uncommenting this causes an error.
  // #enddocregion const

  list[1] = 1; // You can do this.
  try {
    constantList[1] = 1; // You can't do this.
  } catch (e) {
    print('Tsk tsk! $e');
  }
}
