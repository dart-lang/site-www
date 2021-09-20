// ignore_for_file: unused_local_variable
void miscDeclAnalyzedButNotTested() {
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
}

// #docregion non-nullable
class Foo<T extends Object> {
  // Any type provided to Foo for T must be non-nullable.
}
// #enddocregion non-nullable
