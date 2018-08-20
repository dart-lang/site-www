void main() {
  getAndPutItems();
  checkForItems();
  intersectAndSuperset();
}

void getAndPutItems() {
  var ingredients = new Set();
  ingredients.addAll(['gold', 'titanium', 'xenon']);
  assert(ingredients.length == 3);

  // Adding a duplicate item has no effect.
  ingredients.add('gold');
  assert(ingredients.length == 3);

  // Remove an item from a set.
  ingredients.remove('gold');
  assert(ingredients.length == 2);
}

void checkForItems() {
  var ingredients = new Set();
  ingredients.addAll(['gold', 'titanium', 'xenon']);

  // Check whether an item is in the set.
  assert(ingredients.contains('titanium'));

  // Check whether all the items are in the set.
  assert(ingredients.containsAll(['titanium', 'xenon']));
}

void intersectAndSuperset() {
  var ingredients = new Set();
  ingredients.addAll(['gold', 'titanium', 'xenon']);

  // Create the intersection of two sets.
  var nobleGases = new Set.from(['xenon', 'argon']);
  var intersection = ingredients.intersection(nobleGases);
  assert(intersection.length == 1);
  assert(intersection.contains('xenon'));

  // Check whether one set is a superset of another collection.
  var allElements = [
    'hydrogen',
    'helium',
    'lithium',
    'beryllium',
    'gold',
    'titanium',
    'xenon' /* all the rest */
  ];
  assert(allElements.toSet().containsAll(ingredients));
}
