void main() {
  // #docregion
  final name = 'Bob'; // Without a type annotation
  // name = 'Alice';  // Uncommenting this causes an error
  final String nickname = 'Bobby';
  // #enddocregion
  assert(nickname.startsWith(name));
  print('$name ($nickname)');
}
