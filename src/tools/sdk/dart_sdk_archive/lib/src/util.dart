import 'package:dart_sdk_archive/src/svn_versions.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:path/path.dart' as path;

final _downloader = DartDownloads();

Future<List<Version>> fetchSdkVersions(String channel) async {
  var versionPaths = await _downloader.fetchVersionPaths(channel).toList();
  var versions = <Version>[];
  for (var versionPath in versionPaths) {
    var basename = path.basename(versionPath);
    if (basename == 'latest') {
      continue;
    }
    if (isSvnRevision(basename)) {
      versions.add(Version.parse(svnVersions[basename]));
    } else {
      versions.add(Version.parse(basename));
    }
  }
  return versions;
}

bool isSvnRevision(String s) => int.tryParse(s) != null;

String svnRevisionForVersion(String svnVersion) {
  for (var key in svnVersions.keys) {
    if (svnVersions[key] == svnVersion) {
      return key;
    }
  }
  return null;
}

Map<String, String> archiveMap = {
  'Mac': 'macos',
  'Linux': 'linux',
  'Windows': 'windows',
  'ia32': 'ia32',
  'x64': 'x64',
  'ARMv7': 'arm',
  'ARMv8 (ARM64)': 'arm64',
  'Dart SDK': 'dartsdk',
  'Dartium': 'dartium'
};

Map<String, String> directoryMap = {'Dart SDK': 'sdk', 'Dartium': 'dartium'};

Map<String, String> suffixMap = {
  'Dart SDK': '-release.zip',
  'Dartium': '-release.zip'
};

Map<String, List<PlatformVariant>> platforms = {
  'Mac': [
    PlatformVariant('ia32', ['Dart SDK', 'Dartium']),
    PlatformVariant('x64', ['Dart SDK', 'Dartium']),
  ],
  'Linux': [
    PlatformVariant('ia32', ['Dart SDK', 'Dartium']),
    PlatformVariant('x64', ['Dart SDK', 'Dartium']),
    PlatformVariant('ARMv7', ['Dart SDK']),
    PlatformVariant('ARMv8 (ARM64)', ['Dart SDK']),
  ],
  'Windows': [
    PlatformVariant('ia32', ['Dart SDK', 'Dartium']),
    PlatformVariant('x64', ['Dart SDK']),
  ],
};

class PlatformVariant {
  const PlatformVariant(this.architecture, this.archives);

  final String architecture;
  final List<String> archives;
}
