// BEGIN(map_literal)
var gifts = {
// Keys      Values
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings'
};

var nobleGases = {
// Keys  Values
  2: 'helium',
  10: 'neon',
  18: 'argon',
};
// END(map_literal)

main() {
  // BEGIN(map_const_literal)
  final constantMap = const {2: 'helium', 10: 'neon', 18: 'argon',};

  // constantMap[2] = 'Helium'; // Uncommenting this causes an error.
  // END(map_const_literal)

  nobleGases[2] = 'Helium'; // You can do this.
  try {
    constantMap[2] = 'Helium'; // You can't do this.
  } catch (e) {
    print('Tsk tsk! $e');
  }
}

//36: 'krypton',
//54: 'xenon',
//86: 'radon',
