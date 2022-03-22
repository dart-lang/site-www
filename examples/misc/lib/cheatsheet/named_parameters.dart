// #docregion
void printName(String firstName, String lastName, {String? middleName}) {
  print('$firstName ${middleName ?? ''} $lastName');
}
// #enddocregion

void printNameTest() {
  // #docregion
  printName('Dash', 'Dartisan');
  printName('John', 'Smith', middleName: 'Who');
  // Named arguments can be placed anywhere in the argument list
  // ignore: positional_after_named_argument
  printName('John', middleName: 'Who', 'Smith');
  // #enddocregion
}
