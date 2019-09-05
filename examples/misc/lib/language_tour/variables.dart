// ignore_for_file: unused_local_variable

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion var-decl
    var name = 'Bob';
    // #enddocregion var-decl
  }

  {
    // #docregion type-decl
    dynamic name = 'Bob';
    // #enddocregion type-decl
  }

  {
    // #docregion static-types
    String name = 'Bob';
    // #enddocregion static-types
  }

  {
    // #docregion final
    final name = 'Bob'; // Without a type annotation
    final String nickname = 'Bobby';
    // #enddocregion final
  }

  {
    // #docregion const
    const bar = 1000000; // Unit of pressure (dynes/cm2)
    const double atm = 1.01325 * bar; // Standard atmosphere
    // #enddocregion const
  }

  {
    // #docregion const-vs-final
    var foo = const [];
    final bar = const [];
    const baz = []; // Equivalent to `const []`
    // #enddocregion const-vs-final

    // #docregion reassign-to-non-final
    foo = [1, 2, 3]; // Was const []
    // #enddocregion reassign-to-non-final
  }

  {
    var bar, baz, name;
    // #docregion cant-assign-to-final
    name = 'Alice'; // Error: a final variable can only be set once.
    // #enddocregion cant-assign-to-final
    // #docregion cant-assign-to-const
    baz = [42]; // Error: Constant variables can't be assigned a value.
    // #enddocregion cant-assign-to-const
  }

  {
    // #docregion const-dart-25
    // Valid compile-time constants as of Dart 2.5.
    const Object i = 3; // Where i is a const Object with an int value...
    const list = [i as int]; // Use a typecast.
    const map = {if (i is int) i: "int"}; // Use is and collection if.
    const set = {if (list is List<int>) ...list}; // ...and a spread.
    // #enddocregion const-dart-25
  }
}
