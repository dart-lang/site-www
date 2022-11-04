import 'package:test/test.dart';
import 'package:examples/language_tour/characters.dart' as characters;

void main() {
  test('characters_usage', () {
    expect(
        characters.main,
        prints(
            'Hi 🇩🇰\nThe end of the string: \u{DDF0}\nThe last character: 🇩🇰\n'));
  });
}
