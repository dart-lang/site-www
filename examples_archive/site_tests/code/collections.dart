void main() {
  Map famousDuos = { 'Han Solo': 'Chewbacca',      // Map literal.
                     'Bonnie': 'Clyde',
                     'Laurel': 'Hardy' };
  List myFriends = [ 'Seth', 'Kathy', 'Shailen' ]; // List literal.

  // Create lists and maps from Iterable objects.
  List shuffledSidekicks = new List.from(famousDuos.values)..shuffle();
  Map mixedDuos = new Map.fromIterables(famousDuos.keys, shuffledSidekicks);

  // Iteration.
  mixedDuos.forEach((k, v) { print('$k, $v'); });

  // Some lists, maps, and sets are growable.
  Set setOfMyFriends = new Set.from(myFriends);
  Set famousPeople = new Set.from(famousDuos.values);
  famousPeople.addAll(famousDuos.keys);

  // Rich set of functionality for collections.
  print(famousPeople.intersection(setOfMyFriends).isEmpty);
  print(famousPeople.union(setOfMyFriends).length);
}
