// #docregion optional-named-params
void printName(String firstName, String lastName, {String suffix}) {
  print('$firstName $lastName ${suffix ?? ''}');
}

void main() {
  printName('Avinash', 'Gupta');
  printName('Poshmeister', 'Moneybuckets', suffix: 'IV');
}
// #enddocregion optional-named-params
