// #docregion
void printName(String firstName, String lastName, {String? suffix}) {
  print('$firstName $lastName ${suffix ?? ''}');
}
// #enddocregion

void printNameTest() {
  // #docregion
  printName('Avinash', 'Gupta');
  printName('Poshmeister', 'Moneybuckets', suffix: 'IV');
  // #enddocregion
}
