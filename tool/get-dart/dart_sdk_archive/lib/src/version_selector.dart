import 'dart:html';

import 'package:dart_sdk_archive/src/util.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';

import 'operating_system.dart';

const _storageBase = '${storageBaseUrl}dart-archive';

class VersionSelector {
  final String channel;
  final DartDownloads _client;
  final TableElement _table;
  final SelectElement _versionSelector;
  final SelectElement _osSelector;
  bool _hasPopulatedTable = false;

  VersionSelector(this.channel, this._client, this._table,
      this._versionSelector, this._osSelector);

  Future<void> init() async {
    _versionSelector.onChange.listen((Event event) {
      populateTable();
    });
    _osSelector.onChange.listen((Event event) {
      filterTable();
    });
    final versions = (await fetchSdkVersions(channel)
          ..sort())
        .reversed
        .toList(growable: false);
    for (final version in versions) {
      addVersion(version);
    }

    _versionSelector.options.first.selected = true;
    _versionSelector.dispatchEvent(Event('change'));
  }

  void _selectOsDropdown() {
    if (OperatingSystem.current.isMac) {
      _osSelector.options[1].selected = true;
    } else if (OperatingSystem.current.isLinux ||
        OperatingSystem.current.isUnix) {
      _osSelector.options[2].selected = true;
    } else if (OperatingSystem.current.isWindows) {
      _osSelector.options[3].selected = true;
    }
    _osSelector.dispatchEvent(Event('change'));
  }

  Future<void> populateTable() async {
    final selectedVersion =
        _versionSelector.selectedOptions.first.attributes['value'];
    if (selectedVersion == null) return;
    clearTable();
    final svnRevision = svnRevisionForVersion(selectedVersion);
    final versionInfo =
        await _client.fetchVersion(channel, svnRevision ?? selectedVersion);
    await findSystemLocale();
    await initializeDateFormatting(Intl.systemLocale);
    updateTable(versionInfo);
    if (!_hasPopulatedTable) {
      _selectOsDropdown();
    }
    _hasPopulatedTable = true;
    filterTable();
  }

  void clearTable() {
    final rowsToRemove = List<TableRowElement>.from(_table.rows);
    // keep the header row
    rowsToRemove.removeAt(0);
    for (final row in rowsToRemove) {
      row.remove();
    }
  }

  void filterTable() {
    final selectedVersion =
        _versionSelector.selectedOptions[0].attributes['value'];
    final selectedOs = _osSelector.selectedOptions[0].attributes['value'];
    if (selectedVersion == 'all' && selectedOs == 'all') {
      _table.querySelectorAll('tr[data-version]').classes.remove('hidden');
    } else {
      _table.querySelectorAll('tr[data-version]').classes.add('hidden');
      var selector = 'tr';
      if (selectedVersion != 'all') {
        selector += '[data-version="$selectedVersion"]';
      }
      _table
          .querySelectorAll('$selector[data-os="api"]')
          .classes
          .remove('hidden');
      if (selectedOs != 'all') {
        selector += '[data-os="$selectedOs"]';
      }
      _table.querySelectorAll(selector).classes.remove('hidden');
    }
  }

  static int? _svnRevision(VersionInfo versionInfo) {
    if (versionInfo is SvnVersionInfo) {
      return versionInfo.revision;
    }
    return null;
  }

  static String _versionString(VersionInfo versionInfo) {
    /// Use the revision number for anything <= 1.11.0-dev.0.0 (rev 45519)
    /// and the version string for later ones.
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

  void addVersion(Version version) {
    final option = OptionElement()
      ..text = version.toString()
      ..attributes['value'] = version.toString();
    _versionSelector.children.add(option);
  }

  void updateTable(VersionInfo versionInfo) {
    for (final name in platforms.keys) {
      final platformVariants = platforms[name] ?? const [];
      for (final platformVariant in platformVariants) {
        // ARMv7 builds only available later in 2015, ARMv8 in 03-2017
        if (archiveMap[name] == 'linux') {
          if (platformVariant.architecture == 'ARMv7' &&
              versionInfo.date.isBefore(DateTime.parse(
                  (channel == 'dev') ? '2015-10-21' : '2015-08-31'))) {
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
            // No stable builds yet.
            if (versionInfo.channel == 'stable') {
              continue;
            }
          }
        } else if (name == 'macOS') {
          if (platformVariant.architecture == 'IA32') {
            if (versionInfo.version > Version(2, 7, 0)) {
              // No macOS 32-bit SDK builds after 2.8.0
              continue;
            }
          } else if (platformVariant.architecture == 'ARM64' &&
              versionInfo.version < Version(2, 14, 1)) {
            // No macOS ARM64 SDK builds before 2.14.1
            // (earlier builds did not have trained snapshots).
            continue;
          }
        } else if (name == 'Windows') {
          if (platformVariant.architecture == 'ARM64') {
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
            // No stable builds yet.
            if (versionInfo.channel == 'stable') {
              continue;
            }
          }
        }

        // Build rows for all supported builds.
        final row = _table.tBodies.first.addRow()
          ..attributes['data-version'] = versionInfo.version.toString()
          ..attributes['data-os'] = archiveMap[name] ?? '';
        final versionCell = row.addCell()
          ..text = versionInfo.version.toString();
        versionCell.append(SpanElement()
          ..text = ' (${_prettyRevRef(versionInfo)})'
          ..classes.add('muted'));
        row.addCell().text = name;
        row.addCell()
          ..classes.add('nowrap')
          ..text = platformVariant.architecture;
        _addReleaseDateCell(versionInfo, row);
        const possibleArchives = ['Dart SDK', 'Debian package'];
        final c = row.addCell()..classes.add('archives');

        for (final pa in possibleArchives) {
          if (platformVariant.archives.contains(pa)) {
            // We had no editor downloads after the move to GitHub.
            // This skips the editor link in those cases
            if (pa == 'Dart Editor') {
              continue;
            }

            var baseFileName = '${archiveMap[pa]}-${archiveMap[name]}-'
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

            c.append(AnchorElement()
              ..text = pa
              ..attributes['href'] = uri);
            final svnRevisionInfo = _svnRevision(versionInfo);
            if (pa != 'Dart Editor' &&
                pa != 'Debian package' &&
                (svnRevisionInfo == null || svnRevisionInfo > 38976)) {
              c.appendText(' ');
              c.append(AnchorElement()
                ..text = '(SHA-256)'
                ..attributes['href'] = '$uri.sha256sum'
                ..classes.add('sha'));
            }
            c.append(Element.br());
          }
        }
      }
    }

    // Add DartDoc archive.
    final row = _table.tBodies.first.addRow()
      ..attributes['data-version'] = versionInfo.version.toString()
      ..attributes['data-os'] = 'api';
    final rev = SpanElement()
      ..text = ' (${_prettyRevRef(versionInfo)})'
      ..classes.add('muted');
    row.addCell()
      ..text = versionInfo.version.toString()
      ..append(rev);
    row.addCell().text = '---';
    row.addCell().text = '---';

    _addReleaseDateCell(versionInfo, row);

    final c = row.addCell()..classes.add('archives');
    final uri = '$_storageBase/channels/$channel/release/'
        '${versionInfo.version}/api-docs/dartdocs-gen-api.zip';
    c.append(AnchorElement()
      ..text = 'API docs'
      ..attributes['href'] = uri);

    final templateRows = _table.querySelectorAll('.template');
    for (final row in templateRows) {
      row.remove();
    }
  }

  void _addReleaseDateCell(VersionInfo versionInfo, TableRowElement row) {
    final creationDate = versionInfo.creationTime;
    final dateRow = row.addCell();
    if (creationDate == null) {
      dateRow.text = '---';
    } else {
      dateRow.text = DateFormat.yMMMd(Intl.systemLocale).format(creationDate);
    }
  }
}
