extension NumberParsing on String {
  int parseInt() {
    return int.parse(this, radix: 16);
  }

  num parseNum() {
    return num.parse(this);
  }
}
