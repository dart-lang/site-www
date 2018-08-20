// #docplaster
void main() {
  var n = 4;
  var d = 2;
  var i = 2;

  // #docregion
  // 1: Parens improve readability.
  if ((n % i == 0) && (d % i == 0))
  // #enddocregion
  {/* do nothing */}
  // #docregion

  // 2: Harder to read, but equivalent.
  if (n % i == 0 && d % i == 0)
  // #enddocregion
  {/* do nothing */}
}
