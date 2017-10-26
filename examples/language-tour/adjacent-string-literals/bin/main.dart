void main() {
  // BEGIN(adjacent_string_literals)
  var s1 = 'String '
      'concatenation'
      " works even over line breaks.";
  assert(s1 ==
      'String concatenation works even over '
      'line breaks.');

  var s2 = 'The + operator ' + 'works, as well.';
  assert(s2 == 'The + operator works, as well.');
  // END(adjacent_string_literals)

  print(s1); // String concatenation works even over line breaks.
  print(s2); // The + operator works, as well.
}
