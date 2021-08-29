String processValue(dynamic value) {
  return 'value';
}

Future<Object> funcThatThrows() {
  throw Exception('Threw an exception');
}

Future<String> handleError(dynamic error) {
  return Future.value('value');
}

void printErrorMessage() {}
