Future<void> printOrderMessage() async {
  // #docregion try-catch
  try {
    print('Awaiting user order...');
    var order = await fetchUserOrder();
    print(order);
  } catch (err) {
    print('Caught error: $err');
  }
  // #enddocregion try-catch
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex.
  var str = Future.delayed(
      const Duration(seconds: 4),
      // ignore: only_throw_errors
      () => throw 'Cannot locate user order');
  return str;
}

void main() async {
  await printOrderMessage();
}
