void main() {
  //BEGIN
  // Check whether a string contains another string.
  assert('Never odd or even'.contains('odd'));

  // Does a string start with another string?
  assert('Never odd or even'.startsWith('Never'));

  // Does a string end with another string?
  assert('Never odd or even'.endsWith('even'));

  // Find the location of a string inside a string.
  assert('Never odd or even'.indexOf('odd') == 6);
  //END

  //BEGIN
  // Grab a substring.
  assert('Never odd or even'.substring(6, 9) == 'odd');

  // Split a string using a string pattern.
  var parts = 'structured web apps'.split(' ');
  assert(parts.length == 3);
  assert(parts[0] == 'structured');

  // Get a UTF-16 code unit (as a string) by index.
  assert('Never odd or even'[0] == 'N');

  // Use split() with an empty string parameter to get
  // a list of all characters (as Strings); good for
  // iterating.
  for (var char in 'hello'.split('')) {
    print(char);
  }

  // Get all the UTF-16 code units in the string.
  var codeUnitList = 'Never odd or even'.codeUnits.toList();
  assert(codeUnitList[0] == 78);
//END

  // UNUSED.
  // Get all the characters in the string as a Runes object,
  // which contains one item per character.
  var runes = 'Never odd or even'.runes;
  assert(runes.length == 17);

  //BEGIN
  // Convert to uppercase.
  assert('structured web apps'.toUpperCase() == 'STRUCTURED WEB APPS');

  // Convert to lowercase.
  assert('STRUCTURED WEB APPS'.toLowerCase() == 'structured web apps');
  //END

  //BEGIN
  // Trim a string.
  assert('  hello  '.trim() == 'hello');

  // Check whether a string is empty.
  assert(''.isEmpty);

  // Strings with only white space are not empty.
  assert('  '.isNotEmpty);
  //END

  //BEGIN
  var greetingTemplate = 'Hello, NAME!';
  var greeting = greetingTemplate.replaceAll(new RegExp('NAME'), 'Bob');

  assert(greeting != greetingTemplate); // greetingTemplate didn't change.
  //END

  buildingAString();
  regularExpressions();
  regularExpressions2();
}

void buildingAString() {
  //NOTE: DID NOT USE A METHOD CASCADE. BROKE due to add return type changing.
  //Then add and addAll were deprecated in favor of write and writeAll,
  //and clear() was removed.
  //BEGIN
  var sb = new StringBuffer();
  sb
    ..write('Use a StringBuffer for ')
    ..writeAll(['efficient', 'string', 'creation'], ' ')
    ..write('.');

  var fullString = sb.toString();

  assert(fullString == 'Use a StringBuffer for efficient string creation.');
  //END

//  clear() is gone. For now, at least.
//  sb.clear();  // All gone!
//  assert(sb.toString() == '');
}

void regularExpressions() {
  // Here's a regular expression for one or more digits.
  var numbers = new RegExp(r'\d+');
  //NOTE: WAS: var numbers = const RegExp(r'\d+');

  var allCharacters = 'llamas live fifteen to twenty years';
  var someDigits = 'llamas live 15 to 20 years';

  // contains() can use a regular expression.
  assert(!allCharacters.contains(numbers));
  assert(someDigits.contains(numbers));

  // Replace every match with another string.
  var exedOut = someDigits.replaceAll(numbers, 'XX');
  assert(exedOut == 'llamas live XX to XX years');
}

void regularExpressions2() {
  var numbers = new RegExp(r'\d+');
  //NOTE: WAS: var numbers = const RegExp(r'\d+');
  var someDigits = 'llamas live 15 to 20 years';

  // Check whether the reg exp has a match in a string.
  assert(numbers.hasMatch(someDigits));

  // Loop through all matches.
  for (var match in numbers.allMatches(someDigits)) {
    print(match.group(0)); // 15, then 20
  }
}
