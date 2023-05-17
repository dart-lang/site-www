class Rect {
  int width;
  int height;
  Rect({required this.width, required this.height});
}

void main() {
  var number = 1;
  // #docregion constant-pattern
  switch (number) {
    // Constant pattern matches if 1 == number.
    case 1:
      print('one');
  }
  // #enddocregion constant-pattern

  const a = 'a';
  const b = 'b';
  var obj = Object();
  // #docregion list-pattern
  switch (obj) {
    // List pattern [a, b] matches obj first if obj is a list with two fields,
    // then if its fields match the constant subpatterns 'a' and 'b'.
    case [a, b]:
      print('$a, $b');
  }
  // #enddocregion list-pattern

  {
    var obj = 0;
    const first = 0;
    const last = 10;
    // #docregion switch-statement
    switch (obj) {
      // Matches if 1 == obj.
      case 1:
        print('one');

      // Matches if the value of obj is between the constant values of 'first' and 'last'.
      case >= first && <= last:
        print('in range');

      // Matches if obj is a record with two fields, then assigns the fields to 'a' and 'b'.
      case (var a, var b):
        print('a = $a, b = $b');

      default:
      // #enddocregion switch-statement
    }
  }
}
