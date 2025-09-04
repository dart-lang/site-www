// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:http/browser_client.dart' show BrowserClient;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:pub_semver/pub_semver.dart';

import 'archive_table.dart';
import 'dart_downloads.dart';
import 'operating_system.dart';
import 'util.dart';
import 'version_info.dart';
import 'version_selector.dart' as server_version;

const _storageBase = '${storageBaseUrl}dart-archive';

final class VersionSelector extends server_version.VersionSelector {
  static final DartDownloads _client = DartDownloads(client: BrowserClient());

  VersionSelector(super.channel) {
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

  String? _selectedVersion;

  @override
  String? get selectedVersion => _selectedVersion;
  @override
  set selectedVersion(String? value) {
    _selectedVersion = value;
    notifyListeners();
    unawaited(_loadVersionInfo());
  }

  String? _selectedOs;
  @override
  String? get selectedOs => _selectedOs;
  @override
  set selectedOs(String? value) {
    _selectedOs = value;
    notifyListeners();
  }

  VersionInfo? _versionInfo;
  @override
  VersionInfo? get versionInfo => _versionInfo;

  Iterable<Version>? _versions;
  @override
  Iterable<Version>? get versions => _versions;

  @override
  Iterable<VersionRow> get versionRows {
    if (_versionInfo case final versionInfo?) {
      return _buildVersionRows(versionInfo);
    } else {
      return [ArchiveTable.templateRow(channel)];
    }
  }

  Future<void> loadVersions() async {
    final versions =
        (await fetchSdkVersions(channel, _client)
              ..sort())
            .reversed;

    _selectedVersion = versions.first.canonicalizedVersion;
    _versions = versions;
    notifyListeners();

    if (!debugIsTest) {
      await findSystemLocale();
    }
    await initializeDateFormatting(Intl.systemLocale);

    await _loadVersionInfo();
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
      return 'ref ${versionInfo.ref.substring(0, 7)}';
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

  Future<void> _loadVersionInfo() async {
    final version = _selectedVersion;
    if (version == null) return;

    final svnRevision = svnRevisionForVersion(version);
    final versionInfo = await _client.fetchVersion(
      channel,
      svnRevision ?? version,
    );

    _versionInfo = versionInfo;
    notifyListeners();
  }

  Iterable<VersionRow> _buildVersionRows(VersionInfo versionInfo) sync* {
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
              final debianArch = debianArchMap[platformVariant.architecture];
              // x64 Debian packages start with 2.0.0.
              if (debianArch == 'amd64' &&
                  versionInfo.version < Version(2, 0, 0)) {
                continue;
              }

              // arm, arm64, riscv64 Debian packages start with 3.9.0.
              if ((debianArch == 'armhf' ||
                      debianArch == 'arm64' ||
                      debianArch == 'riscv64') &&
                  versionInfo.version < Version(3, 9, 0)) {
                continue;
              }

              baseFileName =
                  'dart_${_versionString(versionInfo)}-1_$debianArch';
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
