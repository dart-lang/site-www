import 'dart:html';

import 'package:dart_sdk_archive/src/util.dart';
import 'package:platform_detect/platform_detect.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';

const _storageBase = 'https://storage.googleapis.com/dart-archive';

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
    var versions = (await fetchSdkVersions(channel)
          ..sort())
        .reversed
        .toList();
    for (var version in versions) {
      addVersion(version);
    }

    _versionSelector.options.first.selected = true;
    _versionSelector.dispatchEvent(Event('change'));
  }

  void _selectOsDropdown() {
    if (operatingSystem.isMac) {
      _osSelector.options[1].selected = true;
    } else if (operatingSystem.isLinux || operatingSystem.isUnix) {
      _osSelector.options[2].selected = true;
    } else if (operatingSystem.isWindows) {
      _osSelector.options[3].selected = true;
    }
    _osSelector.dispatchEvent(Event('change'));
  }

  Future<void> populateTable() async {
    var selectedVersion =
        _versionSelector.selectedOptions.first.attributes['value'];
    if (selectedVersion == null) return;
    clearTable();
    var svnRevision = svnRevisionForVersion(selectedVersion);
    var versionInfo =
        await _client.fetchVersion(channel, svnRevision ?? selectedVersion);
    updateTable(versionInfo);
    if (!_hasPopulatedTable) {
      _selectOsDropdown();
    }
    _hasPopulatedTable = true;
    filterTable();
  }

  void clearTable() {
    var rowsToRemove = List<TableRowElement>.from(_table.rows);
    // keep the header row
    rowsToRemove.removeAt(0);
    for (var row in rowsToRemove) {
      row.remove();
    }
  }

  void filterTable() {
    var selectedVersion =
        _versionSelector.selectedOptions[0].attributes['value'];
    var selectedOs = _osSelector.selectedOptions[0].attributes['value'];
    if (selectedVersion == 'all' && selectedOs == 'all') {
      _table.querySelectorAll('tr[data-version]').classes.remove('hidden');
    } else {
      _table.querySelectorAll('tr[data-version]').classes.add('hidden');
      var selector = 'tr';
      if (selectedVersion != 'all') {
        selector += '[data-version="$selectedVersion"]';
      }
      _table
          .querySelectorAll(selector + '[data-os="api"]')
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
    var option = OptionElement()
      ..text = version.toString()
      ..attributes['value'] = version.toString();
    _versionSelector.children.add(option);
  }

  void updateTable(VersionInfo versionInfo) {
    for (var name in platforms.keys) {
      var platformVariants = platforms[name] ?? const [];
      for (var platformVariant in platformVariants) {
        // ARMv7 builds only available later in 2015, ARMv8 in 03-2017
        if (archiveMap[name] == 'linux') {
          if (platformVariant.architecture == 'ARMv7' &&
              versionInfo.date.isBefore(DateTime.parse(
                  (channel == 'dev') ? '2015-10-21' : '2015-08-31'))) {
            continue;
          } else if (platformVariant.architecture == 'ARMv8 (ARM64)' &&
              versionInfo.date.isBefore(DateTime.parse('2017-03-09'))) {
            continue;
          }
        }

        // No Mac 32-bit SDK builds after 2.80
        if (name == 'macOS' && platformVariant.architecture == 'ia32') {
          if (versionInfo.version > Version(2, 7, 0)) {
            continue;
          }
        }

        // No Mac arm64 SDK builds before 2.14.0-281.0.dev, and not in stable yet.
        // TODO: After this ships in stable 2.x, remove the stable check,
        // and just test for versionInfo.version < Version(2,x,0).
        if (name == 'macOS' && platformVariant.architecture == 'ARM64') {
          if (versionInfo.version < Version(2, 14, 0, pre: '281.0.dev')) {
            continue;
          }

          if (versionInfo.channel == 'stable') {
            continue;
          }
        }

        // Build rows for all supported builds.
        var row = _table.tBodies.first.addRow()
          ..attributes['data-version'] = versionInfo.version.toString()
          ..attributes['data-os'] = archiveMap[name] ?? '';
        var versionCell = row.addCell()..text = versionInfo.version.toString();
        versionCell.append(SpanElement()
          ..text = ' (${_prettyRevRef(versionInfo)})'
          ..classes.add('muted'));
        row.addCell().text = name;
        row.addCell()
          ..classes.add('nowrap')
          ..text = platformVariant.architecture;
        var possibleArchives = ['Dart SDK', 'Debian package'];
        var c = row.addCell()..classes.add('archives');

        for (var pa in possibleArchives) {
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
    var row = _table.tBodies.first.addRow()
      ..attributes['data-version'] = versionInfo.version.toString()
      ..attributes['data-os'] = 'api';
    var rev = SpanElement()
      ..text = ' (${_prettyRevRef(versionInfo)})'
      ..classes.add('muted');
    row.addCell()
      ..text = versionInfo.version.toString()
      ..append(rev);
    row.addCell().text = '---';
    row.addCell().text = '---';
    var c = row.addCell()..classes.add('archives');
    var uri = '$_storageBase/channels/$channel/release/'
        '${versionInfo.version}/api-docs/dartdocs-gen-api.zip';
    c.append(AnchorElement()
      ..text = 'API docs'
      ..attributes['href'] = uri);

    var templateRows = _table.querySelectorAll('.template');
    for (var row in templateRows) {
      row.remove();
    }
  }
}
