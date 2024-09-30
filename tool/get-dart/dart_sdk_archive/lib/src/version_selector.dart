import 'dart:js_interop';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:web/web.dart';

import 'operating_system.dart';
import 'util.dart';

const _storageBase = '${storageBaseUrl}dart-archive';

class VersionSelector {
  final String channel;
  final DartDownloads _client;
  final HTMLTableElement _table;
  final HTMLSelectElement _versionSelector;
  final HTMLSelectElement _osSelector;
  bool _hasPopulatedTable = false;

  VersionSelector(
    this.channel,
    this._client,
    this._table,
    this._versionSelector,
    this._osSelector,
  );

  Future<void> init() async {
    _versionSelector.addEventListener(
        'change',
        (Event event) {
          populateTable();
        }.toJS);
    _osSelector.addEventListener(
        'change',
        (Event event) {
          filterTable();
        }.toJS);
    final versions = (await fetchSdkVersions(channel)
          ..sort())
        .reversed;
    for (final version in versions) {
      addVersion(version);
    }

    _versionSelector.options.selectedIndex = 0;
    _versionSelector.dispatchEvent(Event('change'));
  }

  void _selectOsDropdown() {
    if (OperatingSystem.current.isMac) {
      _osSelector.options.selectedIndex = 1;
    } else if (OperatingSystem.current.isLinux ||
        OperatingSystem.current.isUnix) {
      _osSelector.options.selectedIndex = 2;
    } else if (OperatingSystem.current.isWindows) {
      _osSelector.options.selectedIndex = 3;
    }
    _osSelector.dispatchEvent(Event('change'));
  }

  Future<void> populateTable() async {
    final selectedVersion =
        _versionSelector.selectedOptions.item(0)?.getAttribute('value');
    if (selectedVersion == null) return;
    final svnRevision = svnRevisionForVersion(selectedVersion);
    final versionInfo =
        await _client.fetchVersion(channel, svnRevision ?? selectedVersion);
    await findSystemLocale();
    await initializeDateFormatting(Intl.systemLocale);
    clearTable();
    updateTable(versionInfo);
    if (!_hasPopulatedTable) {
      _selectOsDropdown();
    }
    _hasPopulatedTable = true;
    filterTable();
  }

  void clearTable() {
    final rowsToRemove = _table.rows;

    // Remove all rows but the header row.
    for (var rowIndex = rowsToRemove.length - 1; rowIndex > 0; rowIndex -= 1) {
      rowsToRemove.item(rowIndex)!.remove();
    }
  }

  void filterTable() {
    final selectedVersion =
        _versionSelector.selectedOptions.item(0)!.getAttribute('value');
    final selectedOs =
        _osSelector.selectedOptions.item(0)!.getAttribute('value');

    final tableVersionRows = _table.querySelectorAll('tr[data-version]');
    if (selectedVersion == 'all' && selectedOs == 'all') {
      tableVersionRows.forEachElement((element) {
        element.classList.remove('hidden');
      });
    } else {
      tableVersionRows.forEachElement((element) {
        element.classList.add('hidden');
      });
      var selector = 'tr';
      if (selectedVersion != 'all') {
        selector += '[data-version="$selectedVersion"]';
      }

      final tableOsSelectors =
          _table.querySelectorAll('$selector[data-os="api"]');
      tableOsSelectors.forEachElement((element) {
        element.classList.remove('hidden');
      });

      if (selectedOs != 'all') {
        selector += '[data-os="$selectedOs"]';
      }
      final tableSelectors = _table.querySelectorAll(selector);
      tableSelectors.forEachElement((element) {
        element.classList.remove('hidden');
      });
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
    final option = (document.createElement('option') as HTMLOptionElement)
      ..text = version.toString()
      ..setAttribute('value', version.toString());
    _versionSelector.appendChild(option);
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
            // Stable builds start at 3.2.3, but only show starting at 3.3
            if (versionInfo.channel == 'stable' &&
                versionInfo.version < Version(3, 3, 0)) {
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
            // Stable builds start at 3.2.3, but only show starting at 3.3
            if (versionInfo.channel == 'stable' &&
                versionInfo.version < Version(3, 3, 0)) {
              continue;
            }
          }
        }

        // Build rows for all supported builds.
        final row =
            (_table.tBodies.item(0) as HTMLTableSectionElement).insertRow()
              ..setAttribute('data-version', versionInfo.version.toString())
              ..setAttribute('data-os', archiveMap[name] ?? '');
        final versionCell = row.insertCell()
          ..textContent = versionInfo.version.toString();
        versionCell
            .appendChild((document.createElement('span') as HTMLSpanElement)
              ..textContent = ' (${_prettyRevRef(versionInfo)})'
              ..classList.add('muted'));
        row.insertCell().textContent = name;
        row.insertCell()
          ..classList.add('nowrap')
          ..textContent = platformVariant.architecture;
        _addReleaseDateCell(versionInfo, row);
        const possibleArchives = ['Dart SDK', 'Debian package'];
        final c = row.insertCell()..classList.add('archives');

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

            c.appendChild((document.createElement('a') as HTMLAnchorElement)
              ..text = pa
              ..setAttribute('href', uri));
            final svnRevisionInfo = _svnRevision(versionInfo);
            if (pa != 'Dart Editor' &&
                pa != 'Debian package' &&
                (svnRevisionInfo == null || svnRevisionInfo > 38976)) {
              c.append(' '.toJS);
              c.appendChild((document.createElement('a') as HTMLAnchorElement)
                ..textContent = '(SHA-256)'
                ..setAttribute('href', '$uri.sha256sum')
                ..classList.add('sha'));
            }
            c.appendChild(document.createElement('br'));
          }
        }
      }
    }

    // Add DartDoc archive.
    final row = (_table.tBodies.item(0) as HTMLTableSectionElement).insertRow()
      ..setAttribute('data-version', versionInfo.version.toString())
      ..setAttribute('data-os', 'api');
    final rev = (document.createElement('span') as HTMLSpanElement)
      ..textContent = ' (${_prettyRevRef(versionInfo)})'
      ..classList.add('muted');
    row.insertCell()
      ..textContent = versionInfo.version.toString()
      ..appendChild(rev);
    row.insertCell().textContent = '---';
    row.insertCell().textContent = '---';

    _addReleaseDateCell(versionInfo, row);

    final c = row.insertCell()..classList.add('archives');
    final uri = '$_storageBase/channels/$channel/release/'
        '${versionInfo.version}/api-docs/dartdocs-gen-api.zip';
    c.appendChild((document.createElement('a') as HTMLAnchorElement)
      ..textContent = 'API docs'
      ..setAttribute('href', uri));

    final templateRows = _table.querySelectorAll('.template');
    templateRows.forEachElement((element) {
      element.remove();
    });
  }

  void _addReleaseDateCell(VersionInfo versionInfo, HTMLTableRowElement row) {
    final creationDate = versionInfo.creationTime;
    final dateRow = row.insertCell();
    if (creationDate == null) {
      dateRow.textContent = '---';
    } else {
      dateRow.textContent =
          DateFormat.yMMMd(Intl.systemLocale).format(creationDate);
    }
  }
}

extension on NodeList {
  void forEachElement(void Function(HTMLElement element) action) {
    for (var index = 0; index < length; index += 1) {
      action(item(index) as HTMLElement);
    }
  }
}
