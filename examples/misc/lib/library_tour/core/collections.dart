void miscDeclAnalyzedButNotTested() {
  var fruits = <String>[];
  // #docregion list-of-string
  // ignore: argument_type_not_assignable, unused_local_variable
  fruits.add(5); // Error: 'int' can't be assigned to 'String'
  // #enddocregion list-of-string
}
