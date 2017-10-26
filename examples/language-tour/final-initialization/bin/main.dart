// BEGIN(final_initialization)
final String name = 'Bob'; // Or: final String name = 'Bob';
// name = 'Alice';  // Uncommenting this causes an error
// END(final_initialization)

final String name2 = 'Roberta';

class Robert {
  final String nickname;

  Robert(this.nickname);

  @override
  String toString() => 'This Robert\'s nickname is $nickname.';
}

void main() {
  var r1 = new Robert(null);
  var r2 = new Robert(name);
  var r3 = new Robert('Robby');
  var r4 = new Robert(name2);

  print(r1);
  print(r2);
  print(r3);
  print(r4);
}
