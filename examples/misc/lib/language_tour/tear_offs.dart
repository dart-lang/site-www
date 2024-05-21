void main() {
  // #docregion full-example
  // #docregion variables
  var charCodes = [68, 97, 114, 116];
  var buffer = StringBuffer();
  // #enddocregion variables

  // #docregion good-example
  // Function tear-off
  charCodes.forEach(print);

  // Method tear-off
  charCodes.forEach(buffer.write);
  // #enddocregion good-example

  // #docregion bad-example
  // Function lambda
  charCodes.forEach((code) {
    print(code);
  });

  // Method lambda
  charCodes.forEach((code) {
    buffer.write(code);
  });
  // #enddocregion bad-example
  // #enddocregion full-example
}
