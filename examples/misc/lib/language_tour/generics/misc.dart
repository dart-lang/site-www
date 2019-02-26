import 'base_class.dart';

// ignore_for_file: unused_local_variable
void miscDeclAnalyzedButNotTested() {
  {
    // #docregion why-generics
    var names = List<String>();
    names.addAll(['Seth', 'Kathy', 'Lars']);
    names.add(42); // Error // ignore: argument_type_not_assignable
    // #enddocregion why-generics
  }

  {
    // #docregion collection-literals
    var names = <String>['Seth', 'Kathy', 'Lars'];
    var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
    var pages = <String, String>{
      'index.html': 'Homepage',
      'robots.txt': 'Hints for web robots',
      'humans.txt': 'We are people, not machines'
    };
    // #enddocregion collection-literals
  }

  {
    // ignore_for_file: 2, type_argument_not_matching_bounds
    // Specifying any non-SomeBaseClass type results in an error.
    // #docregion Foo-Object-error
    var foo = Foo<Object>(); //!analysis-issue
    // #enddocregion Foo-Object-error
  }
}
