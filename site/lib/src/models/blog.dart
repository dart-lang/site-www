// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:jaspr_content/jaspr_content.dart';

extension type Post(Map<String, Object?> data) {
  static Post? tryParse(Map<String, Object?> data) {
    if (data['title'] is! String ||
        data['description'] is! String ||
        data['publishDate'] is! String ||
        data['author'] is! String) {
      return null;
    }
    return Post(data);
  }

  String get title => data['title'] as String;
  String get description => data['description'] as String;
  String? get image => data['image'] as String?;
  String get publishDate => data['publishDate'] as String;

  DateTime get dateObject => DateTime.parse(publishDate);
  String get formattedDate => DateFormat.yMMMd().format(dateObject);

  String get authorId => data['author'] as String;

  String get readingTime => data['readingTime'] as String? ?? '5 min read';
  String? get category => data['category'] as String?;
}

extension type Author(Map<String, Object?> data) {
  String get name => data['name'] as String;
  String? get bio => data['bio'] as String?;
  String? get image => data['image'] as String?;
  String? get twitter => data['twitter'] as String?;
  AuthorGithub? get github => data['github'] as AuthorGithub?;
}

extension type AuthorGithub(Map<String, Object?> data) {
  String get handle => data['handle'] as String;
  String? get name => data['username'] as String?;
  String? get avatarUrl => data['avatar_url'] as String?;
}

extension GetAuthor on Page {
  Author getAuthor(String id) {
    final authors = data['authors'];
    if (authors is! Map<String, Object?>) {
      throw Exception('Authors data not found or invalid.');
    }

    final author = authors[id];
    if (author == null) {
      throw Exception('Author not found: $id');
    }
    if (author is! Map<String, Object?>) {
      throw Exception('Author data not found or invalid: $id');
    }
    return Author(author);
  }
}
