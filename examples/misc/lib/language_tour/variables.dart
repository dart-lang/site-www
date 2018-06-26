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
    // name = 'Alice';  // Uncommenting this causes an error
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
    // Note: [] creates an empty list.
    // const [] creates an empty, immutable list (EIL).
    var foo = const []; // foo is currently an EIL.
    final bar = const []; // bar will always be an EIL.
    const baz = []; // baz is a compile-time constant EIL.

    // You can change the value of a non-final, non-const variable,
    // even if it used to have a const value.
    foo = [];

    // You can't change the value of a final or const variable.
    // bar = []; // Unhandled exception.
    // baz = []; // Unhandled exception.
    // #enddocregion const-vs-final
  }
}
