// ignore_for_file: unused_local_variable

class Foo {
  final String one;
  final int two;
  Foo({required this.one, required this.two});
}

void main() {
  // #docregion list-pattern
  var numList = [1, 2, 3];
  // List pattern [a, b, c] destructures the three elements from numList...
  var [a, b, c] = numList;
  // ...and assigns them to new variables.
  print(a + b + c);
  // #enddocregion list-pattern

  var list = ['b', 'c'];
  // #docregion nested-pattern
  switch (list) {
    case ['a' || 'b', var c]:
      print(c);
  }
  // #enddocregion nested-pattern

  {
    // #docregion variable-declaration
    // Declares new variables a, b, and c.
    var (a, [b, c]) = ('str', [1, 2]);
    // #enddocregion variable-declaration
  }
  {
    // #docregion variable-assignment
    var (a, b) = ('left', 'right');
    (b, a) = (a, b); // Swap.
    print('$a $b'); // Prints "right left".
    // #enddocregion variable-assignment
  }

  {
    (String, int) userInfo(Map<String, dynamic> json) {
      return ('doug', 25);
    }

    var json = <String, dynamic>{};

    {
      // #docregion destructure-multiple-returns-1
      var info = userInfo(json);
      var name = info.$1;
      var age = info.$2;
      // #enddocregion destructure-multiple-returns-1
    }

    {
      // #docregion destructure-multiple-returns-2
      var (name, age) = userInfo(json);
      // #enddocregion destructure-multiple-returns-2
    }
  }
  {
    // #docregion destructure-class-instances
    final Foo myFoo = Foo(one: 'one', two: 2);
    var Foo(:one, :two) = myFoo;
    print('one $one, two $two');
    // #enddocregion destructure-class-instances
  }
}
