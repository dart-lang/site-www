import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:test/test.dart';

late DartDownloads _dartDownloads;

void main() async {
  setUp(() {
    _dartDownloads = DartDownloads();
  });

  tearDown(() {
    _dartDownloads.close();
  });

  test('fetch version', () async {
    const revision = '31822';
    const channel = 'stable';

    final version = await _dartDownloads.fetchVersion(channel, revision);

    expect(version.version, Version.parse('1.1.1'));
  });

  test('fetch version paths', () async {
    const channel = 'stable';

    final paths = await _dartDownloads.fetchVersionPaths(channel).toList();

    expect(paths, contains('channels/stable/release/29803/'));
    expect(paths, contains('channels/stable/release/latest/'));
    expect(paths.length, greaterThanOrEqualTo(28));
  });

  test('fetchVersions', () async {
    final versions = await _dartDownloads.fetchVersions('stable');

    expect(versions.length, greaterThanOrEqualTo(27));
  });

  group('fetchVersion', () {
    test('recent git build', () async {
      const channel = 'dev';
      const revision = '1.11.0-dev.5.2';

      final content = await _dartDownloads.fetchVersion(channel, revision)
          as GitVersionInfo;

      expect(content.ref, '23736d3630da614c655d0569e1ba5af2021b1c61');
      expect(content.version, Version.parse('1.11.0-dev.5.2'));
      expect(content.date, DateTime(2015, 6, 11));
    });

    test('recent svn build', () async {
      const channel = 'stable';
      const revision = '44672';

      final content = await _dartDownloads.fetchVersion(channel, revision)
          as SvnVersionInfo;

      expect(content.revision, 44672);
      expect(content.version, Version.parse('1.9.1'));
      expect(content.date, DateTime.utc(2015, 3, 25, 3, 47));
    });

    test('old revision with old date format', () async {
      // dev/release/30039 - 0.8.10.8_r30039
      final content =
          await _dartDownloads.fetchVersion('dev', '30039') as SvnVersionInfo;

      expect(content.revision, 30039);
      expect(content.version, Version.parse('0.8.10-rev.8.30039'));
      expect(content.date, DateTime.utc(2013, 11, 7, 3, 48));
    });
  });

  test('downloadLink', () async {
    const channel = 'stable';
    const revision = '44672';

    final content = await _dartDownloads.createDownloadLink(
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
