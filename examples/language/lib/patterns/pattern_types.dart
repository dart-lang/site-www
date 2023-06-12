// ignore_for_file: duplicate_variable_pattern, duplicate_definition, unused_local_variable
// ignore_for_file: dead_code, constant_pattern_never_matches_value_type, unnecessary_null_check_pattern
// ignore_for_file: pattern_never_matches_value_type, unreachable_switch_case

sealed class Shape {}

class Square implements Shape {
  final double size;
  Square(this.size);
}

class Circle implements Shape {
  final double size;
  Circle(this.size);
}

class Color {
  static const red = true;
  static const yellow = false;
  static const blue = true;
}

class Rect {
  final int width;
  final int height;
  Rect({required this.width, required this.height});
}

class Point {
  final int? x;
  final int? y;

  Point(this.x, this.y);
}

void miscDeclAnalyzedButNotTested() {
  var shape = Square(10);
  const a = 1;
  const b = 2;
  Object? obj;

  {
    // #docregion cast
    (num, Object) record = (1, 's');
    var (i as int, s as String) = record;
    // #enddocregion cast
  }

  {
    var number = 1;
    // #docregion constant
    switch (number) {
      // Matches if 1 == number.
      case 1: // ...
    }
    // #enddocregion constant
  }

  {
    switch ([1, 2]) {
      // #docregion complex-constant
      // List or map pattern:
      case [a, b]: // ...

      // List or map literal:
      case const [a, b]: // ...
      // #enddocregion complex-constant
    }
  }

  {
    // #docregion match-context
    const c = 1;
    switch (2) {
      case c:
        print('match $c');
      default:
        print('no match'); // Prints "no match".
    }
    // #enddocregion match-context
  }

  {
    // #docregion rest
    var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
    // Prints "1 2 6 7".
    print('$a $b $c $d');
    // #enddocregion rest
  }

  {
    // #docregion rest-sub
    var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
    // Prints "1 2 [3, 4, 5] 6 7".
    print('$a $b $rest $c $d');
    // #enddocregion rest-sub
  }

  {
    // #docregion logical-and
    switch ((1, 2)) {
      // Error, both subpatterns attempt to bind 'b'.
      case (var a, var b) && (var b, var c): // ...
    }
    // #enddocregion logical-and
  }

  {
    var color = Color();
    // #docregion logical-or
    var isPrimary = switch (color) {
      Color.red || Color.yellow || Color.blue => true,
      _ => false
    };
    // #enddocregion logical-or
  }

  {
    var shape = Square(10);
    // #docregion share-guard
    switch (shape) {
      case Square(size: var s) || Circle(size: var s) when s > 0:
        print('Non-empty symmetric shape');
    }
    // #enddocregion share-guard
  }

  {
    // #docregion null-assert-match
    List<String?> row = ['user', null];
    switch (row) {
      case ['user', var name!]: // ...
      // 'name' is a non-nullable string here.
    }
    // #enddocregion null-assert-match
  }

  {
    // #docregion null-assert-dec
    (int?, int?) position = (2, 3);

    var (x!, y!) = position;
    // #enddocregion null-assert-dec
  }

  {
    // #docregion null-check
    String? maybeString = 'nullable with base type String';
    switch (maybeString) {
      case var s?:
      // 's' has type non-nullable String here.
    }
    // #enddocregion null-check
  }

  {
    // #docregion object
    switch (shape) {
      // Matches if shape is of type Rect, and then against the properties of Rect.
      case Rect(width: var w, height: var h): // ...
    }
    // #enddocregion object
  }

  {
    // #docregion object-getter
    // Binds new variables x and y to the values of Point's x and y properties.
    var Point(:x, :y) = Point(1, 2);
    // #enddocregion object-getter
  }

  {
    // #docregion record
    var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 1);
    // #enddocregion record
  }

  {
    var record = (untyped: '1', typed: 2);
    // #docregion record-getter
    // Record pattern with variable subpatterns:
    var (untyped: untyped, typed: int typed) = record;
    var (:untyped, :int typed) = record;

    switch (record) {
      case (untyped: var untyped, typed: int typed): // ...
      case (:var untyped, :int typed): // ...
    }

    // Record pattern wih null-check and null-assert subpatterns:
    switch (record) {
      case (checked: var checked?, asserted: var asserted!): // ...
      case (:var checked?, :var asserted!): // ...
    }

    // Record pattern wih cast subpattern:
    var (untyped: untyped as int, typed: typed as String) = record;
    var (:untyped as int, :typed as String) = record;
    // #enddocregion record-getter
  }

  {
    // #docregion relational
    String asciiCharType(int char) {
      const space = 32;
      const zero = 48;
      const nine = 57;

      return switch (char) {
        < space => 'control',
        == space => 'space',
        > space && < zero => 'punctuation',
        >= zero && <= nine => 'digit',
        _ => ''
      };
    }
    // #enddocregion relational

    assert(asciiCharType(32) == 'space');
  }

  {
    // #docregion variable
    switch ((1, 2)) {
      // 'var a' and 'var b' are variable patterns that bind to 1 and 2, respectively.
      case (var a, var b): // ...
      // 'a' and 'b' are in scope in the case body.
    }
    // #enddocregion variable
  }

  {
    // #docregion variable-typed
    switch ((1, 2)) {
      // Does not match.
      case (int a, String b): // ...
    }
    // #enddocregion variable-typed
  }

  {
    // #docregion wildcard
    var list = [1, 2, 3];
    var [_, two, _] = list;
    // #enddocregion wildcard
  }

  {
    var record = (1, 'one');
    // #docregion wildcard-typed
    switch (record) {
      case (int _, String _):
        print('First field is int and second is String.');
    }
    // #enddocregion wildcard-typed
  }

  {
    const x = true;
    const y = true;
    const z = false;
    var result = true;

    var token = switch (result) {
      // #docregion parens
      // ...
      x || y && z => 'matches true',
      (x || y) && z => 'matches false',
      // ...
      // #enddocregion parens
      _ => throw FormatException('Invalid')
    };
  }
}
