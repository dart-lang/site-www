void doFor() {
  // #docregion for
  var message = new StringBuffer("Dart is fun");
  for (var i = 0; i < 5; i++) {
    message.write('!');
  }
  // #enddocregion for
  print(message);
}

void doClosures() {
  print('do closures right: 0 1');

  // #docregion closures
  var callbacks = [];
  for (var i = 0; i < 2; i++) {
    callbacks.add(() => print(i));
  }
  callbacks.forEach((c) => c());
  // #enddocregion closures
}

void doCollection() {
  print('do collection');

  // #docregion collection
  var collection = [0, 1, 2];
  for (var x in collection) {
    print(x); // 0 1 2
  }
  // #enddocregion collection
}

class Candidate {
  void interview() {}
}

void doForIn() {
  List<Candidate> candidates = [
    new Candidate(),
    new Candidate(),
    new Candidate()
  ];

  // #docregion forEach
  candidates.forEach((candidate) => candidate.interview());
  // #enddocregion forEach
}

void main() {
  doFor();
  doClosures();
  doCollection();
  doForIn();
}
