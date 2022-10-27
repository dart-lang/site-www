void miscDeclAnalyzedButNotTested() {
  var fruits = <String>[];
  // #docregion List-of-String
  // ignore: argument_type_not_assignable, unused_local_variable
  fruits.add(5); // Error: 'int' can't be assigned to 'String'
  // #enddocregion List-of-String
}
