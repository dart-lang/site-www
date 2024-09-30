import 'dart:collection';

final Iterator<Process> _it = [Process(), Process(), Process()].iterator;

// #docregion structure
class Process {
  // Represents a process...
  // #enddocregion structure
  static int _nextId = 0;
  final int id = _nextId++;
  // #docregion structure
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => /*...*/
      // #enddocregion structure
      _it.current;
  // #docregion structure
  @override
  bool moveNext() => /*...*/
      // #enddocregion structure
      _it.moveNext();
  // #docregion structure
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (final process in Processes()) {
    // Do something with the process.
    // #enddocregion structure
    print(process.id);
    // #docregion structure
  }
}
// #enddocregion structure
