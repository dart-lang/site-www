// #docplaster
import 'dart:collection';
import '../../util/print.dart';

final Iterator<Process> _it =
    [new Process(), new Process(), new Process()].iterator;

// #docregion
class Process {
  // Represents a process...
  // #enddocregion
  static int _nextId = 0;
  final int id = _nextId++;
  // #docregion
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => /*...*/
      // #enddocregion
      _it.current;
  // #docregion
  @override
  bool moveNext() => /*...*/
      // #enddocregion
      _it.moveNext();
  // #docregion
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = new ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (var process in new Processes()) {
    // Do something with the process.
    // #enddocregion
    $print(process.id);
    // #docregion
  }
}
