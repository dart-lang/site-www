// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:universal_web/web.dart' as web;

final class ChangelogEntry {
  ChangelogEntry({
    required this.description,
    required this.version,
    this.releaseDate,
    required this.area,
    this.subArea,
    required this.tags,
    this.link,
  });

  factory ChangelogEntry.fromMap(Map<String, Object?> map) {
    final description = map['description'] as String;
    final link = map['link'] as String?;

    return ChangelogEntry(
      description: description,
      version: _parseVersion(map['version'].toString().trim()),
      releaseDate: map['releaseDate']?.toString(),
      area: map['area'] as String,
      subArea: map['subArea'] as String?,
      tags:
          (map['tags'] as List<Object?>?)
              ?.cast<String>()
              .map(ChangelogTag.fromId)
              .where((tag) => tag != ChangelogTag.none)
              .toSet() ??
          {},
      link: link,
    );
  }

  factory ChangelogEntry.fromElement(web.Element element) {
    final dataTags = element.getAttribute('data-tags') ?? '';
    // Use textContent for description to avoid data-description bloat.
    final contentElement = element.querySelector('.card-content') ?? element;
    final description = contentElement.textContent ?? '';

    return ChangelogEntry(
      description: description,
      version: _parseVersion(
        (element.getAttribute('data-version') ?? '').trim(),
      ),
      releaseDate: element.getAttribute('data-releasedate'),
      area: element.getAttribute('data-area') ?? '',
      subArea: element.getAttribute('data-subarea'),
      tags: dataTags.isEmpty
          ? {}
          : dataTags
                .split(',')
                .map((t) => t.trim())
                .where((t) => t.isNotEmpty)
                .map(ChangelogTag.fromId)
                .where((tag) => tag != ChangelogTag.none)
                .toSet(),
      link: element.getAttribute('data-link'),
    );
  }

  final String description;
  final Version version;
  final String? releaseDate;
  final String area;
  final String? subArea;
  final Set<ChangelogTag> tags;
  final String? link;

  static Version _parseVersion(String version) {
    if (RegExp(r'^\d+\.\d+$').hasMatch(version)) {
      return Version.parse('$version.0');
    }
    return Version.parse(version);
  }

  String get shortVersion => version.shortVersion;

  Map<String, Object?> toMap() {
    return {
      'description': description,
      'version': version,
      'releaseDate': releaseDate,
      'area': area,
      'subArea': subArea,
      'tags': tags,
      'link': link,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangelogEntry &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(toMap(), other.toMap());

  @override
  int get hashCode => const DeepCollectionEquality().hash(toMap());
}

extension ChangelogVersionExtension on Version {
  String get shortVersion => '$major.$minor';
}

enum ChangelogTag {
  newTag('new', 'New', 'New feature or capability'),
  breaking('breaking', 'Breaking', 'Change that might break existing code'),
  fixed('fixed', 'Fixed', 'Bug fix or error resolution'),
  changed('changed', 'Changed', 'Modification to existing behavior'),
  experimental('experimental', 'Experimental', 'Feature not yet stable'),
  languageVersioned(
    'versioned',
    'Language versioned',
    'Change tied to a specific language version',
  ),
  deprecated('deprecated', 'Deprecated', 'Feature scheduled for removal'),
  removed('removed', 'Removed', 'Feature no longer available'),
  none('none', 'None', '')
  ;

  const ChangelogTag(this.id, this.label, this.description);

  final String id;
  final String label;
  final String description;

  static ChangelogTag fromId(String id) {
    return ChangelogTag.values.firstWhere(
      (tag) => tag.id == id.toLowerCase(),
      orElse: () => ChangelogTag.none,
    );
  }
}
