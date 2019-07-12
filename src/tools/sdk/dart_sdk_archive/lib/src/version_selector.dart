import 'dart:html';

import 'package:dart_sdk_archive/src/util.dart';
import 'package:platform_detect/platform_detect.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';

String _storageBase = "https://storage.googleapis.com/dart-archive";

class VersionSelector {
  final String channel;
  final DartDownloads _client;
  final TableElement _table;
  final SelectElement _versionSelector;
  final SelectElement _osSelector;
  bool _hasPopulatedTable = false;

  VersionSelector(this.channel, this._client, this._table,
      this._versionSelector, this._osSelector);

  Future init() async {
    _versionSelector.onChange.listen((Event event) {
      populateTable();
    });
    _osSelector.onChange.listen((Event event) {
      filterTable();
    });
    var versions = (await getSdkVersions(channel)
          ..sort())
        .reversed
        .toList();
    for (var version in versions) {
      addVersion(version);
    }

    _versionSelector.options.first.selected = true;
    _versionSelector.dispatchEvent(Event("change"));
  }

  void _selectOsDropdown() {
    if (operatingSystem.isMac) {
      _osSelector.options[1].selected = true;
    } else if (operatingSystem.isLinux || operatingSystem.isUnix) {
      _osSelector.options[2].selected = true;
    } else if (operatingSystem.isWindows) {
      _osSelector.options[3].selected = true;
    }
    _osSelector.dispatchEvent(Event("change"));
  }

  Future populateTable() async {
    clearTable();
    var selectedVersion =
        _versionSelector.selectedOptions.first.attributes['value'];
    var svnRevision = svnRevisionForVersion(selectedVersion);
    var versionInfo =
        await _client.getVersion(channel, svnRevision ?? selectedVersion);
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

  static int _svnRevision(VersionInfo versionInfo) {
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

  static String _prettyRevRef(VersionInfo versionInfo) {
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
      var platformVariants = platforms[name];
      for (var platformVariant in platformVariants) {
        // ARMv7 builds only available later in 2015, ARMv8 in 03-2017
        if (archiveMap[name] == 'linux') {
          if (platformVariant.architecture == 'ARMv7' &&
              versionInfo.date.isBefore(DateTime.parse(
                  (channel == "dev") ? '2015-10-21' : '2015-08-31'))) {
            continue;
          } else if (platformVariant.architecture == 'ARMv8 (ARM64)' &&
              versionInfo.date.isBefore(DateTime.parse('2017-03-09'))) {
            continue;
          }
        }

        var row = _table.tBodies.first.addRow()
          ..attributes['data-version'] = versionInfo.version.toString()
          ..attributes['data-os'] = archiveMap[name];
        var versionCell = row.addCell()..text = versionInfo.version.toString();
        versionCell.append(SpanElement()
          ..text = '(${_prettyRevRef(versionInfo)})'
          ..classes.add('muted'));
        row.addCell()..text = name;
        row.addCell()
          ..classes.add('nowrap')
          ..text = platformVariant.architecture;
        var possibleArchives = ['Dart SDK', 'Dartium'];
        var c = row.addCell()..classes.add('archives');

        for (var pa in possibleArchives) {
          if (platformVariant.archives.contains(pa)) {
            // We had no editor downloads after the move to GitHub.
            // This skips the editor link in those cases
            if (versionInfo.revisionPath == null && pa == 'Dart Editor') {
              continue;
            }

            if (pa == 'Dartium') {
              // Dropped all Dartium after 1.24.
              if (versionInfo.version > Version(1, 24, 0)) {
                continue;
              }

              // Dropped Dartium Mac 32-bit in 1.20.
              if (name == 'Mac') {
                var is120OrHigher = versionInfo.version > Version(1, 19, 0);
                // no 32-bit build with >= 1.20
                if (is120OrHigher && platformVariant.architecture == 'ia32') {
                  continue;
                }

                // no 64-bit build with < 1.20
                if (!is120OrHigher && platformVariant.architecture == 'x64') {
                  continue;
                }
              }
            }

            var uri =
                '$_storageBase/channels/$channel/release/${_versionString(versionInfo)}'
                '/${directoryMap[pa]}/${archiveMap[pa]}-${archiveMap[name]}-'
                '${archiveMap[platformVariant.architecture]}${suffixMap[pa]}';

            c.append(AnchorElement()
              ..text = pa
              ..attributes['href'] = uri);
            if (pa != 'Dart Editor' &&
                (_svnRevision(versionInfo) == null ||
                    _svnRevision(versionInfo) > 38976)) {
              c.appendText(' ');
              c.append(AnchorElement()
                ..text = "(SHA-256)"
                ..attributes['href'] = '$uri.sha256sum'
                ..classes.add('sha'));
            }
            c.append(Element.br());
          }
        }
      }
    }

    var row = _table.tBodies.first.addRow()
      ..attributes['data-version'] = versionInfo.version.toString()
      ..attributes['data-os'] = 'api';
    var rev = SpanElement()
      ..text = '  (${_prettyRevRef(versionInfo)})'
      ..classes.add('muted');
    row.addCell()
      ..text = versionInfo.version.toString()
      ..append(rev);
    row.addCell()..text = '---';
    row.addCell()..text = '---';
    var c = row.addCell()..classes.add('archives');
    var uri =
        '$_storageBase/channels/$channel/release/${versionInfo.version}/' +
            'api-docs/dartdocs-gen-api.zip';
    c.append(AnchorElement()
      ..text = 'API docs'
      ..attributes['href'] = uri);

    var templateRows = _table.querySelectorAll('.template');
    if (templateRows != null) {
      for (var row in templateRows) {
        row.remove();
      }
    }
  }
}
