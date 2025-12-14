import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

import '../util.dart';

class BlogDataLoader implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    // Only load blog data for the blog index page
    print('BlogDataLoader: Checking page path: ${page.path}');
    // Allow blog/index, blog, and blog/index.md (just to be safe)
    if (page.path != 'blog/index' &&
        page.path != 'blog' &&
        page.path != 'blog/index.md') {
      return;
    }

    final blogDir = Directory(p.join(siteSrcDirectoryPath, 'content', 'blog'));
    if (!blogDir.existsSync()) {
      return;
    }

    final posts = <Map<String, dynamic>>[];

    // Simple memory cache for GitHub users to avoid hitting rate limits
    // during a single build
    final githubCache = <String, Map<String, String>>{};

    for (final entity in blogDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (p.extension(entity.path) != '.md') continue;
      // Exclude the root index.md of the blog
      if (p.basename(entity.path) == 'index.md' &&
          entity.parent.path == blogDir.path) {
        continue;
      }

      final file = entity;
      final fileContent = file.readAsStringSync();
      final frontmatter = _parseFrontmatter(fileContent);

      String authorName = frontmatter['author'] ?? 'Dart Team';
      String? avatarUrl;
      String? profileUrl;
      final handle = frontmatter['github_handle'];

      if (handle != null) {
        profileUrl = 'https://github.com/$handle';
        avatarUrl = 'https://github.com/$handle.png';

        // Try to fetch real name if not in cache
        if (githubCache.containsKey(handle)) {
          authorName = githubCache[handle]!['name']!;
        } else {
          try {
            // Note: In a real CI/CD environment, you'd want a GITHUB_TOKEN here.
            // For local dev/static sites, unauthenticated requests usually suffice
            // for small volume.
            final url = Uri.parse('https://api.github.com/users/$handle');
            final response = await http.get(
              url,
              headers: {
                // User-Agent is required by GitHub API
                'User-Agent': 'Dart-Blog-Loader',
                'Accept': 'application/vnd.github.v3+json',
              },
            );

            if (response.statusCode == 200) {
              final data = jsonDecode(response.body) as Map<String, dynamic>;
              if (data['name'] != null) {
                authorName = data['name'] as String;
              }
            }
            // Cache the result (even if failed, to avoid retrying)
            githubCache[handle] = {'name': authorName};
          } catch (e) {
            print('Failed to fetch GitHub data for $handle: $e');
            // Fallback is already set to default or whatever we have
          }
        }
      }

      String? image = frontmatter['image'];
      if (image != null &&
          !image.startsWith('http') &&
          !image.startsWith('/')) {
        final pathFromContent = p.relative(
          file.parent.path,
          from: p.join(siteSrcDirectoryPath, 'content'),
        );
        image = p.join('/images/content', pathFromContent, image);
      }

      posts.add({
        'title': frontmatter['title'] ?? 'Untitled',
        'date': frontmatter['date'] ?? '',
        'description': frontmatter['description'] ?? '',
        'href':
            '/blog/${p.basenameWithoutExtension(file.path) == 'index' ? p.basename(file.parent.path) : p.basenameWithoutExtension(file.path)}',
        'image': image,
        'author': authorName,
        'avatar': avatarUrl,
        'author_url': profileUrl,
        'category': frontmatter['category']?.toLowerCase() ?? 'all',
      });
    }

    // Sort by date descending
    posts.sort((a, b) {
      final dateA =
          DateTime.tryParse(a['date'] as String? ?? '') ?? DateTime(1970);
      final dateB =
          DateTime.tryParse(b['date'] as String? ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA);
    });

    page.apply(data: {'blog_posts': posts});
  }

  Map<String, String> _parseFrontmatter(String content) {
    final match = RegExp(r'^---\n(.*?)\n---', dotAll: true).firstMatch(content);
    if (match == null) return {};

    final yamlContent = match.group(1)!;
    final map = <String, String>{};

    for (final line in yamlContent.split('\n')) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        var value = parts.sublist(1).join(':').trim();
        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        }
        map[key] = value;
      }
    }
    return map;
  }
}
