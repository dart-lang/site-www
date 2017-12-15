import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future handleFile(fileName) {
  print("dealing with $fileName");
  return new Future.delayed(const Duration(milliseconds: 20));
}

main() {
  Future moveNextAssert(iterator) {
    var future = iterator.moveNext();
    return future.then((hasNext) {
      if (!hasNext) throw new StateError("missing element");
      return iterator.current;
    });
  }

  var lines = new File("example4.data").openRead()
      .transform(UTF8.decoder)
      .transform(new LineSplitter());
  var iterator = new StreamIterator(lines);
  moveNextAssert(iterator)
    .then((line) {
      print("First line: $line");
      return moveNextAssert(iterator);
    })
    .then((fileName) {  // Assume second line is a file.
      return handleFile(fileName)  // Wait for it to finish.
        .then((_) => moveNextAssert(iterator));
    })
    .then((line) {
      print("Last line: $line");
      return iterator.moveNext();
    })
    .then((hasNext) {
      if (hasNext) throw "More lines than expected";
    });
}
