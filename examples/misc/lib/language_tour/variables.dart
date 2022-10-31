// ignore_for_file: unused_local_variable, dead_code

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion var-decl
    var name = 'Bob';
    // #enddocregion var-decl
  }

  {
    // #docregion type-decl
    Object name = 'Bob';
    // #enddocregion type-decl
  }

  {
    // #docregion static-types
    String name = 'Bob';
    // #enddocregion static-types
  }

  {
    // #docregion var-late-top-level
    late String description;

    void main() {
      description = 'Feijoada!';
      print(description);
    }
    // #enddocregion var-late-top-level

    main();
  }

  {
    String readThermometer() {
      print('in _readThermometer()');
      return '37.0';
    }

    {
      // #docregion var-late-lazy
      // This is the program's only call to readThermometer().
      late String temperature = readThermometer(); // Lazily initialized.
      // #enddocregion var-late-lazy
      print('$temperature degrees');
      // #docregion var-ns-init
      int lineCount = 0;
      // #enddocregion var-ns-init
    }

    {
      bool weLikeToCount = false;
      int countLines() => 1;
      {
        // #docregion var-ns-flow
        int lineCount;

        if (weLikeToCount) {
          lineCount = countLines();
        } else {
          lineCount = 0;
        }

        print(lineCount);
        // #enddocregion var-ns-flow
      }
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
      dynamic bar, baz, name;
      // #docregion cant-assign-to-final
      name = 'Alice'; // Error: a final variable can only be set once.
      // #enddocregion cant-assign-to-final
      // #docregion cant-assign-to-const
      baz = [42]; // Error: Constant variables can't be assigned a value.
      // #enddocregion cant-assign-to-const
    }

    {
      // #docregion const-dart-25
      const Object i = 3; // Where i is a const Object with an int value...
      const list = [i as int]; // Use a typecast.
      // ignore: unnecessary_type_check
      const map = {if (i is int) i: 'int'}; // Use is and collection if.
      // ignore: unnecessary_type_check
      const set = {if (list is List<int>) ...list}; // ...and a spread.
      // #enddocregion const-dart-25
    }
  }
}
