// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// The blog-relevant data of a single blog post.
extension type Post(Map<String, Object?> data) {
  /// A [Post] wrapping [data] if it has the fields every post requires,
  /// or `null` otherwise.
  ///
  /// Valid [data] provides
  /// string `title`, `description`, and `publishDate` values,
  /// as well as a `authors` list of author IDs.
  static Post? tryParse(Map<String, Object?> data) {
    if (data['title'] is! String ||
        data['description'] is! String ||
        data['publishDate'] is! String) {
      return null;
    }
    final authors = data['authors'];
    if (authors is! List<Object?> || authors.isEmpty) return null;
    for (final author in authors) {
      if (author is! String || author.isEmpty) return null;
    }
    return Post(data);
  }

  /// The post's title.
  String get title => data['title'] as String;

  /// A short summary of the post, shown in listings and feed entries.
  String get description => data['description'] as String;

  /// The path or URL of the post's hero image, or `null` if it has none.
  String? get image => data['image'] as String?;

  /// The date the post was published, as an ISO 8601 date string.
  String get publishDate => data['publishDate'] as String;

  /// The [publishDate] parsed into a [DateTime].
  DateTime get dateObject => DateTime.parse(publishDate);

  /// The [publishDate] formatted for display, such as `Jun 2, 2026`.
  String get formattedDate => DateFormat.yMMMd().format(dateObject);

  /// The IDs of the post's authors, in display order.
  ///
  /// Each ID can be resolved to an [Author] through [PageAuthors.authorsFor].
  List<String> get authorIds =>
      (data['authors'] as List<Object?>).cast<String>();

  /// The estimated reading time, such as `5 min read`.
  ///
  /// Defaults to `5 min read` when the post doesn't specify one.
  String get readingTime => data['readingTime'] as String? ?? '5 min read';

  /// The post's category slug, or `null` if it's uncategorized.
  String? get category => data['category'] as String?;
}

/// A blog author, as defined in the site's author data.
///
/// Authors are referenced by a post's [Post.authorIds] and
/// can be into a [Author] by using [PageAuthors.authorsFor].
extension type Author(Map<String, Object?> data) {
  /// The author's display name.
  String get name => data['name'] as String;

  /// A short biography of the author, or `null` if none is provided.
  String? get bio => data['bio'] as String?;

  /// The filename of the author's avatar within `/blog/authors/`, or `null`
  /// to fall back to another image such as [AuthorGithub.avatarUrl].
  String? get image => data['image'] as String?;

  /// The author's Twitter handle, without the leading `@`,
  /// or `null` if they don't have one listed.
  String? get twitter => data['twitter'] as String?;

  /// The author's GitHub details, or `null` if none are provided.
  ///
  /// Throws if the underlying data is present but not a map.
  AuthorGithub? get github => switch (data['github']) {
    null => null,
    final Map<String, Object?> github => AuthorGithub(github),
    final malformedValue => throw Exception(
      'Author GitHub data is in an unexpected format: $malformedValue',
    ),
  };

  /// A URL linking to the author's profile, or `null` if none is available.
  ///
  /// Prefers the author's [github] handle,
  /// then falls back to their [twitter] handle.
  String? get profileUrl {
    final githubHandle = github?.handle;
    if (githubHandle != null && githubHandle.isNotEmpty) {
      return 'https://github.com/$githubHandle';
    }

    final twitterHandle = twitter;
    if (twitterHandle != null && twitterHandle.isNotEmpty) {
      return 'https://twitter.com/$twitterHandle';
    }

    return null;
  }
}

/// The GitHub account details of an [Author].
extension type AuthorGithub(Map<String, Object?> data) {
  /// The author's GitHub username, used to build their [Author.profileUrl].
  String get handle => data['handle'] as String;

  /// The author's name as it appears on GitHub, or `null` if unknown.
  String? get name => data['username'] as String?;

  /// The URL of the author's GitHub avatar image, or `null` if unknown.
  String? get avatarUrl => data['avatar_url'] as String?;
}

/// Exposes [authorsFor] to look up the blog authors defined in a [Page]'s data.
extension PageAuthors on Page {
  /// The [Author]s of the specified [post],
  /// resolved from this page's `authors` data in the
  /// order given by [Post.authorIds].
  ///
  /// Throws if this page has no `authors` data,
  /// or if any of the post's author IDs is missing from it.
  List<Author> authorsFor(Post post) {
    final authors = data['authors'];
    if (authors is! Map<String, Object?>) {
      throw Exception('Authors data not found or invalid.');
    }
    return [
      for (final id in post.authorIds)
        switch (authors[id]) {
          final Map<String, Object?> author => Author(author),
          _ => throw Exception('Author not found or invalid format: $id'),
        },
    ];
  }
}
