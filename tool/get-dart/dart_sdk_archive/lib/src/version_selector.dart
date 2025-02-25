import 'dart:async';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:jaspr/jaspr.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';

import 'components/archive_table.dart';
import 'operating_system.dart';
import 'util.dart';

const _storageBase = '${storageBaseUrl}dart-archive';

class VersionSelector with ChangeNotifier {
  VersionSelector({required this.channel, required this.client}) {
    if (OperatingSystem.current.isMac) {
      _selectedOs = 'macos';
    } else if (OperatingSystem.current.isLinux ||
        OperatingSystem.current.isUnix) {
      _selectedOs = 'linux';
    } else if (OperatingSystem.current.isWindows) {
      _selectedOs = 'windows';
    }

    unawaited(loadVersions());
  }

  final String channel;
  final DartDownloads client;

  String? _selectedVersion;

  String? get selectedVersion => _selectedVersion;
  set selectedVersion(String? value) {
    _selectedVersion = value;
    notifyListeners();
    unawaited(loadVersionInfo());
  }

  String? _selectedOs;
  String? get selectedOs => _selectedOs;
  set selectedOs(String? value) {
    _selectedOs = value;
    notifyListeners();
  }

  VersionInfo? _versionInfo;
  VersionInfo? get versionInfo => _versionInfo;

  Iterable<Version>? _versions;
  Iterable<Version>? get versions => _versions;

  Iterable<VersionRow> get versionRows {
    if (_versionInfo case final versionInfo?) {
      return buildVersionRows(versionInfo);
    } else {
      return [ArchivesTable.templateRow(channel)];
    }
  }

  bool isVersionVisible(VersionRow version) {
    if (selectedOs case null || 'all') {
      return true;
    } else {
      return version.os.toLowerCase() == selectedOs || version.os == '---';
    }
  }

  Future<void> loadVersions() async {
    final versions =
        (await fetchSdkVersions(channel, client)
          ..sort()).reversed;

    _selectedVersion = versions.first.canonicalizedVersion;
    _versions = versions;
    notifyListeners();

    if (!debugIsTest) {
      await findSystemLocale();
    }
    await initializeDateFormatting(Intl.systemLocale);

    await loadVersionInfo();
  }

  static int? _svnRevision(VersionInfo versionInfo) {
    if (versionInfo is SvnVersionInfo) {
      return versionInfo.revision;
    }
    return null;
  }

  static String _versionString(VersionInfo versionInfo) {
    // Use the revision number for anything <= 1.11.0-dev.0.0 (rev 45519)
    // and the version string for later ones.
    if (_svnRevision(versionInfo) != null) {
      return _svnRevision(versionInfo).toString();
    }
    return versionInfo.version.toString();
  }

  static String? _prettyRevRef(VersionInfo versionInfo) {
    if (versionInfo is SvnVersionInfo) {
      return 'r${versionInfo.revision}';
    } else if (versionInfo is GitVersionInfo) {
      return 'ref ${versionInfo.ref.toString().substring(0, 7)}';
    }
    return null;
  }

  String _releaseDate(DateTime? creationDate) {
    if (creationDate == null) {
      return '---';
    } else {
      return DateFormat.yMMMd(Intl.systemLocale).format(creationDate);
    }
  }

  Future<void> loadVersionInfo() async {
    final version = _selectedVersion;
    if (version == null) return;

    final svnRevision = svnRevisionForVersion(version);
    final versionInfo = await client.fetchVersion(
      channel,
      svnRevision ?? version,
    );

    _versionInfo = versionInfo;
    notifyListeners();
  }

  Iterable<VersionRow> buildVersionRows(VersionInfo versionInfo) sync* {
    for (final name in platforms.keys) {
      final platformVariants = platforms[name] ?? const [];
      for (final platformVariant in platformVariants) {
        // ARMv7 builds only available later in 2015, ARMv8 in 03-2017.
        if (archiveMap[name] == 'linux') {
          if (platformVariant.architecture == 'IA32') {
            if (versionInfo.version >= Version(3, 8, 0, pre: '0')) {
              // No Linux IA32 SDK builds after 3.7.
              continue;
            }
          } else if (platformVariant.architecture == 'ARMv7' &&
              versionInfo.date.isBefore(
                DateTime.parse(
                  (channel == 'dev') ? '2015-10-21' : '2015-08-31',
                ),
              )) {
            continue;
          } else if (platformVariant.architecture == 'ARMv8 (ARM64)' &&
              versionInfo.date.isBefore(DateTime.parse('2017-03-09'))) {
            continue;
          } else if (platformVariant.architecture == 'RISC-V (RV64GC)') {
            // Dev builds start at 2.17.0-258.0.dev.
            if (versionInfo.channel == 'dev' &&
                versionInfo.version < Version(2, 17, 0, pre: '258.0.dev')) {
              continue;
            }
            // Beta builds start at 3.0.0-290.2.beta.
            if (versionInfo.channel == 'beta' &&
                versionInfo.version < Version(3, 0, 0, pre: '290.2.beta')) {
              continue;
            }
            // Stable builds start at 3.2.3, but only show starting at 3.3.
            if (versionInfo.channel == 'stable' &&
                versionInfo.version < Version(3, 3, 0)) {
              continue;
            }
          }
        } else if (name == 'macOS') {
          if (platformVariant.architecture == 'IA32') {
            if (versionInfo.version > Version(2, 7, 0)) {
              // No macOS 32-bit SDK builds after 2.8.0.
              continue;
            }
          } else if (platformVariant.architecture == 'ARM64' &&
              versionInfo.version < Version(2, 14, 1)) {
            // No macOS ARM64 SDK builds before 2.14.1
            // (earlier builds did not have trained snapshots).
            continue;
          }
        } else if (name == 'Windows') {
          if (platformVariant.architecture == 'IA32') {
            if (versionInfo.version >= Version(3, 8, 0, pre: '0')) {
              // No Windows IA32 SDK builds after 3.7.
              continue;
            }
          } else if (platformVariant.architecture == 'ARM64') {
            // Dev builds start at 2.18.0-41.0.dev.
            if (versionInfo.channel == 'dev' &&
                versionInfo.version < Version(2, 18, 0, pre: '41.0.dev')) {
              continue;
            }
            // Beta builds start at 3.2.0-42.2.beta.
            if (versionInfo.channel == 'beta' &&
                versionInfo.version < Version(3, 2, 0, pre: '42.2.beta')) {
              continue;
            }
            // Stable builds start at 3.2.3, but only show starting at 3.3.
            if (versionInfo.channel == 'stable' &&
                versionInfo.version < Version(3, 3, 0)) {
              continue;
            }
          }
        }

        const possibleArchives = ['Dart SDK', 'Debian package'];

        final archives = <({String label, String url, bool hasSha256})>[];

        for (final pa in possibleArchives) {
          if (platformVariant.archives.contains(pa)) {
            // We had no editor downloads after the move to GitHub.
            // This skips the editor link in those cases.
            if (pa == 'Dart Editor') {
              continue;
            }

            var baseFileName =
                '${archiveMap[pa]}-${archiveMap[name]}-'
                '${archiveMap[platformVariant.architecture]}';

            if (pa == 'Debian package') {
              // Debian packages start with 2.0.0
              if (versionInfo.version < Version(2, 0, 0)) {
                continue;
              } else {
                baseFileName = 'dart_${_versionString(versionInfo)}';
              }
            }

            final uri =
                '$_storageBase/channels/$channel/release/${_versionString(versionInfo)}'
                '/${directoryMap[pa]}/$baseFileName${suffixMap[pa]}';
            final svnRevisionInfo = _svnRevision(versionInfo);
            final hasSha256 =
                pa != 'Dart Editor' &&
                pa != 'Debian package' &&
                (svnRevisionInfo == null || svnRevisionInfo > 38976);
            archives.add((label: pa, url: uri, hasSha256: hasSha256));
          }
        }

        // Build rows for all supported builds.
        yield (
          version: versionInfo.version.toString(),
          ref: _prettyRevRef(versionInfo),
          os: name,
          arch: platformVariant.architecture,
          date: _releaseDate(versionInfo.creationTime),
          archives: archives,
        );
      }
    }

    // Add entry for dart doc archive.
    yield (
      version: versionInfo.version.toString(),
      ref: _prettyRevRef(versionInfo),
      os: '---',
      arch: '---',
      date: _releaseDate(versionInfo.creationTime),
      archives: [
        (
          label: 'API Docs',
          url:
              '$_storageBase/channels/$channel/release/'
              '${versionInfo.version}/api-docs/dartdocs-gen-api.zip',
          hasSha256: false,
        ),
      ],
    );
  }
}
