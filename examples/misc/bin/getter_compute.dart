// #docregion getters-compute
class MyClass {
  List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // A computed property.
  int get count {
    return _values.length;
  }
}
// #enddocregion getters-compute

void main() {
  MyClass _class = MyClass();
  _class.addValue(5);
  _class.addValue(7);
  print(_class.count.toString());
}
