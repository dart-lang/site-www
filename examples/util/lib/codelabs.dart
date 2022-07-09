const testKey = '__TESTRESULT__ ';

void result(bool success, [List<String> messages = const []]) {
  // Join messages into a comma-separated list for inclusion in the JSON array.
  final joinedMessages = messages.map((m) => '"$m"').join(',');
  print('$testKey{"success": \$success, "messages": [$joinedMessages]}');
}

// Placeholder for unimplemented methods in dart-pad exercises.
// ignore: non_constant_identifier_names
Never TODO([String message = '']) => throw UnimplementedError(message);
