import 'dart:async';
import 'dart:html';

void main() {
  // Get a stream of key-press events from an element:
  querySelector('textarea').onKeyPress

    // Filter the stream, getting a stream of events only for certain key codes:
    .where((e) => e.keyCode >= 32 && e.keyCode <= 122)

    // Convert those key codes, getting a stream of corresponding characters:
    .map((e) => new String.fromCharCode(e.charCode))

    // Ask for the first character, getting a Future.
    .first

    // When the Future completes, print the first character to the console.
    .then((char) => print('First char=$char'));
}
