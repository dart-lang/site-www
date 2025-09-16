/// Defines a private variable secret with `_`.
String _secret = 'Hello';

/// The public top-level getter.
/// It provides read access to the [_secret].
String get secret {
  print('Getter was used!');
  return _secret.toUpperCase();
}

/// The public top-level setter.
/// It provides write access to the [_secret].
set secret(String newMessage) {
  print('Setter was used! New secret: "$newMessage"');
  if (newMessage.isNotEmpty) {
    _secret = newMessage;
  }
}

void main() {
  // Reading the value calls the getter.
  print('Current message: $secret');

  /*
  Output:
  Getter was used!
  Current message: HELLO
  */

  // Assigning a value calls the setter.
  secret = 'Dart is fun';

  // Reading it again calls the getter to show the new value.
  print('New message: $secret');

  /*
  Output:
  Setter was used! New secret: "Dart is fun"
  Getter was used!
  New message: DART IS FUN
  */
}
