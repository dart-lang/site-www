// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../models/blog.dart';

class BlogCard extends StatelessComponent {
  const BlogCard({
    required this.post,
    required this.url,
    this.className,
    this.priority = BlogCardPriority.normal,
    super.key,
  });

  final Post post;
  final String url;
  final String? className;
  final BlogCardPriority priority;

  @override
  Component build(BuildContext context) {
    final authors = context.page.authorsFor(post);
    final authorNames = _formatAuthorNames(authors);

    final avatars = [
      for (final author in authors)
        if (author.image case final authorImagePath?)
          img(
            classes: 'blog-card-avatar',
            src: context.resolveAsset('/blog/authors/$authorImagePath'),
            alt: author.name,
          )
        else if (author.github?.avatarUrl case final avatarUrl?)
          img(classes: 'blog-card-avatar', src: avatarUrl, alt: author.name),
    ];

    return a(
      href: url,
      classes: 'blog-card ${className ?? ''}',
      attributes: {'data-category': post.category ?? 'other'},
      [
        if (post.image case final postImage?)
          div(classes: 'blog-card-image', [
            img(
              src: postImage,
              alt: post.title,
              loading: switch (priority) {
                .featured => MediaLoading.eager,
                .high => null,
                .normal => MediaLoading.lazy,
              },
              attributes: {
                if (priority == .featured)
                  'fetchpriority': 'high'
                else if (priority == .normal)
                  'decoding': 'async',
              },
            ),
          ]),
        div(classes: 'blog-card-content', [
          h3(classes: 'blog-card-title', [
            .text(post.title),
          ]),
          p(classes: 'blog-card-description', [
            .text(post.description),
          ]),
          const span(classes: 'blog-card-spacer', []),
          div(classes: 'blog-card-meta', [
            div(classes: 'blog-card-author-row', [
              if (avatars.isNotEmpty)
                div(classes: 'blog-card-avatars', avatars),
              span(classes: 'author', [
                .text(authorNames),
              ]),
              const span(classes: 'separator', [.text(' · ')]),
              span(classes: 'date', [
                .text(post.formattedDate),
              ]),
              const span(classes: 'separator', [.text(' · ')]),
              span(classes: 'reading-time', [
                .text(post.readingTime),
              ]),
            ]),
          ]),
        ]),
      ],
    );
  }
}

/// Priority levels for blog cards.
///
/// Used to configure loading behavior of their content, particularly images.
enum BlogCardPriority {
  /// A featured blog card.
  featured,

  /// A high-priority blog card.
  ///
  /// Often the first 5 or so cards.
  high,

  /// A normal-priority blog card.
  normal,
}

/// Joins the names of [authors] into a
/// single human-readable string for the card's byline.
String _formatAuthorNames(Iterable<Author> authors) {
  final authorNames = authors
      .map((author) => author.name)
      .toList(growable: false);

  return switch (authorNames) {
    [] => '',
    [final name] => name,
    [final first, final second] => '$first and $second',
    [...final initial, final last] => '${initial.join(', ')}, and $last',
  };
}
