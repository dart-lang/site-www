void miscDeclAnalyzedButNotTested() {
  var fruits = List<String>();
  // ignore_for_file: stable, dev, argument_type_not_assignable, unused_local_variable
  // #docregion List-of-String
  fruits.add(5); // Error: 'int' can't be assigned to 'String'
  // #enddocregion List-of-String
}
