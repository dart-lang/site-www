// ignore_for_file: type_annotate_public_apis
// A list literal.
var lostNumbers = [4, 8, 15, 16, 23, 42];

// A map literal.
var nobleGases = {
  'He': 'Helium',
  'Ne': 'Neon',
  'Ar': 'Argon',
};

// A set literal.
var frogs = {
  'Tree',
  'Poison dart',
  'Glass',
};

main() {
  print(lostNumbers.last);
  print(nobleGases['Ne']);
  print(frogs.difference({'Poison dart'}));
}
