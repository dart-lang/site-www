library sdk_builds.test;

import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:test/test.dart';

DartDownloads _dd;

main() async {
  setUp(() {
    _dd = new DartDownloads();
  });

  tearDown(() {
    if (_dd != null) {
      _dd.close();
    }
    _dd = null;
  });

  test('fetch version', () async {
    var revision = '31822';
    var channel = 'stable';

    var version = await _dd.fetchVersion(channel, revision);

    expect(version.version, new Version.parse('1.1.1'));
  });

  test('fetch version paths', () async {
    var channel = 'stable';

    var paths = await _dd.fetchVersionPaths(channel).toList();

    expect(paths, contains('channels/stable/release/29803/'));
    expect(paths, contains('channels/stable/release/latest/'));
    expect(paths.length, greaterThanOrEqualTo(28));
  });

  test('fetchVersions', () async {
    var versions = await _dd.fetchVersions('stable');

    expect(versions.length, greaterThanOrEqualTo(27));
  });

  group('fetchVersion', () {
    test('recent git build', () async {
      var channel = 'dev';
      var revision = '1.11.0-dev.5.2';

      var content = await _dd.fetchVersion(channel, revision) as GitVersionInfo;

      expect(content.ref, '23736d3630da614c655d0569e1ba5af2021b1c61');
      expect(content.version, new Version.parse('1.11.0-dev.5.2'));
      expect(content.date, new DateTime(2015, 6, 11));
    });

    test('recent svn build', () async {
      var channel = 'stable';
      var revision = '44672';

      var content = await _dd.fetchVersion(channel, revision) as SvnVersionInfo;

      expect(content.revision, 44672);
      expect(content.version, new Version.parse('1.9.1'));
      expect(content.date, new DateTime.utc(2015, 3, 25, 3, 47));
    });

    test('old revision with old date format', () async {
      // dev/release/30039 - 0.8.10.8_r30039
      var content = await _dd.fetchVersion('dev', '30039') as SvnVersionInfo;

      expect(content.revision, 30039);
      expect(content.version, new Version.parse('0.8.10-rev.8.30039'));
      expect(content.date, new DateTime.utc(2013, 11, 7, 3, 48));
    });
  });

  test('downloadLink', () async {
    var channel = 'stable';
    var revision = '44672';

    var content = await _dd.createDownloadUrl(
        channel, revision, 'api-docs/dart-api-docs.zip');
    expect(content.pathSegments, [
      'download',
      'storage',
      'v1',
      'b',
      'dart-archive',
      'o',
      'channels/$channel/release/$revision/api-docs/dart-api-docs.zip'
    ]);
  });
}
