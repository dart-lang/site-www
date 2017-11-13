class Person {
  String firstName;
  String lastName;
  String nickname;

  @override
  String toString() => '$firstName $lastName';
  String toTmiString() => '$firstName "$nickname" $lastName';
  String toBondianString() => '$lastName, ${toString()}';
  String toSwappedString() => '$lastName, $firstName';
  String capitalize() => toString().toUpperCase();
}

void main() {
  var p1 = new Person()
    ..firstName = 'Kathy'
    ..lastName = 'Walrath'
    ..nickname = 'The Mad Knitter';
  print(p1);
  print(p1.toSwappedString());
  print(p1.toTmiString());
  print(p1.toBondianString());
  print(p1.capitalize());
}
