import 'package:dart_sdk_archive/src/svn_versions.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';

final _downloader = DartDownloads();

Future<List<Version>> fetchSdkVersions(String channel) async {
  final versionPaths = await _downloader.fetchVersionPaths(channel).toList();
  final versions = <Version>[];
  for (final versionPath in versionPaths) {
    final basename = path.basename(versionPath);
    if (basename == 'latest') {
      continue;
    }
    if (isSvnRevision(basename)) {
      versions.add(Version.parse(svnVersions[basename] ?? basename));
    } else {
      versions.add(Version.parse(basename));
    }
  }
  return versions;
}

bool isSvnRevision(String s) => int.tryParse(s) != null;

String? svnRevisionForVersion(String svnVersion) {
  for (final key in svnVersions.keys) {
    if (svnVersions[key] == svnVersion) {
      return key;
    }
  }
  return null;
}

const Map<String, String> archiveMap = {
  'macOS': 'macos',
  'Linux': 'linux',
  'Windows': 'windows',
  'IA32': 'ia32',
  'x64': 'x64',
  'ARM64': 'arm64',
  'ARMv7': 'arm',
  'ARMv8 (ARM64)': 'arm64',
  'RISC-V (RV64GC)': 'riscv64',
  'Dart SDK': 'dartsdk',
};

const Map<String, String> directoryMap = {
  'Dart SDK': 'sdk',
  'Debian package': 'linux_packages',
};

const Map<String, String> suffixMap = {
  'Dart SDK': '-release.zip',
  'Debian package': '-1_amd64.deb',
};

const Map<String, List<PlatformVariant>> platforms = {
  'macOS': [
    PlatformVariant('x64', ['Dart SDK']),
    PlatformVariant('ARM64', ['Dart SDK']),
    PlatformVariant('IA32', ['Dart SDK']),
  ],
  'Linux': [
    PlatformVariant('x64', ['Dart SDK', 'Debian package']),
    PlatformVariant('IA32', ['Dart SDK']),
    PlatformVariant('ARMv8 (ARM64)', ['Dart SDK']),
    PlatformVariant('ARMv7', ['Dart SDK']),
    PlatformVariant('RISC-V (RV64GC)', ['Dart SDK']),
  ],
  'Windows': [
    PlatformVariant('x64', ['Dart SDK']),
    PlatformVariant('IA32', ['Dart SDK']),
    PlatformVariant('ARM64', ['Dart SDK']),
  ],
};

class PlatformVariant {
  final String architecture;
  final List<String> archives;

  const PlatformVariant(this.architecture, this.archives);
}
