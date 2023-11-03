import 'package:dart_sdk_archive/src/util.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  group('dart_sdk_archive', () {
    test('can get all SDK versions', () async {
      final versions = await fetchSdkVersions('stable');
      expect(versions, isNotEmpty);
      expect(versions, contains(Version.parse('1.4.0')));
      expect(versions, contains(Version.parse('2.3.1')));
    });
  });
}
