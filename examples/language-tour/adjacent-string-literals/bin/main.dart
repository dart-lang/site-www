void main() {
  // #docregion
  var s1 = 'String '
      'concatenation'
      " works even over line breaks.";
  assert(s1 ==
      'String concatenation works even over '
      'line breaks.');

  var s2 = 'The + operator ' + 'works, as well.';
  assert(s2 == 'The + operator works, as well.');
  // #enddocregion

  print(s1); // String concatenation works even over line breaks.
  print(s2); // The + operator works, as well.
}
