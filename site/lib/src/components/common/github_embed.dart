// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

class GitHubEmbed extends StatelessComponent {
  const GitHubEmbed({
    required this.repo,
    required this.title,
    this.image,
    super.key,
  });

  final String repo;
  final String title;
  final String? image;

  static GitHubEmbed fromAttributes(Map<String, String> attributes) {
    return GitHubEmbed(
      repo: attributes['repo'] ?? '',
      title: attributes['title'] ?? '',
      image: attributes['image'],
    );
  }

  @override
  Component build(BuildContext context) {
    return a(
      href: 'https://github.com/$repo',
      target: Target.blank,
      classes: 'github-embed',
      attributes: {'rel': 'noopener'},
      [
        div(classes: 'github-embed-content', [
          div(classes: 'github-embed-text', [
            div(classes: 'github-embed-title', [.text(repo)]),
            div(classes: 'github-embed-description', [.text(title)]),
            const div(classes: 'github-embed-footer', [.text('github.com')]),
          ]),
          if (image case final image?)
            div(classes: 'github-embed-image', [
              img(src: context.resolveAsset(image), alt: ''),
            ]),
        ]),
      ],
    );
  }
}
