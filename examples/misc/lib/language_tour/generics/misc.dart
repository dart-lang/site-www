// ignore_for_file: unused_local_variable
void miscDeclAnalyzedButNotTested() {
  {
    // #docregion why-generics
    var names = new List<String>();
    names.addAll(['Seth', 'Kathy', 'Lars']);
    names.add(42); // Error // ignore: argument_type_not_assignable
    // #enddocregion why-generics
  }

  {
    // #docregion collection-literals
    var names = <String>['Seth', 'Kathy', 'Lars'];
    var pages = <String, String>{
      'index.html': 'Homepage',
      'robots.txt': 'Hints for web robots',
      'humans.txt': 'We are people, not machines'
    };
    // #enddocregion collection-literals
  }
}
