import 'package:dart_sdk_archive/src/util.dart';
import 'package:path/path.dart' as path;
import 'package:sdk_builds/sdk_builds.dart';

class SvnVersionGenerator {
  final _downloader = DartDownloads();

  Future<Map<String, String>> get svnVersions async {
    final versionInfos = <String, VersionInfo>{};
    await Future.wait([
      _loadVersionInfo(versionInfos, 'stable'),
      _loadVersionInfo(versionInfos, 'beta'),
      _loadVersionInfo(versionInfos, 'dev'),
    ]);
    final result = <String, String>{};
    versionInfos.forEach((revision, version) {
      result[revision] = version.toString();
    });
    return result;
  }

  Future<void> _loadVersionInfo(
      Map<String, VersionInfo> versionInfos, String channel) async {
    final versionBaseNames = await _downloader
        .fetchVersionPaths(channel)
        .map(path.basename)
        .toList();

    await Future.forEach<String>(versionBaseNames, (name) async {
      if (!isSvnRevision(name)) {
        return;
      }

      final versionInfo = await _downloader.fetchVersion(channel, name);
      versionInfos[name] = versionInfo;
    });
  }
}
