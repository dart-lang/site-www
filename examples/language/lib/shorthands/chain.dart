void printLowerH() {
  // #docregion chain
  // .fromCharCode(72) resolves to the String "H",
  // then the instance method .toLowerCase() is called on that String.
  String lowerH = .fromCharCode(72).toLowerCase();
  // Instead of String.fromCharCode(72).toLowerCase()

  print(lowerH); // Output: h
  // #enddocregion chain
}
