class MyClass {
  int _aProperty = 0;

  int get aProperty => _aProperty;

  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}

void main() {
  MyClass _class = MyClass();
  _class.aProperty = 5;
  print(_class.aProperty);
}
