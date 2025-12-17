// Copyright 2025 The Dart Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

    // Resolve liquid variables
    // Note: We no longer manually replace liquid variables here.
    // Data should be pre-processed or contain valid links/text.

    return ChangelogEntry(
      description: description,
      version: map['version']
          .toString()
          .trim(), // Ensure version is string even if e.g. 3.0
      releaseDate: map['releaseDate']?.toString(),
      area: map['area'] as String,
      subArea: map['subArea'] as String?,
      tags:
          (map['tags'] as List<Object?>?)
              ?.cast<String>()
              .map(ChangelogTag.fromId)
              .toList() ??
          [],
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
      version: (element.getAttribute('data-version') ?? '').trim(),
      releaseDate: element.getAttribute('data-releasedate'),
      area: element.getAttribute('data-area') ?? '',
      subArea: element.getAttribute('data-subarea'),
      tags: dataTags.isEmpty
          ? []
          : dataTags.split(',').map(ChangelogTag.fromId).toList(),
      link: element.getAttribute('data-link'),
    );
  }

  final String description;
  final String version;
  final String? releaseDate;
  final String area;
  final String? subArea;
  final List<ChangelogTag> tags;
  final String? link;

  static String getShortVersion(String version) {
    final parts = version.split('.');
    if (parts.length >= 2) {
      return '${parts[0]}.${parts[1]}';
    }
    return version;
  }

  String get shortVersion => getShortVersion(version);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangelogEntry &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          version == other.version &&
          releaseDate == other.releaseDate &&
          area == other.area &&
          subArea == other.subArea &&
          link == other.link &&
          tags.length == other.tags.length &&
          tags.asMap().entries.every((e) => e.value == other.tags[e.key]);

  @override
  int get hashCode =>
      description.hashCode ^
      version.hashCode ^
      releaseDate.hashCode ^
      area.hashCode ^
      subArea.hashCode ^
      link.hashCode ^
      Object.hashAll(tags);
}

enum ChangelogTag {
  newTag('new', 'New'),
  breaking('breaking', 'Breaking'),
  fixed('fixed', 'Fixed'),
  changed('changed', 'Changed'),
  experimental('experimental', 'Experimental'),
  versioned('versioned', 'Language versioned'),
  deprecated('deprecated', 'Deprecated'),
  removed('removed', 'Removed'),
  none('none', 'None')
  ;

  const ChangelogTag(this.id, this.label);

  final String id;
  final String label;

  static ChangelogTag fromId(String id) {
    return ChangelogTag.values.firstWhere(
      (tag) => tag.id == id.toLowerCase(),
      orElse: () => ChangelogTag.none,
    );
  }
}
