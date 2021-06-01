import 'package:test/test.dart';
import 'package:examples_util/print_matcher.dart' as m;
import 'package:examples/tutorial/daily_news.dart' as daily_news;

// #docregion sync-output
const news = '<gathered news goes here>';
const otherInfo = '''Winning lotto numbers: [23, 63, 87, 26, 2]
Tomorrow's forecast: 70F, sunny.
Baseball score: Red Sox 10, Yankees 0''';
// #enddocregion sync-output

void main() {
  test('sanity', () => expect(news, daily_news.news));
  group('daily news:', futures);
}

void futures() {
  test('sync', () {
    expect(
      daily_news.mainSync,
      m.prints([daily_news.news, otherInfo]),
    );
  });

  test('async', () {
    Future<void> _test() {
      daily_news.oneSecond = Duration.zero;
      return daily_news.mainAsync();
    }

    expect(
      _test,
      m.prints([otherInfo, daily_news.news]),
    );
  });
}
