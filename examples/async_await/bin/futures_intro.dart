// #docregion ''
Future<void> fetchUserOrder() {
  // Imagine that this function is fetching user info from another service or database.
  return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}
// #enddocregion ''

// #docregion error
Future<void> fetchUserOrderError() {
// Imagine that this function is fetching user info but encounters a bug
  return Future.delayed(const Duration(seconds: 2),
      () => throw Exception('Logout failed: user ID is invalid'));
}
// #docregion ''

void main() {
  fetchUserOrder();
  print('Fetching user order...');
}
