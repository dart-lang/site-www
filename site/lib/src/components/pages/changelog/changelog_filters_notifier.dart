// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:universal_web/web.dart' as web;

import '../../../models/changelog_model.dart';

/// Manages the state of the changelog filters.
class ChangelogFiltersNotifier extends ChangeNotifier {
  static final _versionXyRegex = RegExp(r'^\d+\.\d+$');

  Set<ChangelogTag> selectedTags = {};
  Set<String> selectedAreas = {};
  Set<Version> selectedVersions = {};

  Set<String> availableAreas = {};
  Set<Version> availableVersions = {};

  /// Populates [availableAreas] and [availableVersions] by inspecting the DOM.
  ///
  /// This expects the changelog list to be rendered in the DOM with
  /// `data-area` and `data-version` attributes on entries.
  void populateAvailableFiltersFromDOM() {
    final listContainer = web.document.getElementById('all-changelog-list');
    if (listContainer == null) return;

    // Always include 'Docs' as an available area, even if no entries are
    // currently displayed for it (though usually there are).
    // This ensures the filter option is present.
    var changed = availableAreas.add('Docs');
    final entryCards = listContainer.querySelectorAll('.changelog-card');
    for (var i = 0; i < entryCards.length; i++) {
      final element = entryCards.item(i) as web.Element;
      final area = element.getAttribute('data-area');
      if (area != null && area.isNotEmpty) {
        changed |= availableAreas.add(area);
      }
      final version = element.getAttribute('data-version');
      if (version != null && version.isNotEmpty) {
        try {
          // Normalize "X.Y" to "X.Y.0" if needed for parsing
          var vStr = version;
          if (_versionXyRegex.hasMatch(vStr)) {
            vStr = '$vStr.0';
          }
          final v = Version.parse(vStr);
          // Store the short version (major.minor.0)
          final shortVersion = Version(v.major, v.minor, 0);
          changed |= availableVersions.add(shortVersion);
        } catch (_) {
          // Ignore invalid versions
        }
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void setTag(ChangelogTag tag, bool isSelected) {
    if (isSelected) {
      selectedTags.add(tag);
    } else {
      selectedTags.remove(tag);
    }
    notifyListeners();
  }

  void setArea(String area, bool isSelected) {
    if (isSelected) {
      selectedAreas.add(area);
    } else {
      selectedAreas.remove(area);
    }
    notifyListeners();
  }

  void setVersion(Version version, bool isSelected) {
    if (isSelected) {
      selectedVersions.add(version);
    } else {
      selectedVersions.remove(version);
    }
    notifyListeners();
  }

  void toggleMajor(int major, bool isSelected) {
    final versionsInMajor = availableVersions.where((v) => v.major == major);
    if (isSelected) {
      selectedVersions.addAll(versionsInMajor);
    } else {
      selectedVersions.removeAll(versionsInMajor);
    }
    notifyListeners();
  }

  bool isMajorSelected(int major) {
    final versionsInMajor = availableVersions.where((v) => v.major == major);
    return versionsInMajor.isNotEmpty &&
        versionsInMajor.every(selectedVersions.contains);
  }

  void reset() {
    selectedTags.clear();
    selectedAreas.clear();
    selectedVersions.clear();
    notifyListeners();
  }

  void disposeState({bool notify = true}) {
    selectedTags.clear();
    selectedAreas.clear();
    selectedVersions.clear();
    availableAreas.clear();
    availableVersions.clear();
    if (notify) {
      notifyListeners();
    }
  }

  /// Compares two versions used for sorting descending.
  int compareVersions(Version v1, Version v2) {
    return v1.compareTo(v2);
  }

  int compareAreas(String a, String b) {
    if (a == b) return 0;
    // 1. SDK at the top
    if (a == 'SDK') return -1;
    if (b == 'SDK') return 1;
    // 2. Language second
    if (a == 'Language') return -1;
    if (b == 'Language') return 1;
    // 3. Docs at the bottom
    if (a == 'Docs') return 1;
    if (b == 'Docs') return -1;
    // 4. Everything else alphabetical
    return a.compareTo(b);
  }

  /// Filters [entries] based on [searchQuery] and selected filters.
  ///
  /// Returns a new list containing only the entries that match:
  ///
  /// - Any selected tag (or all if none selected).
  /// - Any selected area (or all if none selected).
  /// - Any selected version (or all if none selected).
  /// - The search query (matched against description, area, subarea, version).
  List<ChangelogEntry> filterEntries(
    List<ChangelogEntry> entries,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty &&
        selectedTags.isEmpty &&
        selectedAreas.isEmpty &&
        selectedVersions.isEmpty) {
      return entries;
    }

    final entriesToShow = <ChangelogEntry>[];
    final normalizedQuery = searchQuery.trim().toLowerCase();

    for (final entry in entries) {
      final matchesTags =
          selectedTags.isEmpty || entry.tags.any(selectedTags.contains);
      if (!matchesTags) continue;

      final matchesAreas =
          selectedAreas.isEmpty || selectedAreas.contains(entry.area);
      if (!matchesAreas) continue;

      final matchesVersions =
          selectedVersions.isEmpty ||
          selectedVersions.contains(
            Version(entry.version.major, entry.version.minor, 0),
          );
      if (!matchesVersions) continue;

      final matchesSearchQuery =
          normalizedQuery.isEmpty ||
          entry.description.toLowerCase().contains(normalizedQuery) ||
          entry.area.toLowerCase().contains(normalizedQuery) ||
          (entry.subArea?.toLowerCase().contains(normalizedQuery) ?? false) ||
          entry.version.toString().contains(normalizedQuery);

      if (!matchesSearchQuery) continue;

      entriesToShow.add(entry);
    }

    return entriesToShow;
  }

  /// Parses a version token such as `3.13`, `3.13.0`, `v3.13`, or `v3-13`
  /// into a normalized `Version(major, minor, 0)`, or returns `null`.
  static Version? tryParseShortVersion(String raw) {
    var cleaned = raw.trim();
    if (cleaned.startsWith('v') || cleaned.startsWith('V')) {
      cleaned = cleaned.substring(1);
    }
    cleaned = cleaned.replaceAll('-', '.');
    if (_versionXyRegex.hasMatch(cleaned)) {
      cleaned = '$cleaned.0';
    }
    try {
      final parsed = Version.parse(cleaned);
      return Version(parsed.major, parsed.minor, 0);
    } catch (_) {
      return null;
    }
  }

  /// Serializes the current filter state into a URL `#fragment` string
  /// (without the leading `#`).
  String toUrlFragment({String searchQuery = '', String? targetId}) {
    final parts = <String>[];

    if (selectedTags.isNotEmpty) {
      final orderedTags = [
        for (final tag in ChangelogTag.values)
          if (tag != ChangelogTag.none && selectedTags.contains(tag)) tag.id,
      ];
      if (orderedTags.isNotEmpty) {
        parts.add('tags=${orderedTags.join(',')}');
      }
    }

    if (selectedAreas.isNotEmpty) {
      final orderedAreas = selectedAreas.toList()..sort(compareAreas);
      parts.add(
        'area=${orderedAreas.map(Uri.encodeQueryComponent).join(',')}',
      );
    }

    if (selectedVersions.isNotEmpty) {
      final orderedVersions = selectedVersions.toList()
        ..sort((a, b) => compareVersions(b, a));
      parts.add(
        'versions=${orderedVersions.map((v) => v.shortVersion).join(',')}',
      );
    }

    final trimmedQuery = searchQuery.trim();
    if (trimmedQuery.isNotEmpty) {
      parts.add('q=${Uri.encodeQueryComponent(trimmedQuery)}');
    }

    final trimmedTargetId = targetId?.trim();
    if (trimmedTargetId != null && trimmedTargetId.isNotEmpty) {
      parts.add('id=${Uri.encodeQueryComponent(trimmedTargetId)}');
    }

    return parts.join('&');
  }

  static const List<String> _canonicalAreas = [
    'SDK',
    'Language',
    'Libraries',
    'Tools',
    'Dart Runtime',
    'Web',
    'Docs',
  ];

  String? _resolveAreaName(String rawArea) {
    final normalized = rawArea.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final area in availableAreas) {
      if (area.toLowerCase() == normalized) {
        return area;
      }
    }
    for (final area in _canonicalAreas) {
      if (area.toLowerCase() == normalized) {
        return area;
      }
    }
    return rawArea.trim();
  }

  /// Parses a URL `#fragment` and updates the filter state.
  ///
  /// Supports two grammar modes:
  /// - **Direct Card/Version Anchor** (no `=` in fragment, e.g. `#v3-13` or
  ///   `#v3-13-0-language-primary-constructors-0`): clears hiding filters and
  ///   returns the anchor as `targetId`.
  /// - **Structured Filter Hash** (contains `=`, e.g.
  ///   `#from=3.5&to=3.13&tags=breaking&area=Language&q=macro`): hydrates
  ///   [selectedTags], [selectedAreas], [selectedVersions], and returns the
  ///   parsed `searchQuery` and optional `targetId`.
  ({String searchQuery, String? targetId, bool isFilterHash})
  parseAndApplyUrlFragment(String rawFragment) {
    final fragment = rawFragment.startsWith('#')
        ? rawFragment.substring(1).trim()
        : rawFragment.trim();

    selectedTags.clear();
    selectedAreas.clear();
    selectedVersions.clear();

    if (fragment.isEmpty) {
      notifyListeners();
      return (searchQuery: '', targetId: null, isFilterHash: false);
    }

    // Case A: Direct Card or Version Anchor (no '=' in hash)
    if (!fragment.contains('=')) {
      notifyListeners();
      final decodedId = Uri.decodeComponent(fragment);
      return (
        searchQuery: '',
        targetId: decodedId.isNotEmpty ? decodedId : null,
        isFilterHash: false,
      );
    }

    // Case B: Structured Filter Hash (key=value pairs)
    final Map<String, String> params;
    try {
      params = Uri.splitQueryString(fragment);
    } catch (_) {
      notifyListeners();
      return (searchQuery: '', targetId: null, isFilterHash: true);
    }

    final rawTags = params['tags'] ?? params['tag'];
    if (rawTags != null && rawTags.isNotEmpty) {
      for (final token in rawTags.split(',')) {
        final tag = ChangelogTag.fromId(token.trim().toLowerCase());
        if (tag != ChangelogTag.none) {
          selectedTags.add(tag);
        }
      }
    }

    final rawAreas = params['area'] ?? params['areas'];
    if (rawAreas != null && rawAreas.isNotEmpty) {
      for (final token in rawAreas.split(',')) {
        final resolved = _resolveAreaName(token);
        if (resolved != null) {
          selectedAreas.add(resolved);
        }
      }
    }

    final rawVersions = params['versions'] ?? params['version'];
    if (rawVersions != null && rawVersions.isNotEmpty) {
      for (final token in rawVersions.split(',')) {
        final trimmed = token.trim().toLowerCase();
        final majorMatch = RegExp(r'^(\d+)(?:\.x)?$').firstMatch(trimmed);
        if (majorMatch != null) {
          final major = int.tryParse(majorMatch.group(1)!);
          if (major != null) {
            selectedVersions.addAll(
              availableVersions.where((v) => v.major == major),
            );
          }
          continue;
        }
        final parsedVersion = tryParseShortVersion(trimmed);
        if (parsedVersion != null &&
            (availableVersions.isEmpty ||
                availableVersions.contains(parsedVersion))) {
          selectedVersions.add(parsedVersion);
        }
      }
    }

    final fromVersion = params['from'] != null
        ? tryParseShortVersion(params['from']!)
        : null;
    final toVersion = params['to'] != null
        ? tryParseShortVersion(params['to']!)
        : null;
    if (fromVersion != null || toVersion != null) {
      for (final version in availableVersions) {
        final afterFrom = fromVersion == null || version >= fromVersion;
        final upTo = toVersion == null || version <= toVersion;
        if (afterFrom && upTo) {
          selectedVersions.add(version);
        }
      }
    }

    final parsedQuery = (params['q'] ?? params['search'] ?? '').trim();
    final targetId = params['id']?.trim();

    notifyListeners();
    return (
      searchQuery: parsedQuery,
      targetId: (targetId != null && targetId.isNotEmpty) ? targetId : null,
      isFilterHash: true,
    );
  }
}
