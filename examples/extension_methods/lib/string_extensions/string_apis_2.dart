extension NumberParsing2 on String {
  int parseInt() {
    return int.parse(this);
  }
}

extension HexParsing on String {
  int parseHexInt() {
    return int.parse(this, radix: 16);
  }
}
