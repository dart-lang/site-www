void main() {
  // #docregion
  void printElement(int element) {
    print(element);
  }

  var list = [1, 2, 3];

  // Pass printElement as a parameter.
  list.forEach(printElement);
  // #enddocregion
}
