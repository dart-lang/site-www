import 'dart:collection';

class Process {
  // Represents a process...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process current;
  @override
  bool moveNext() {
    return false;
  }
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of Iterable.
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = new ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (var process in new Processes()) {
    // Do something with the process.
  }
}
