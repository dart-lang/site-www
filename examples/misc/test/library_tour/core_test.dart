// ignore_for_file: type_annotate_public_apis, prefer_collection_literals, avoid_function_literals_in_foreach_calls
import 'package:test/test.dart';

import 'package:examples/library_tour/core/comparable.dart' as comparable;
import 'package:examples/library_tour/core/hash_code.dart' as hash_code;
import 'package:examples/library_tour/core/iterator.dart' as iterator;
import 'package:examples_util/print_matcher.dart' as m;

void main() {
  group('print:', () {
    test('print(nonString)', () {
      final anObject = [1, 2, 3];
      expect(() {
        // #docregion print
        print(anObject);
        // #enddocregion print
      }, m.prints(anObject.toString()));
    });

    test('print(String)', () {
      expect(() {
        final tea = 'chamomile tea';

        // #docregion print
        print('I drink $tea.');
        // #enddocregion print
      }, m.prints('I drink chamomile tea.'));
    });
  });

  group('numbers:', () {
    test('int|double.parse()', () {
      // #docregion int-double-parse
      assert(int.parse('42') == 42);
      assert(int.parse('0x42') == 66);
      assert(double.parse('0.50') == 0.5);
      // #enddocregion int-double-parse
    });

    test('num.parse()', () {
      // #docregion num-parse
      assert(num.parse('42') is int);
      assert(num.parse('0x42') is int);
      assert(num.parse('0.50') is double);
      // #enddocregion num-parse
    });

    test('radix', () {
      // #docregion radix
      assert(int.parse('42', radix: 16) == 66);
      // #enddocregion radix
    });

    test('toString()', () {
      // #docregion toString-
      // Convert an int to a string.
      assert(42.toString() == '42');

      // Convert a double to a string.
      assert(123.456.toString() == '123.456');

      // Specify the number of digits after the decimal.
      assert(123.456.toStringAsFixed(2) == '123.46');

      // Specify the number of significant figures.
      assert(123.456.toStringAsPrecision(2) == '1.2e+2');
      assert(double.parse('1.2e+2') == 120.0);
      // #enddocregion toString-
    });
  });

  group('strings and regexp:', () {
    test('contains-etc', () {
      // #docregion contains-etc
      // Check whether a string contains another string.
      assert('Never odd or even'.contains('odd'));

      // Does a string start with another string?
      assert('Never odd or even'.startsWith('Never'));

      // Does a string end with another string?
      assert('Never odd or even'.endsWith('even'));

      // Find the location of a string inside a string.
      assert('Never odd or even'.indexOf('odd') == 6);
      // #enddocregion contains-etc
    });

    test('substring-etc', () {
      void testSubstring() {
        // #docregion substring-etc
        // Grab a substring.
        assert('Never odd or even'.substring(6, 9) == 'odd');

        // Split a string using a string pattern.
        var parts = 'progressive web apps'.split(' ');
        assert(parts.length == 3);
        assert(parts[0] == 'progressive');

        // Get a UTF-16 code unit (as a string) by index.
        assert('Never odd or even'[0] == 'N');

        // Use split() with an empty string parameter to get
        // a list of all characters (as Strings); good for
        // iterating.
        for (final char in 'hello'.split('')) {
          print(char);
        }

        // Get all the UTF-16 code units in the string.
        var codeUnitList = 'Never odd or even'.codeUnits.toList();
        assert(codeUnitList[0] == 78);
        // #enddocregion substring-etc
      }

      expect(testSubstring, m.prints(['h', 'e', 'l', 'l', 'o']));
    });

    test('change case', () {
      // #docregion toUpperCase-toLowerCase
      // Convert to uppercase.
      assert('web apps'.toUpperCase() == 'WEB APPS');

      // Convert to lowercase.
      assert('WEB APPS'.toLowerCase() == 'web apps');
      // #enddocregion toUpperCase-toLowerCase
    });

    test('trim-etc', () {
      // #docregion trim-etc
      // Trim a string.
      assert('  hello  '.trim() == 'hello');

      // Check whether a string is empty.
      assert(''.isEmpty);

      // Strings with only white space are not empty.
      assert('  '.isNotEmpty);
      // #enddocregion trim-etc
    });

    test('replace', () {
      // #docregion replace
      var greetingTemplate = 'Hello, NAME!';
      var greeting = greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

      // greetingTemplate didn't change.
      assert(greeting != greetingTemplate);
      // #enddocregion replace
    });

    test('StringBuffer', () {
      // #docregion StringBuffer
      var sb = StringBuffer();
      sb
        ..write('Use a StringBuffer for ')
        ..writeAll(['efficient', 'string', 'creation'], ' ')
        ..write('.');

      var fullString = sb.toString();

      assert(fullString == 'Use a StringBuffer for efficient string creation.');
      // #enddocregion StringBuffer
    });

    test('RegExp', () {
      // #docregion RegExp
      // Here's a regular expression for one or more digits.
      var numbers = RegExp(r'\d+');

      var allCharacters = 'llamas live fifteen to twenty years';
      var someDigits = 'llamas live 15 to 20 years';

      // contains() can use a regular expression.
      assert(!allCharacters.contains(numbers));
      assert(someDigits.contains(numbers));

      // Replace every match with another string.
      var exedOut = someDigits.replaceAll(numbers, 'XX');
      assert(exedOut == 'llamas live XX to XX years');
      // #enddocregion RegExp
    });

    test('match', () {
      void testMatch() {
        // #docregion match
        var numbers = RegExp(r'\d+');
        var someDigits = 'llamas live 15 to 20 years';

        // Check whether the reg exp has a match in a string.
        assert(numbers.hasMatch(someDigits));

        // Loop through all matches.
        for (final match in numbers.allMatches(someDigits)) {
          print(match.group(0)); // 15, then 20
        }
        // #enddocregion match
      }

      expect(testMatch, m.prints([15, 20]));
    });
  });

  group('Collections: List:', () {
    test('constructor', () {
      // #docregion List
      // Create an empty list of strings.
      var grains = <String>[];
      assert(grains.isEmpty);

      // Create a list using a list literal.
      var fruits = ['apples', 'oranges'];

      // Add to a list.
      fruits.add('kiwis');

      // Add multiple items to a list.
      fruits.addAll(['grapes', 'bananas']);

      // Get the list length.
      assert(fruits.length == 5);

      // Remove a single item.
      var appleIndex = fruits.indexOf('apples');
      fruits.removeAt(appleIndex);
      assert(fruits.length == 4);

      // Remove all elements from a list.
      fruits.clear();
      assert(fruits.isEmpty);

      // You can also create a List using one of the constructors.
      var vegetables = List.filled(99, 'broccoli');
      assert(vegetables.every((v) => v == 'broccoli'));
      // #enddocregion List
    });

    test('indexOf', () {
      // #docregion indexOf
      var fruits = ['apples', 'oranges'];

      // Access a list item by index.
      assert(fruits[0] == 'apples');

      // Find an item in a list.
      assert(fruits.indexOf('apples') == 0);
      // #enddocregion indexOf
    });

    test('compareTo', () {
      // #docregion compareTo
      var fruits = ['bananas', 'apples', 'oranges'];

      // Sort a list.
      fruits.sort((a, b) => a.compareTo(b));
      assert(fruits[0] == 'apples');
      // #enddocregion compareTo
    });

    test('List-of-String', () {
      // #docregion List-of-String
      // This list should contain only strings.
      var fruits = <String>[];

      fruits.add('apples');
      var fruit = fruits[0];
      // ignore: unnecessary_type_check
      assert(fruit is String);
      // #enddocregion List-of-String
    });
  });

  group('Collections: Set', () {
    test('constructor', () {
      // #docregion Set
      // Create an empty set of strings.
      var ingredients = <String>{};

      // Add new items to it.
      ingredients.addAll(['gold', 'titanium', 'xenon']);
      assert(ingredients.length == 3);

      // Adding a duplicate item has no effect.
      ingredients.add('gold');
      assert(ingredients.length == 3);

      // Remove an item from a set.
      ingredients.remove('gold');
      assert(ingredients.length == 2);

      // You can also create sets using
      // one of the constructors.
      var atomicNumbers = Set.from([79, 22, 54]);
      // #enddocregion Set
      expect(ingredients, isNot(contains('gold')));
      expect(atomicNumbers, isNotEmpty);
    });

    test('contains', () {
      // #docregion contains
      var ingredients = Set<String>();
      ingredients.addAll(['gold', 'titanium', 'xenon']);

      // Check whether an item is in the set.
      assert(ingredients.contains('titanium'));

      // Check whether all the items are in the set.
      assert(ingredients.containsAll(['titanium', 'xenon']));
      // #enddocregion contains
    });

    test('intersection', () {
      // #docregion intersection
      var ingredients = Set<String>();
      ingredients.addAll(['gold', 'titanium', 'xenon']);

      // Create the intersection of two sets.
      var nobleGases = Set.from(['xenon', 'argon']);
      var intersection = ingredients.intersection(nobleGases);
      assert(intersection.length == 1);
      assert(intersection.contains('xenon'));
      // #enddocregion intersection
    });
  });

  group('Collections: Map', () {
    test('constructor', () {
      // #docregion Map
      // Maps often use strings as keys.
      var hawaiianBeaches = {
        'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
        'Big Island': ['Wailea Bay', 'Pololu Beach'],
        'Kauai': ['Hanalei', 'Poipu']
      };

      // Maps can be built from a constructor.
      var searchTerms = Map();

      // Maps are parameterized types; you can specify what
      // types the key and value should be.
      var nobleGases = Map<int, String>();
      // #enddocregion Map
      assert(hawaiianBeaches.isNotEmpty);
      assert(searchTerms.isEmpty);
      assert(nobleGases.isEmpty);
    });

    test('remove', () {
      // #docregion remove
      var nobleGases = {54: 'xenon'};

      // Retrieve a value with a key.
      assert(nobleGases[54] == 'xenon');

      // Check whether a map contains a key.
      assert(nobleGases.containsKey(54));

      // Remove a key and its value.
      nobleGases.remove(54);
      assert(!nobleGases.containsKey(54));
      // #enddocregion remove
    });

    test('keys', () {
      // #docregion keys
      var hawaiianBeaches = {
        'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
        'Big Island': ['Wailea Bay', 'Pololu Beach'],
        'Kauai': ['Hanalei', 'Poipu']
      };

      // Get all the keys as an unordered collection
      // (an Iterable).
      var keys = hawaiianBeaches.keys;

      assert(keys.length == 3);
      assert(Set.from(keys).contains('Oahu'));

      // Get all the values as an unordered collection
      // (an Iterable of Lists).
      var values = hawaiianBeaches.values;
      assert(values.length == 3);
      assert(values.any((v) => v.contains('Waikiki')));
      // #enddocregion keys
    });

    test('containsKey', () {
      // #docregion containsKey
      var hawaiianBeaches = {
        'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
        'Big Island': ['Wailea Bay', 'Pololu Beach'],
        'Kauai': ['Hanalei', 'Poipu']
      };

      assert(hawaiianBeaches.containsKey('Oahu'));
      assert(!hawaiianBeaches.containsKey('Florida'));
      // #enddocregion containsKey
    });

    test('putIfAbsent', () {
      String pickToughestKid() => 'Rock';
      // #docregion putIfAbsent
      var teamAssignments = <String, String>{};
      teamAssignments.putIfAbsent('Catcher', () => pickToughestKid());
      assert(teamAssignments['Catcher'] != null);
      // #enddocregion putIfAbsent
    });
  });

  group('Collections: Common methods:', () {
    // Because of code excerpt formatting issues, it is a bit messy
    // to avoid repeating the `var teas` declaration in each code excerpt.
    // Instead, we provide a group-global declaration `teasCheck`
    // and check that the code-excerpt-local `teas` matches `teasCheck`.
    final teasCheck = ['green', 'black', 'chamomile', 'earl grey'];

    test('isEmpty', () {
      // #docregion isEmpty
      var coffees = <String>[];
      var teas = ['green', 'black', 'chamomile', 'earl grey'];
      assert(coffees.isEmpty);
      assert(teas.isNotEmpty);
      // #enddocregion isEmpty
      expect(teas, teasCheck);
    });

    test('List.forEach()', () {
      void testForEach() {
        // #docregion List-forEach
        var teas = ['green', 'black', 'chamomile', 'earl grey'];

        teas.forEach((tea) => print('I drink $tea'));
        // #enddocregion List-forEach
        expect(teas, teasCheck);
      }

      expect(testForEach, m.prints(teasCheck.map((tea) => 'I drink $tea')));
    });

    test('Map.forEach()', () {
      void testForEach() {
        final hawaiianBeaches = {'Honolulu': 'Hanauma Bay'};
        // #docregion Map-forEach
        hawaiianBeaches.forEach((k, v) {
          print('I want to visit $k and swim at $v');
          // I want to visit Oahu and swim at
          // [Waikiki, Kailua, Waimanalo], etc.
        });
        // #enddocregion Map-forEach
      }

      expect(testForEach,
          m.prints('I want to visit Honolulu and swim at Hanauma Bay'));
    });

    test('List.map()', () {
      void testListMap() {
        // #docregion List-map
        var teas = ['green', 'black', 'chamomile', 'earl grey'];

        var loudTeas = teas.map((tea) => tea.toUpperCase());
        loudTeas.forEach(print);
        // #enddocregion List-map
        expect(teas, teasCheck);
      }

      expect(testListMap, m.prints(teasCheck.map((tea) => tea.toUpperCase())));
    });

    test('toList()', () {
      var teas = <String>[];
      // #docregion toList
      var loudTeas = teas.map((tea) => tea.toUpperCase()).toList();
      // #enddocregion toList
      // ignore: unnecessary_type_check
      expect(loudTeas is List, isTrue);
    });

    test('where-etc', () {
      // #docregion where-etc
      var teas = ['green', 'black', 'chamomile', 'earl grey'];

      // Chamomile is not caffeinated.
      bool isDecaffeinated(String teaName) => teaName == 'chamomile';

      // Use where() to find only the items that return true
      // from the provided function.
      var decaffeinatedTeas = teas.where((tea) => isDecaffeinated(tea));
      // or teas.where(isDecaffeinated)

      // Use any() to check whether at least one item in the
      // collection satisfies a condition.
      assert(teas.any(isDecaffeinated));

      // Use every() to check whether all the items in a
      // collection satisfy a condition.
      assert(!teas.every(isDecaffeinated));
      // #enddocregion where-etc
      assert(decaffeinatedTeas.isNotEmpty);
    });
  });

  group('URIs', () {
    test('encodeFull', () {
      // #docregion encodeFull
      var uri = 'https://example.org/api?foo=some message';

      var encoded = Uri.encodeFull(uri);
      assert(encoded == 'https://example.org/api?foo=some%20message');

      var decoded = Uri.decodeFull(encoded);
      assert(uri == decoded);
      // #enddocregion encodeFull
    });

    test('encodeComponent', () {
      // #docregion encodeComponent
      var uri = 'https://example.org/api?foo=some message';

      var encoded = Uri.encodeComponent(uri);
      assert(
          encoded == 'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message');

      var decoded = Uri.decodeComponent(encoded);
      assert(uri == decoded);
      // #enddocregion encodeComponent
    });

    test('Uri.parse', () {
      // #docregion Uri-parse
      var uri = Uri.parse('https://example.org:8080/foo/bar#frag');

      assert(uri.scheme == 'https');
      assert(uri.host == 'example.org');
      assert(uri.path == '/foo/bar');
      assert(uri.fragment == 'frag');
      assert(uri.origin == 'https://example.org:8080');
      // #enddocregion Uri-parse
    });

    test('constructor', () {
      // #docregion Uri
      var uri = Uri(
          scheme: 'https',
          host: 'example.org',
          path: '/foo/bar',
          fragment: 'frag',
          queryParameters: {'lang': 'dart'});
      assert(uri.toString() == 'https://example.org/foo/bar?lang=dart#frag');
      // #enddocregion Uri
    });

    test('http constructors', () {
      // #docregion Uri-http
      var httpUri = Uri.http('example.org', '/foo/bar', {'lang': 'dart'});
      var httpsUri = Uri.https('example.org', '/foo/bar', {'lang': 'dart'});

      assert(httpUri.toString() == 'http://example.org/foo/bar?lang=dart');
      assert(httpsUri.toString() == 'https://example.org/foo/bar?lang=dart');
      // #enddocregion Uri-http
    });
  });

  group('DateTime:', () {
    test('DateTime', () {
      // #docregion DateTime
      // Get the current date and time.
      var now = DateTime.now();

      // Create a new DateTime with the local time zone.
      var y2k = DateTime(2000); // January 1, 2000

      // Specify the month and day.
      y2k = DateTime(2000, 1, 2); // January 2, 2000

      // Specify the date as a UTC time.
      y2k = DateTime.utc(2000); // 1/1/2000, UTC

      // Specify a date and time in ms since the Unix epoch.
      y2k = DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);

      // Parse an ISO 8601 date in the UTC time zone.
      y2k = DateTime.parse('2000-01-01T00:00:00Z');

      // Create a new DateTime from an existing one, adjusting just some properties:
      var sameTimeLastYear = now.copyWith(year: now.year - 1);
      // #enddocregion DateTime
      assert(2016 < now.year, 'Time travel is verboten!');
      expect(y2k.year, 2000);
      expect(sameTimeLastYear.year, now.year - 1);
    });

    test('millisecondsSinceEpoch', () {
      // #docregion millisecondsSinceEpoch
      // 1/1/2000, UTC
      var y2k = DateTime.utc(2000);
      assert(y2k.millisecondsSinceEpoch == 946684800000);

      // 1/1/1970, UTC
      var unixEpoch = DateTime.utc(1970);
      assert(unixEpoch.millisecondsSinceEpoch == 0);
      // #enddocregion millisecondsSinceEpoch
    });

    test('Duration', () {
      // #docregion Duration
      var y2k = DateTime.utc(2000);

      // Add one year.
      var y2001 = y2k.add(const Duration(days: 366));
      assert(y2001.year == 2001);

      // Subtract 30 days.
      var december2000 = y2001.subtract(const Duration(days: 30));
      assert(december2000.year == 2000);
      assert(december2000.month == 12);

      // Calculate the difference between two dates.
      // Returns a Duration object.
      var duration = y2001.difference(y2k);
      assert(duration.inDays == 366); // y2k was a leap year.
      // #enddocregion Duration
    });
  });

  group('Utility classes:', () {
    test('Comparable', () => comparable.main());
    test('hashCode and ==', () => hash_code.main());

    test('Iterator', () {
      expect(iterator.main, m.prints([0, 1, 2]));
    });
  });
}
