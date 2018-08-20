// #docplaster
void main() {
// Change if (true) to if (1) to really test this code.
/*
// #docregion
  if (1) {
// #enddocregion
*/
  if (true) {
    // #docregion
    print('JS prints this line.');
  } else {
    print('Dart in production mode prints this line.');
    // However, in checked mode, if (1) throws an
    // exception because 1 is not boolean.
  }
  // #enddocregion
}
