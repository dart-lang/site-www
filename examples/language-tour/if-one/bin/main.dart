void main() {
// Change if (true) to if (1) to really test this code.
  if (true) {
    // BEGIN(if_one)
    print('JS prints this line.');
  } else {
    print('Dart in production mode prints this line.');
    // However, in checked mode, if (1) throws an
    // exception because 1 is not boolean.
  }
  // END(if_one)
}
